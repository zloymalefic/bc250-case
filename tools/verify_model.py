#!/usr/bin/env python3
"""Verify generated BC-250 STL assets without relying on visual inspection."""

from __future__ import annotations

import argparse
from collections import Counter
from pathlib import Path
import re
import shutil
import subprocess
import tempfile

REPO = Path(__file__).resolve().parent.parent
CORE = REPO / "cad/core-assembly-v0.1.scad"

# Expected print-space envelopes. Values are maxima, not desired dimensions.
LIMITS = {
    "front-core.stl": (175, 155, 200),
    "rear-core.stl": (165, 155, 200),
    "front-panel.stl": (155, 195, 13),
    "front-usb-cassette.stl": (36, 106, 15),
    "intake-cover-left.stl": (130, 131, 4.1),
    "intake-cover-right.stl": (130, 131, 4.1),
    "esp32-cover.stl": (98, 40, 19.1),
    "rear-cover-horizontal.stl": (6.1, 155, 195),
    "rear-cover-vertical.stl": (44.1, 185, 225),
}


def vertices(path: Path):
    found = []
    for line in path.read_text(encoding="utf-8", errors="strict").splitlines():
        fields = line.split()
        if len(fields) == 4 and fields[0] == "vertex":
            found.append(tuple(round(float(value), 5) for value in fields[1:]))
    if not found or len(found) % 3:
        raise ValueError("not a valid ASCII triangle STL")
    return found


def inspect_stl(path: Path) -> list[str]:
    problems = []
    try:
        points = vertices(path)
    except (OSError, UnicodeError, ValueError) as exc:
        return [f"cannot read geometry: {exc}"]
    triangles = [points[index:index + 3] for index in range(0, len(points), 3)]
    if any(len(set(triangle)) != 3 for triangle in triangles):
        problems.append("contains degenerate triangles")
    edges = Counter(
        tuple(sorted((triangle[index], triangle[(index + 1) % 3])))
        for triangle in triangles for index in range(3)
    )
    open_edges = sum(count != 2 for count in edges.values())
    if open_edges:
        problems.append(f"mesh is not closed/manifold ({open_edges} bad edges)")
    mins = tuple(min(point[axis] for point in points) for axis in range(3))
    maxs = tuple(max(point[axis] for point in points) for axis in range(3))
    size = tuple(maxs[axis] - mins[axis] for axis in range(3))
    limit = LIMITS.get(path.name)
    if limit and any(size[axis] > limit[axis] + 0.05 for axis in range(3)):
        problems.append(f"bounds {size} exceed contract {limit}")
    if max(size) > 250.05:
        problems.append(f"print envelope exceeds 250 mm: {size}")
    return problems


def compile_constraints(openscad: str) -> list[str]:
    with tempfile.TemporaryDirectory(prefix="bc250-verify-") as temp:
        output = Path(temp) / "fit-audit.stl"
        result = subprocess.run(
            [openscad, "-o", str(output), "-D", 'part="fit-audit"', str(CORE)],
            cwd=REPO, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
        )
    failures = [line for line in result.stdout.splitlines()
                if re.search(r"\b(ERROR|Assertion)\b", line, re.IGNORECASE)]
    if result.returncode:
        failures.append(f"OpenSCAD returned {result.returncode}")
    return failures


def verify_assets(asset_dir: Path, *, compile_cad: bool = True) -> list[str]:
    failures = []
    for name in LIMITS:
        path = asset_dir / name
        if not path.is_file():
            failures.append(f"{name}: missing")
            continue
        failures.extend(f"{name}: {problem}" for problem in inspect_stl(path))
    if compile_cad:
        openscad = shutil.which("openscad")
        if not openscad:
            failures.append("OpenSCAD CLI not found")
        else:
            failures.extend(f"CAD: {problem}" for problem in compile_constraints(openscad))
    return failures


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("asset_dir", nargs="?", type=Path,
                        default=REPO / "visualization/assets")
    parser.add_argument("--no-compile", action="store_true")
    args = parser.parse_args()
    failures = verify_assets(args.asset_dir, compile_cad=not args.no_compile)
    if failures:
        print("MODEL VERIFICATION FAILED")
        for failure in failures:
            print(f"  - {failure}")
        raise SystemExit(1)
    print(f"MODEL VERIFICATION PASSED: {len(LIMITS)} critical STL files + CAD constraints")


if __name__ == "__main__":
    main()

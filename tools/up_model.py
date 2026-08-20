#!/usr/bin/env python3
"""Audit CAD inputs and atomically refresh derived viewer STL assets."""

from __future__ import annotations

import argparse
import hashlib
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile

from verify_model import verify_assets

REPO = Path(__file__).resolve().parent.parent
ASSETS = REPO / "visualization" / "assets"
SOURCE_ROOTS = (REPO / "cad", REPO / "cad-visualization")

EXPORTS = (
    *((name, REPO / "cad/core-assembly-v0.1.scad", name) for name in (
        "front-core", "rear-core", "board-spine-front", "board-spine-rear",
        "front-panel", "front-button-mount", "front-usb-cassette",
        "ssd-cassette", "esp32-cassette", "esp32-cover",
        "rear-cover-horizontal", "rear-cover-vertical",
    )),
    ("intake-cover-left", REPO / "cad/intake-panel-snap-v0.1.scad", "left"),
    ("intake-cover-right", REPO / "cad/intake-panel-snap-v0.1.scad", "right"),
    *((name, REPO / "cad-visualization/visualization-reference-parts.scad", name)
      for name in ("button-plate", "button-light-pipe", "usb-cover")),
    ("button-cap-black", REPO / "cad-visualization/visualization-nexgen-button-material.scad", "black"),
    ("button-logo-white", REPO / "cad-visualization/visualization-nexgen-button-material.scad", "white"),
    ("button-decorative-bezel", REPO / "cad-visualization/visualization-decorative-button.scad", None),
)


def digest(path: Path) -> str:
    value = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            value.update(block)
    return value.hexdigest()


def geometry_digest(path: Path) -> str:
    """Hash ASCII STL geometry independent of facet and vertex ordering."""
    triangles: list[tuple[tuple[float, float, float], ...]] = []
    vertices: list[tuple[float, float, float]] = []
    with path.open(encoding="utf-8", errors="strict") as stream:
        for line in stream:
            fields = line.split()
            if len(fields) == 4 and fields[0] == "vertex":
                vertices.append(tuple(round(float(value), 4) for value in fields[1:]))
                if len(vertices) == 3:
                    triangles.append(tuple(sorted(vertices)))
                    vertices = []
    if vertices or not triangles:
        raise ValueError(f"Некорректный или неподдерживаемый STL: {path}")
    canonical = repr(sorted(triangles)).encode("ascii")
    return hashlib.sha256(canonical).hexdigest()


def source_snapshot() -> dict[Path, str]:
    return {
        path: digest(path)
        for root in SOURCE_ROOTS
        for path in root.rglob("*")
        if path.is_file()
    }


def find_openscad() -> str | None:
    executable = shutil.which("openscad")
    if executable:
        return executable
    candidates = (
        Path("/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"),
        Path(os.environ.get("ProgramFiles", "C:/Program Files")) / "OpenSCAD/openscad.exe",
    )
    return next((str(path) for path in candidates if path.exists()), None)


def viewer_stls() -> set[str]:
    text = (REPO / "visualization/viewer.js").read_text(encoding="utf-8")
    return {Path(value).name for value in re.findall(r"['\"]([^'\"]+\.stl)['\"]", text)}


def update_assets(*, check: bool = False) -> int:
    missing_sources = sorted({source for _, source, _ in EXPORTS if not source.is_file()})
    required_vendor = (
        REPO / "cad/vendor/nexgen/button-cap-black.3mf",
        REPO / "cad/vendor/nexgen/button-logo-white.3mf",
    )
    missing_sources.extend(path for path in required_vendor if not path.is_file())
    if missing_sources:
        print("Не хватает исходных файлов:")
        for path in missing_sources:
            print(f"  - {path.relative_to(REPO)}")
        return 2

    openscad = find_openscad()
    if not openscad:
        print("OpenSCAD CLI не найден. См. visualization/SETUP.md.")
        return 2

    before = source_snapshot()
    changed: list[str] = []
    unchanged: list[str] = []
    with tempfile.TemporaryDirectory(prefix="bc250-up-model-") as temp_name:
        temp = Path(temp_name)
        for index, (name, source, part) in enumerate(EXPORTS, 1):
            target = temp / f"{name}.stl"
            command = [openscad, "-o", str(target)]
            if part is not None:
                command += ["-D", f'part="{part}"']
            command.append(str(source))
            print(f"[{index:02}/{len(EXPORTS)}] {name}", flush=True)
            result = subprocess.run(command, cwd=REPO)
            if result.returncode or not target.is_file():
                print(f"Ошибка экспорта: {name}")
                return 3
            current = ASSETS / target.name
            if not current.is_file() or geometry_digest(current) != geometry_digest(target):
                changed.append(target.name)
            else:
                unchanged.append(target.name)

        verification_failures = verify_assets(temp, compile_cad=True)
        if verification_failures:
            print("ОШИБКА ВЕРИФИКАЦИИ; существующие STL не изменены:")
            for failure in verification_failures:
                print(f"  - {failure}")
            return 6

        if not check:
            ASSETS.mkdir(parents=True, exist_ok=True)
            for name in changed:
                target = temp / name
                current = ASSETS / name
                staged = ASSETS / f".{name}.new"
                shutil.copy2(target, staged)
                os.replace(staged, current)

    after = source_snapshot()
    if before != after:
        print("ОШИБКА: исходники cad/ или cad-visualization/ изменились во время обновления.")
        return 4

    missing_assets = sorted(viewer_stls() - {path.name for path in ASSETS.glob("*.stl")})
    external_board = REPO / "references/hafriedlander-bc250-case/_extern/bc250_alt.stl"
    missing_assets = [name for name in missing_assets if name != external_board.name]
    if missing_assets:
        print("Viewer ссылается на отсутствующие assets:")
        for name in missing_assets:
            print(f"  - visualization/assets/{name}")
        return 5
    if not external_board.is_file():
        print("ПРЕДУПРЕЖДЕНИЕ: отсутствует внешняя модель BC-250: "
              "references/hafriedlander-bc250-case/_extern/bc250_alt.stl")

    verb = "Требуют обновления" if check else "Обновлены"
    print(f"{verb}: {', '.join(changed) if changed else 'нет'}")
    print(f"Совпадают: {len(unchanged)}; исходники не изменялись.")
    return 1 if check and changed else 0


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="только проверить, не заменять assets")
    args = parser.parse_args()
    raise SystemExit(update_assets(check=args.check))


if __name__ == "__main__":
    main()

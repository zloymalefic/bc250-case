#!/usr/bin/env python3
"""Zero-dependency development server and CAD watcher for the 3D viewer."""

from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import threading
import time
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer

REPO = Path(__file__).resolve().parent.parent
ASSETS = REPO / "visualization" / "assets"
MASTER = REPO / "cad" / "core-assembly-v0.1.scad"
REFERENCE_MASTER = REPO / "cad" / "visualization-reference-parts.scad"
CORE_PARTS = (
    "front-core", "rear-core", "board-spine-front", "board-spine-rear",
    "front-panel", "front-button-mount", "front-usb-cassette",
    "ssd-cassette", "rear-blank-board", "rear-blank-psu",
    "rear-cover-horizontal", "rear-cover-vertical",
)
REFERENCE_PARTS = ("button-plate", "button-light-pipe", "usb-cover")
MATERIAL_PARTS = ("button-cap-black", "button-logo-white")
MATERIAL_MASTER = REPO / "cad" / "visualization-nexgen-button-material.scad"
DIRECT_PARTS = (
    ("front-cover-overlay", REPO / "cad" / "visualization-front-cover.scad"),
    ("button-decorative-bezel", REPO / "cad" / "visualization-decorative-button.scad"),
)
VIEWER_FILES = tuple(REPO / "visualization" / name for name in ("index.html", "styles.css", "viewer.js"))

state_lock = threading.Lock()
state = {"version": 1, "building": False, "error": None}


def find_openscad() -> str | None:
    executable = shutil.which("openscad")
    if executable:
        return executable
    candidates = (
        Path("/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"),
        Path(os.environ.get("ProgramFiles", "C:/Program Files")) / "OpenSCAD" / "openscad.exe",
    )
    return next((str(path) for path in candidates if path.exists()), None)


def export_parts(openscad: str) -> None:
    ASSETS.mkdir(parents=True, exist_ok=True)
    subprocess.run(
        [sys.executable, str(REPO / "tools" / "extract_nexgen_button_materials.py"),
         str(REPO / "references" / "printables-1793043-nexgen-pro-v2" / "Power Button" / "pro-v2-steam-logo.3mf"),
         str(REPO / "cad" / "vendor" / "nexgen")],
        cwd=REPO,
        check=True,
    )
    jobs = [(part, MASTER) for part in CORE_PARTS]
    jobs += [(part, REFERENCE_MASTER) for part in REFERENCE_PARTS]
    jobs += [(part, MATERIAL_MASTER) for part in MATERIAL_PARTS]
    jobs += list(DIRECT_PARTS)
    for index, (part, source) in enumerate(jobs, 1):
        print(f"[{index:02}/{len(jobs)}] Exporting {part}", flush=True)
        define_part = {"button-cap-black": "black", "button-logo-white": "white"}.get(part, part)
        define_args = [] if (part, source) in DIRECT_PARTS else ["-D", f'part="{define_part}"']
        subprocess.run(
            [openscad, "-o", str(ASSETS / f"{part}.stl"), *define_args, str(source)],
            cwd=REPO,
            check=True,
        )


def signature(paths: list[Path] | tuple[Path, ...]) -> tuple[tuple[str, int], ...]:
    return tuple(sorted((str(path), path.stat().st_mtime_ns) for path in paths if path.is_file()))


def cad_files() -> list[Path]:
    return list((REPO / "cad").rglob("*.scad"))


def watch(openscad: str) -> None:
    cad_state = signature(cad_files())
    viewer_state = signature(VIEWER_FILES)
    while True:
        time.sleep(0.75)
        next_cad_state = signature(cad_files())
        next_viewer_state = signature(VIEWER_FILES)
        if next_cad_state != cad_state:
            cad_state = next_cad_state
            with state_lock:
                state["building"] = True
                state["error"] = None
            try:
                export_parts(openscad)
            except subprocess.CalledProcessError as exc:
                with state_lock:
                    state["error"] = f"OpenSCAD exited with code {exc.returncode}"
                print(f"Build failed: {state['error']}", flush=True)
            else:
                with state_lock:
                    state["version"] += 1
                print("CAD updated; browser reload requested.", flush=True)
            finally:
                with state_lock:
                    state["building"] = False
        elif next_viewer_state != viewer_state:
            viewer_state = next_viewer_state
            with state_lock:
                state["version"] += 1
            print("Viewer updated; browser reload requested.", flush=True)


class Handler(SimpleHTTPRequestHandler):
    def do_GET(self) -> None:
        if self.path.split("?", 1)[0] == "/__viewer_status":
            with state_lock:
                payload = json.dumps(state).encode()
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.send_header("Cache-Control", "no-store")
            self.send_header("Content-Length", str(len(payload)))
            self.end_headers()
            self.wfile.write(payload)
            return
        super().do_GET()

    def end_headers(self) -> None:
        self.send_header("Cache-Control", "no-cache")
        super().end_headers()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--port", type=int, default=8000)
    parser.add_argument("--rebuild", action="store_true", help="Rebuild every STL before serving")
    args = parser.parse_args()

    openscad = find_openscad()
    if not openscad:
        raise SystemExit("OpenSCAD CLI was not found. See visualization/SETUP.md.")
    if args.rebuild or not (ASSETS / "front-core.stl").exists():
        export_parts(openscad)

    board_model = REPO / "references" / "hafriedlander-bc250-case" / "_extern" / "bc250_alt.stl"
    if not board_model.exists():
        print("WARNING: local BC-250 model is missing; see visualization/SETUP.md", flush=True)

    threading.Thread(target=watch, args=(openscad,), daemon=True).start()
    os.chdir(REPO)
    server = ThreadingHTTPServer(("127.0.0.1", args.port), Handler)
    print(f"BC-250 viewer: http://localhost:{args.port}/visualization/", flush=True)
    print("Watching CAD and viewer files. Press Ctrl+C to stop.", flush=True)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nStopped.")
    finally:
        server.server_close()


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""Zero-dependency development server and live-reload watcher for the 3D viewer."""

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

from up_model import update_assets

REPO = Path(__file__).resolve().parent.parent
ASSETS = REPO / "visualization" / "assets"
MASTER = REPO / "cad" / "core-assembly-v0.1.scad"
REFERENCE_MASTER = REPO / "cad-visualization" / "visualization-reference-parts.scad"
CORE_PARTS = (
    "front-core", "rear-core", "board-spine-front", "board-spine-rear",
    "front-panel", "front-button-mount", "front-usb-cassette",
    "ssd-cassette", "esp32-cassette", "esp32-cover",
    "rear-cover-horizontal", "rear-cover-vertical",
)
INTAKE_MASTER = REPO / "cad" / "intake-panel-snap-v0.1.scad"
INTAKE_PARTS = (("intake-cover-left", "left"), ("intake-cover-right", "right"))
REFERENCE_PARTS = ("button-plate", "button-light-pipe", "usb-cover")
MATERIAL_PARTS = ("button-cap-black", "button-logo-white")
MATERIAL_MASTER = REPO / "cad-visualization" / "visualization-nexgen-button-material.scad"
DIRECT_PARTS = (
    ("button-decorative-bezel", REPO / "cad-visualization" / "visualization-decorative-button.scad"),
)
VIEWER_FILES = tuple(REPO / "visualization" / name for name in ("index.html", "styles.css", "legend.css", "viewer.js"))

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
    result = update_assets()
    if result:
        raise subprocess.CalledProcessError(result, [sys.executable, "tools/up_model.py"])


def signature(paths: list[Path] | tuple[Path, ...]) -> tuple[tuple[str, int], ...]:
    return tuple(sorted((str(path), path.stat().st_mtime_ns) for path in paths if path.is_file()))


def watched_files() -> list[Path]:
    return list(VIEWER_FILES) + list(ASSETS.glob("*.stl"))


def watch() -> None:
    viewer_state = signature(watched_files())
    while True:
        time.sleep(0.75)
        next_viewer_state = signature(watched_files())
        if next_viewer_state != viewer_state:
            viewer_state = next_viewer_state
            with state_lock:
                state["version"] += 1
            print("Viewer or STL asset updated; browser reload requested.", flush=True)


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

    if args.rebuild or not (ASSETS / "front-core.stl").exists():
        openscad = find_openscad()
        if not openscad:
            raise SystemExit("OpenSCAD CLI was not found. See visualization/SETUP.md.")
        export_parts(openscad)

    board_model = REPO / "references" / "hafriedlander-bc250-case" / "_extern" / "bc250_alt.stl"
    if not board_model.exists():
        print("WARNING: local BC-250 model is missing; see visualization/SETUP.md", flush=True)

    threading.Thread(target=watch, daemon=True).start()
    os.chdir(REPO)
    server = ThreadingHTTPServer(("127.0.0.1", args.port), Handler)
    print(f"BC-250 viewer: http://localhost:{args.port}/visualization/", flush=True)
    print("Watching viewer and derived STL files. Press Ctrl+C to stop.", flush=True)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nStopped.")
    finally:
        server.server_close()


if __name__ == "__main__":
    main()

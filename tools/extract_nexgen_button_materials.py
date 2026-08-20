#!/usr/bin/env python3
"""Split the supplied multi-material NexGen button cap into printable 3MFs."""

import copy
import sys
import xml.etree.ElementTree as ET
import zipfile
from pathlib import Path


def write_subset(source: Path, destination: Path, wanted_names: set[str]) -> None:
    with zipfile.ZipFile(source) as archive:
        model_name = next(name for name in archive.namelist() if name.endswith(".model"))
        root = ET.fromstring(archive.read(model_name))
        resources = root.find("{*}resources")
        build = root.find("{*}build")
        assert resources is not None and build is not None

        kept_ids = set()
        for obj in list(resources.findall("{*}object")):
            if obj.attrib.get("name") in wanted_names:
                kept_ids.add(obj.attrib["id"])
            else:
                resources.remove(obj)
        for item in list(build.findall("{*}item")):
            if item.attrib.get("objectid") not in kept_ids:
                build.remove(item)

        model = ET.tostring(root, encoding="utf-8", xml_declaration=True)
        with zipfile.ZipFile(destination, "w", zipfile.ZIP_DEFLATED) as output:
            for entry in archive.infolist():
                output.writestr(copy.copy(entry), model if entry.filename == model_name else archive.read(entry.filename))


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit(f"usage: {sys.argv[0]} SOURCE.3mf OUTPUT_DIR")
    source, output_dir = Path(sys.argv[1]), Path(sys.argv[2])
    output_dir.mkdir(parents=True, exist_ok=True)
    write_subset(source, output_dir / "button-cap-black.3mf", {"Black"})
    write_subset(source, output_dir / "button-logo-white.3mf", {"White-1", "White-2"})


if __name__ == "__main__":
    main()

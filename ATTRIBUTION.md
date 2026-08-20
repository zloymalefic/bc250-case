# Credits, inspiration, and attribution

This project is not designed in isolation. It is based on, adapted from, and inspired by the BC-250 community projects listed below. Their authors established much of the visual language, service architecture, mounting strategy, and source geometry used during development.

## Primary exterior reference

### nyacom - AMD BC-250 Industrial Style Case for FlexATX

- Source: https://www.printables.com/model/1737913-nyacoms-amd-bc-250-industrial-style-case-for-flexa
- License: CC BY-NC-SA 4.0, as identified in the supplied Printables package.
- Used for: industrial exterior language, long octagonal tunnel, contrasting end rings, recessed end panels, removable broad-side cover, sliding storage-mount principle, and general compact proportions.
- Project-specific adaptation: enlarged and restructured around the JIUSHARK JF13K, split for smaller print beds, and combined with NexGen-derived service mechanisms.

## Primary mechanical reference

### NexGen-3D-Printing - DIY Steam Machine REDUX Edition (later revision cross-check)

- Source: https://www.printables.com/model/1649679-nexgen3d-diy-steam-machine-redux-edition
- License: CC BY-NC 4.0, as identified in the supplied package.
- Used to compare later revisions of mechanisms already adopted from PRO V2. Additional useful files are the editable blank button, improved snap tabs, split-cover joiners, and storage caddy.
- Adaptation notes: `cad/REDUX-ADAPTATION.md`.
- No Redux mesh is currently included in a release part.

### NexGen-3D-Printing - DIY Steam Machine PRO V2

- Printables files: https://www.printables.com/model/1793043-nexgen3d-diy-steam-machine-pro-v2-liquid-cooled-bc/files
- GitHub: https://github.com/NexGen-3D-Printing/SteamMachine
- License: CC BY-NC 4.0, as identified in the supplied Printables package.
- Used for: replaceable PSU mounts, internal multipurpose bay, access-panel strategy, snap/slot panel servicing, vertical and horizontal support concepts, and the three-part backlit power button.
- Directly reused asset: `Power Button/pro-v2-steam-logo.3mf`, retained in the local reference package and imported by `cad/power-button-nexgen-v0.1.scad`.
- Project-specific adaptation: the common PSU chassis is fully internal; no PSU carrier is allowed to protrude through the Nyacom-style rear ring.

## Additional geometry and engineering references

### hafriedlander - bc250-case

- Source: https://github.com/hafriedlander/bc250-case
- Used for: BC-250 proxy geometry, OpenSCAD construction study, and preliminary envelope validation.
- No standalone license was found in the pinned local revision; its geometry is therefore treated as an engineering reference and is not presented as original project geometry.

### onemorecap - bc-250-shell-case

- Source: https://github.com/onemorecap/bc-250-shell-case
- Used for: editable chassis, mounting, and print-splitting study.
- No standalone license was found in the pinned local revision; its geometry is treated as reference-only.

### DeepCool AN600 adapter for AMD BC-250

- Source: https://www.printables.com/model/1707972-deepcool-an600-adapter-for-amd-bc-250
- License: Public Domain, as identified in the supplied Printables package.
- Used for: the initial LGA1700-style cooler-interface study and JF13K fit-check planning.

### Sean - BC-250 Heat Sink Mount (MK7)

- Source: https://www.printables.com/model/1217021-bc-250-heat-sink-mount
- License: Public Domain, as identified in the supplied Printables PDF.
- Used for: independent BC-250 heatsink-footprint comparison and M4 fastening
  study. It is not treated as a JF13K-compatible production adapter.

### BC-250 Quiet Case Tower Cooler

- Source: https://www.printables.com/model/1652979
- License: CC BY-NC 4.0, as identified in the supplied Printables package.
- Used for: front USB routing, large-air-cooler packaging, and auxiliary-storage study.

### zloymalefic - BC-250 PC Remote Control

- Source: https://github.com/zloymalefic/BC-250-PC-Remote-Control
- Used for: ESP32 relay-controller integration, remote power control, and front-button electrical planning.

## Project status and licensing note

The current repository contains engineering studies, recreated interfaces, derivative visual design, and third-party reference packages. It is not an official product of nyacom, NexGen-3D-Printing, Valve, AMD, ASRock, Cisco, or JIUSHARK.

Any distribution or remix of derivative case geometry must preserve the attribution, non-commercial, and share-alike obligations applicable to the Nyacom-derived portions. Direct NexGen assets, including the Steam-logo button component, retain their original attribution and license requirements. Review each source package before redistributing individual third-party files.

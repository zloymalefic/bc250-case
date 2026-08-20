# BC-250 + JF13K compact case

Engineering project for a compact, quiet, 3D-printable Steam Machine-style enclosure built around:

`AMD BC-250 + mounting adapter + JIUSHARK JF13K + modular PSU`

The design is in a controlled recovery and geometry-validation phase. There is currently no printable enclosure release. Previous prototype exports were withdrawn because their mating interfaces did not form a buildable assembly; see [cad/ASSEMBLY-AUDIT.md](cad/ASSEMBLY-AUDIT.md).

## Based on and inspired by

This enclosure is explicitly based on and inspired by two primary community projects:

- [nyacom's AMD BC-250 Industrial Style Case for FlexATX](https://www.printables.com/model/1737913-nyacoms-amd-bc-250-industrial-style-case-for-flexa) - primary exterior design, proportions, end-ring language, and removable-cover concept;
- [NexGen3D DIY Steam Machine PRO V2](https://www.printables.com/model/1793043-nexgen3d-diy-steam-machine-pro-v2-liquid-cooled-bc/files) - power-button assembly, serviceable snap/slot panels, universal PSU mounting strategy, and modular internal architecture.

Additional source projects, direct links, adopted features, pinned revisions, and licensing notes are documented in [ATTRIBUTION.md](ATTRIBUTION.md) and [SOURCES.md](SOURCES.md). This is an independent community derivative and is not an official product of the referenced creators or hardware vendors.

## Current direction

- Common chassis for the BC-250 and JF13K assembly.
- Replaceable horizontal and vertical support/base modules.
- Independent replaceable PSU carriers, initially for Cisco UCSC-PSU-650W V02 and later FlexATX.
- Controlled top-down intake through the two JF13K fans.
- Serviceable front USB hub, 2.5-inch drive mount, and ESP32 relay-controller tray.

![Nyacom-inspired exterior adaptation v0.2](cad/previews/exterior-nyacom-v0.2.svg)

## Project files

- `BC-250-JF13K-agent-context.md` - original project context and priorities.
- `DESIGN-BRIEF.md` - evolving engineering requirements and decisions.
- `BOM.md` - provisional fastener, consumable, filament, electronics, and procurement list with project article numbers and quantities.
- `SOURCES.md` - reference registry, pinned revisions, formats, licenses, and preliminary measurements.
- `ATTRIBUTION.md` - complete credits, direct links, adopted features, and derivative-license notices.
- `docs/FINAL-VISUALIZATION.md` - final Blender/GLB rendering, viewing, and exploded-view delivery plan.
- `TECHNICAL-REPORT-01.md` - layout comparison and the selected two-level architecture.
- `cad/layout-a-envelope.scad` - parameterized collision/envelope model for layout A.
- `cad/exterior-nyacom-v0.2.scad` - replacement exterior direction closely based on the Nyacom industrial case language.
- `cad/NYACOM-ADAPTATION.md` - retained design features, necessary JF13K changes, and derivative-license note.
- `cad/power-button-nexgen-v0.1.scad` - recreated three-part, backlit, rotatable NexGen-style button module.
- `cad/psu-universal-internal-v0.1.scad` - common internal rail with separate Cisco and FlexATX adapters.
- `cad/NEXGEN-MECHANISMS.md` - exact NexGen mechanisms selected for reuse and their project-specific constraints.
- `cad/PSU-INTERFACE.md` - fully internal PSU interface and flush-rear requirement.
- `cad/chassis-split-v0.1.scad` - front/rear printable structural sections with an internal alignment collar.
- `cad/CHASSIS-SPLIT.md` - split location, print envelopes, clearance, and retention details.
- `cad/chassis-joint-coupon-v0.1.scad` - reduced-cost three-clearance test of the real chamfered chassis joint.
- `cad/intake-panel-snap-v0.1.scad` - two independently replaceable JF13K intake halves with hidden hooks.
- `cad/fit-calibration-coupon-v0.1.scad` - combined M3/M4 insert, screw-hole, and snap-clearance pre-production test.
- `cad/front-service-module-v0.1.scad` - snap-fit Nyacom front insert with independent button and USB cassette modules.
- `cad/board-tray-v0.1.scad` - split open-centre BC-250 tray with adjustable slots and JF13K load-path anchors.
- `cad/peripheral-bay-v0.1.scad` - removable 7 mm SSD and ESP32 relay-board cassettes.
- `cad/rear-service-system-v0.1.scad` - flush rear panel with replaceable I/O and PSU inserts.
- `cad/ASSEMBLY-AUDIT.md` - authoritative compatibility audit and recovery order.
- `cad/core-assembly-v0.1.scad` - active single-source rebuild of the two-part structural core and accessible seam retention.
- `cad/CORE-ASSEMBLY.md` - core assembly sequence, closed interfaces, and remaining work.
- `cad/exports/README.md` - authoritative list of STL files currently approved for slicing.
- `cad/support-horizontal.scad` and `cad/support-vertical.scad` - interchangeable support prototypes using a common M4 interface.
- `cad/SUPPORT-INTERFACE.md` - dimensions, fasteners, and unresolved validation points for both orientations.
- `cad/previews/layout-a-top.svg` - reproducible top-view projection for quick browser inspection.
- `references/printables-*` - downloaded reference models retained with their source PDFs and license information.
- `tools/inspect_3mf.py` - small utility for reporting raw 3MF vertex bounds.

## Important

The repository contains third-party reference files under different licenses. Review `SOURCES.md` and the source PDF in each reference directory before reusing or redistributing a model. Reference geometry is not automatically part of the final case design.

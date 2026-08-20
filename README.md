# BC-250 + JF13K compact case

Engineering project for a compact, quiet, 3D-printable Steam Machine-style enclosure built around:

`AMD BC-250 + mounting adapter + JIUSHARK JF13K + modular PSU`

The design is still in the research and geometry-validation phase. Dimensions and compatibility are not treated as final until they are confirmed by source CAD or physical measurement.

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
- `SOURCES.md` - reference registry, pinned revisions, formats, licenses, and preliminary measurements.
- `TECHNICAL-REPORT-01.md` - layout comparison and the selected two-level architecture.
- `cad/layout-a-envelope.scad` - parameterized collision/envelope model for layout A.
- `cad/exterior-nyacom-v0.2.scad` - replacement exterior direction closely based on the Nyacom industrial case language.
- `cad/NYACOM-ADAPTATION.md` - retained design features, necessary JF13K changes, and derivative-license note.
- `cad/exports/exterior-nyacom-*-v0.2.3mf` - compiled horizontal and vertical Nyacom-style concept assemblies.
- `cad/power-button-nexgen-v0.1.scad` - recreated three-part, backlit, rotatable NexGen-style button module.
- `cad/psu-universal-internal-v0.1.scad` - common internal rail with separate Cisco and FlexATX adapters.
- `cad/NEXGEN-MECHANISMS.md` - exact NexGen mechanisms selected for reuse and their project-specific constraints.
- `cad/PSU-INTERFACE.md` - fully internal PSU interface and flush-rear requirement.
- `cad/chassis-split-v0.1.scad` - front/rear printable structural sections with an internal alignment collar.
- `cad/CHASSIS-SPLIT.md` - split location, print envelopes, clearance, and retention details.
- `cad/exports/layout-a-envelope.stl` - compiled validation export; not a printable final case.
- `cad/support-horizontal.scad` and `cad/support-vertical.scad` - interchangeable support prototypes using a common M4 interface.
- `cad/SUPPORT-INTERFACE.md` - dimensions, fasteners, and unresolved validation points for both orientations.
- `cad/previews/layout-a-top.svg` - reproducible top-view projection for quick browser inspection.
- `references/printables-*` - downloaded reference models retained with their source PDFs and license information.
- `tools/inspect_3mf.py` - small utility for reporting raw 3MF vertex bounds.

## Important

The repository contains third-party reference files under different licenses. Review `SOURCES.md` and the source PDF in each reference directory before reusing or redistributing a model. Reference geometry is not automatically part of the final case design.

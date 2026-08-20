# CAD workspace

Current status: **design recovery; no printable enclosure release**.

Read `ASSEMBLY-AUDIT.md` before using any model. It records why the previous collection could not be assembled and defines the recovery order.

## Safe outputs

Only the small test pieces in `exports/` are currently approved for slicing. See `exports/README.md`.

```sh
openscad -o exports/fit-calibration-coupon-v0.1.stl fit-calibration-coupon-v0.1.scad
openscad -D 'clearances=[0.25]' -o exports/chassis-joint-coupon-0.25mm-v0.1.stl chassis-joint-coupon-v0.1.scad
openscad -D 'clearances=[0.35]' -o exports/chassis-joint-coupon-0.35mm-v0.1.stl chassis-joint-coupon-v0.1.scad
openscad -D 'clearances=[0.45]' -o exports/chassis-joint-coupon-0.45mm-v0.1.stl chassis-joint-coupon-v0.1.scad
```

## Retained studies

Other `.scad` files are non-release studies. They preserve useful dimensions and geometry for rebuilding the master assembly, but their interfaces are incomplete. Successful OpenSCAD compilation does not make a study printable or compatible with another study.

The exterior direction is documented by
`previews/exterior-orthographic-v0.3.svg`: four separate orthographic views at a
common 2 px/mm scale and a tower schematic obtained by rotating the left-side
projection. It is a dimensional architecture preview, not a manufacturing
drawing.

## Active rebuild

`core-assembly-v0.1.scad` is the active master for the two structural halves. It replaces the inaccessible axial joint with two bottom-access M3 fasteners. See `CORE-ASSEMBLY.md`. It remains validation-only until end panels and internal mounting interfaces are integrated.

The same master now includes two interchangeable rear-cover structures:
`rear-cover-horizontal` and `rear-cover-vertical`. The latter becomes a 44 mm
open cable-management base when the complete enclosure is stood on its rear
face. See `REAR-COVER-VARIANTS.md`.

`HEATSINK-MOUNT-COMPARISON.md` compares the supplied Sean MK7/RZ620 mount with
the previously supplied AN600 adapter and records why neither may yet be treated
as a verified JF13K production mount.

`board-spine-v0.1.scad` is the first dimensional vertical carrier based on the
308.0 × 144.3 × 1.6 mm bare-PCB envelope. `BC250-DATUM.md` records the source,
license boundary, open-reference cross-check, and remaining retention risk.

`psu-universal-internal-v0.2.scad` replaces the provisional long rail with a
fully internal receiver for the NexGen 110 × 46.34 mm interchangeable PSU mount
family. It accepts server, FlexATX, and Mean Well plate depths without requiring
the Cisco PSU body to be measured.

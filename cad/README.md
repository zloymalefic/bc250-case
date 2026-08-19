# CAD workspace

`layout-a-envelope.scad` is the first parameterized packaging model for the recommended longitudinal two-level architecture.

`support-horizontal.scad` and `support-vertical.scad` are the first printable support prototypes. Both use the common parameters in `lib/common.scad`; see `SUPPORT-INTERFACE.md` for the mechanical contract and unresolved details.

It is intentionally not a printable enclosure. The model is used to:

- expose dimensional assumptions;
- test component placement and service zones;
- compare horizontal and vertical supports;
- detect obvious collisions before detailed CAD;
- update uncertain dimensions without rebuilding the model.

Key provisional inputs are grouped at the top of the file. In particular, confirm the Cisco PSU envelope and the installed JF13K Z stack before deriving printable parts.

Expected console values with the current assumptions:

- chassis: 330 × 170 × 170 mm;
- bounding volume: 9.537 litres;
- nominal PSU-to-PCB backplate channel: 12 mm;
- conservative JF13K top Z: 156.6 mm.

The first 160 mm-high study left only an 8 mm backplate channel and insufficient clearance above the JF13K. The corrected 170 mm envelope lowers the PSU to the 3 mm floor datum, provides the minimum 12 mm cable channel, and leaves 13.4 mm above the conservative cooler envelope.

Open `layout-a-envelope.scad` in OpenSCAD and use Preview (`F5`). Display toggles at the top isolate the shell, component envelopes, supports, and airflow guides.

Reproducible exports:

```sh
openscad -o exports/layout-a-envelope.stl layout-a-envelope.scad
openscad -D 'show_chassis=false' -D 'export_projection=true' \
  -o previews/layout-a-top.svg layout-a-envelope.scad
openscad -o exports/support-horizontal-v0.1.stl support-horizontal.scad
openscad -o exports/support-vertical-v0.1.stl support-vertical.scad
```

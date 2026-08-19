# CAD workspace

`layout-a-envelope.scad` is the first parameterized packaging model for the recommended longitudinal two-level architecture.

`support-horizontal.scad` and `support-vertical.scad` are the first printable support prototypes. Both use the common parameters in `lib/common.scad`; see `SUPPORT-INTERFACE.md` for the mechanical contract and unresolved details.

`exterior-nyacom-v0.2.scad` is the active exterior direction. It follows the supplied Nyacom reference closely while replacing its stock-cooler airflow with a two-field JF13K intake. See `NYACOM-ADAPTATION.md`.

`psu-universal-internal-v0.1.scad` defines a fully internal common PSU rail with separate Cisco and FlexATX adapters. Nothing in this interface may protrude through the Nyacom-style rear ring; see `PSU-INTERFACE.md`.

`power-button-nexgen-v0.1.scad` recreates the NexGen three-part button architecture as a removable mounting plate, translucent light pipe, and replaceable cap. See `NEXGEN-MECHANISMS.md` for measured reference envelopes and adopted constraints.

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
openscad -o exports/exterior-nyacom-horizontal-v0.2.3mf exterior-nyacom-v0.2.scad
openscad -D 'orientation="vertical"' \
  -o exports/exterior-nyacom-vertical-v0.2.3mf exterior-nyacom-v0.2.scad
openscad -o exports/power-button-nexgen-v0.1.3mf power-button-nexgen-v0.1.scad
openscad -o exports/psu-internal-cisco-v0.1.stl psu-universal-internal-v0.1.scad
openscad -D 'variant="flexatx"' \
  -o exports/psu-internal-flexatx-v0.1.stl psu-universal-internal-v0.1.scad
```

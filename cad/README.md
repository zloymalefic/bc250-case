# CAD workspace

`layout-a-envelope.scad` is the first parameterized packaging model for the recommended longitudinal two-level architecture.

`support-horizontal.scad` and `support-vertical.scad` are the first printable support prototypes. Both use the common parameters in `lib/common.scad`; see `SUPPORT-INTERFACE.md` for the mechanical contract and unresolved details.

`exterior-nyacom-v0.2.scad` is the active exterior direction. It follows the supplied Nyacom reference closely while replacing its stock-cooler airflow with a two-field JF13K intake. See `NYACOM-ADAPTATION.md`.

`psu-universal-internal-v0.1.scad` defines a fully internal common PSU rail with separate Cisco and FlexATX adapters. Nothing in this interface may protrude through the Nyacom-style rear ring; see `PSU-INTERFACE.md`.

`power-button-nexgen-v0.1.scad` recreates the NexGen three-part button architecture as a removable mounting plate, translucent light pipe, and replaceable cap. See `NEXGEN-MECHANISMS.md` for measured reference envelopes and adopted constraints.

`chassis-split-v0.1.scad` divides the 330 mm structural tunnel into two sub-250 mm print sections with an internal octagonal alignment collar and hidden M3 retention. See `CHASSIS-SPLIT.md`.

`intake-panel-snap-v0.1.scad` divides the JF13K intake into two sub-250 mm snap-fit panels. `snap-fit-coupon-v0.1.scad` is the required material/printer calibration object; see `SNAP-PANELS.md`.

`front-service-module-v0.1.scad` combines a Nyacom-style snap-fit front panel with independent openings for the NexGen-derived button and a replaceable USB-A/USB-C cassette. See `FRONT-SERVICE-MODULE.md`.

It is intentionally not a printable enclosure. The model is used to:

- expose dimensional assumptions;
- test component placement and service zones;
- compare horizontal and vertical supports;
- detect obvious collisions before detailed CAD;
- update uncertain dimensions without rebuilding the model.

Key provisional inputs are grouped at the top of the file. In particular, confirm the Cisco PSU envelope and the installed JF13K Z stack before deriving printable parts.

Expected console values with the current assumptions:

- chassis: 330 × 155 × 195 mm;
- bounding volume: 9.974 litres;
- nominal PSU-to-PCB backplate channel: 12 mm;
- conservative JF13K top Z: 156.6 mm.

The first square-section study looked and behaved unlike the Nyacom reference. The corrected 155 × 195 mm cross-section is narrower and taller, retains the minimum 12 mm cable channel, and leaves 38.4 mm above the conservative JF13K envelope for the intake panel and structural support.

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
openscad -o exports/power-button-nexgen-v0.2.3mf power-button-nexgen-v0.1.scad
python3 ../tools/prepare_nexgen_button_logo.py \
  '../references/printables-1793043-nexgen-pro-v2/Power Button/pro-v2-steam-logo.3mf' \
  exports/power-button-steam-logo-nexgen-v0.2.3mf
openscad -o exports/psu-internal-cisco-v0.1.stl psu-universal-internal-v0.1.scad
openscad -D 'variant="flexatx"' \
  -o exports/psu-internal-flexatx-v0.1.stl psu-universal-internal-v0.1.scad
openscad -D 'part="front"' -o exports/chassis-front-v0.1.stl chassis-split-v0.1.scad
openscad -D 'part="rear"' -o exports/chassis-rear-v0.1.stl chassis-split-v0.1.scad
openscad -o exports/snap-fit-coupon-v0.1.stl snap-fit-coupon-v0.1.scad
openscad -D 'part="left"' -o exports/intake-panel-left-v0.1.stl intake-panel-snap-v0.1.scad
openscad -D 'part="right"' -o exports/intake-panel-right-v0.1.stl intake-panel-snap-v0.1.scad
openscad -D 'part="panel"' -o exports/front-panel-nyacom-v0.1.stl front-service-module-v0.1.scad
openscad -D 'part="usb-cassette"' -o exports/usb-hub-cassette-v0.1.stl front-service-module-v0.1.scad
```

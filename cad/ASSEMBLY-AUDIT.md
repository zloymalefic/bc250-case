# Assembly audit 2026-08-20

## Verdict

The project does **not** currently contain a complete buildable enclosure. Earlier exports mixed visual studies, equipment envelopes, calibration parts, and disconnected mechanical prototypes in one directory. They could not be assembled into one case without drilling, glue, or redesign.

All production-looking exports have therefore been withdrawn. `cad/exports/` now contains calibration coupons only.

## Interface audit

| Interface | Result | Evidence / required correction |
|---|---|---|
| Chassis front ↔ chassis rear | incomplete | The collar aligns the sections, but axial M3 retention is inaccessible in the full case. Use bottom-access retention near the seam. |
| Intake halves ↔ chassis | aligned, unvalidated | Eight hook coordinates match eight receiver coordinates. Clearance and release access still require coupon results. |
| Front panel ↔ chassis | impossible | Panel has four hooks; chassis has no front receiver pockets or end-frame seat. |
| Rear panel ↔ chassis | impossible | Panel has four hooks; chassis has no rear receiver pockets or end-frame seat. |
| Button ↔ front panel | impossible | Button plate has two M3 holes; front panel provides no bosses or inserts. |
| USB cassette ↔ front panel | unvalidated | Nominal face clearance exists, but hook receivers and actual hub envelope are not confirmed. |
| Board tray ↔ chassis | incomplete | Tray rests on ledges, but no shared fastener pattern or captive retention exists. |
| BC-250 ↔ board tray | unknown | Board outline and mounting-hole coordinates remain provisional. |
| JF13K ↔ tray/chassis | unknown | Only envelope and generic load-path anchors exist. |
| PSU carrier ↔ chassis | impossible | Rail has slots but chassis has no matching points. Its withdrawn STL also contained the solid PSU envelope. |
| Cisco PSU ↔ carrier | unknown | Envelope, latch, connector, and airflow are provisional. |
| SSD cassette ↔ chassis | impossible | No mating bay, rails, or latch exists. |
| ESP32 cassette ↔ chassis | impossible | No mating bay exists; board hole pattern is unmeasured. |
| Horizontal supports ↔ chassis | partially defined | Four bosses exist, but inserts and assembled fit are unvalidated. |
| Vertical supports ↔ chassis | impossible | Chassis has no matching end-face attachment pattern. |

## Status of source models

The remaining `.scad` files are retained as design studies and reusable geometry only. They are **not release parts** and must not be sent to a print service. A source becomes releasable only after it is included in the master assembly, has a defined mating interface, passes collision checks, and receives a fresh export.

## Controlled recovery order

1. Establish one master coordinate system and one assembly source.
2. Complete chassis retention and both end-panel seats.
3. Add the board-tray attachment pattern and measured BC-250/JF13K proxies.
4. Add the internal common PSU interface without equipment envelopes in printable output.
5. Add horizontal and vertical supports against explicit chassis interfaces.
6. Add button, USB, SSD, and ESP32 modules only after their receivers exist.
7. Run collision and manifold checks, then populate `cad/exports/release/<version>/` as one versioned set.


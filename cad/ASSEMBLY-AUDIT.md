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
| Board spine ↔ chassis | incomplete | The new vertical spine defines eight transverse M4 axes, but matching core bosses are the next integration step. |
| BC-250 ↔ board spine | partially defined | Bare PCB envelope is now 308.0 × 144.3 × 1.6 mm and the split pocket is modeled; final edge clamps still require a real-board keepout check. |
| JF13K ↔ tray/chassis | unknown | Only envelope and generic load-path anchors exist. |
| Universal PSU receiver ↔ chassis | partially defined | The internal 110 × 46.34 mm receiver is printable and stays behind X=318; matching core bosses are the next integration step. |
| NexGen PSU adapter ↔ receiver | defined, unvalidated | Server/FlexATX/LOP plate depths fit the common guides and interior clamps; print clearance remains untested. |
| Cisco PSU ↔ server adapter | reference-derived | Use the supplied NexGen universal server-PSU mount with an inward offset; no separate Cisco body measurement is required. |
| SSD cassette ↔ chassis | impossible | No mating bay, rails, or latch exists. |
| ESP32 cassette ↔ chassis | impossible | No mating bay exists; board hole pattern is unmeasured. |
| Horizontal supports ↔ chassis | partially defined | Four bosses exist, but inserts and assembled fit are unvalidated. |
| Vertical rear/base cover ↔ chassis | integrated, unvalidated | The tapered cover and rear core share four M3 axes; insert fit, connector bend radius, and load test remain open. |

## Status of source models

The remaining `.scad` files are retained as design studies and reusable geometry only. They are **not release parts** and must not be sent to a print service. A source becomes releasable only after it is included in the master assembly, has a defined mating interface, passes collision checks, and receives a fresh export.

## Controlled recovery order

Confirmed architecture: BC-250 and the major internal components are vertical along the long axis, matching the Nyacom reference assembly. The earlier horizontal two-level layout is superseded.

1. Establish one master coordinate system and one assembly source.
2. Complete chassis retention and both end-panel seats.
3. Add the vertical board-spine attachment pattern and measured BC-250/JF13K proxies.
4. Add the internal common PSU interface without equipment envelopes in printable output.
5. Add horizontal and vertical supports against explicit chassis interfaces.
6. Add button, USB, SSD, and ESP32 modules only after their receivers exist.
7. Run collision and manifold checks, then populate `cad/exports/release/<version>/` as one versioned set.

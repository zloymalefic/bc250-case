# Assembly audit 2026-08-20

## Verdict

The project does **not** currently contain a complete buildable enclosure. Earlier exports mixed visual studies, equipment envelopes, calibration parts, and disconnected mechanical prototypes in one directory. They could not be assembled into one case without drilling, glue, or redesign.

All production-looking exports have therefore been withdrawn. `cad/exports/` now contains calibration coupons only.

## Interface audit

| Interface | Result | Evidence / required correction |
|---|---|---|
| Chassis front ↔ chassis rear | integrated, unvalidated | The collar aligns the sections and two bottom-access M3 screws retain them. Insert/collar coupon results remain open. |
| Intake halves ↔ chassis | blocked | Covers are raised to Z=32, their grille fields remain on the JF13K fan axes, and the ESP32 cover no longer overlaps them. STL topology still reports the two upper magnet bosses in each split core as detached islands; these bosses must be redesigned or replaced before release. Pocket fit and the perimeter seat/fascia still require a coupon. |
| Front panel ↔ chassis | integrated, unvalidated | Full 155 × 195 × 12 mm sculpted Nyacom-derived end cap matches the case section and has four front-access M3 insert bosses. Screw length and insert fit remain open. |
| Monolithic rear covers ↔ chassis | integrated, unvalidated | Both rear variants are single structural bodies on the common four-point M3 interface. Final PSU/I/O apertures remain open. |
| Button ↔ front panel | integrated, unvalidated | NexGen plate mounts entirely against the inside face; two blind M3 insert axes, central passage and a thickness extension align the external cap. Insert fit and switch travel remain open. |
| Anker A7516 cassette ↔ front panel | integrated, unvalidated | Vertical 28.6 × 71.0 mm opening, two hidden receivers, four USB-A cuts, and a 103 × 30 × 10 mm cradle are modeled. Physical fit remains open. |
| ESP32 service cover ↔ chassis | integrated, unvalidated | The solid 98 × 32 mm cover replaces a matching 3 mm shell seat and ends at the lower edge of the intake cover without overlap. Four side hooks engage explicit stepped pockets; the lower pair and pockets follow the 45° shell chamfer. Physical snap fit remains open. |
| Board spine ↔ chassis | integrated, unvalidated | Eight transverse M4 axes match eight core bosses tied together by continuous upper/lower longitudinal shelves. Shelves overlap the side shell and remain outside the Cisco PSU envelope. |
| Rear fasteners ↔ structural shell | integrated, unvalidated | All four rear M3 receivers join a continuous 10 mm perimeter frame; both rear-cover variants retain the universal PSU outlet aperture. |
| JF13K intake ↔ chassis exhaust | integrated, thermal test required | Split side intake is the dominant inlet. Segmented opposite-side slots above the PSU vent the cooler/backplate cavity; the 110 × 46.34 mm rear aperture preserves the PSU outlet. Smoke and temperature testing remain mandatory. |
| BC-250 ↔ board spine | partially defined | Bare PCB envelope is now 308.0 × 144.3 × 1.6 mm and the split pocket is modeled; final edge clamps still require a real-board keepout check. |
| JF13K ↔ spine/chassis | partially defined | Official envelope and photo-derived placement are frozen; the spine load path reaches the shell. Non-contact transport-pad locations remain open. |
| Universal PSU receiver ↔ chassis | integrated, unvalidated | The internal 110 × 46.34 mm receiver is fused into the rear core through four side-wall bridges and stays behind X=318. Print clearance remains open. |
| NexGen PSU adapter ↔ receiver | defined, unvalidated | Server/FlexATX/LOP plate depths fit the common guides and interior clamps; print clearance remains untested. |
| Cisco PSU ↔ server adapter | reference-derived | Use the supplied NexGen universal server-PSU mount with an inward offset; no separate Cisco body measurement is required. |
| 2.5-inch cassette ↔ chassis | integrated, unvalidated | Front-load 110 × 80 mm cassette has guide walls, lips, rear stop and one accessible M3 retainer. It supports 7–15 mm devices; physical fit and cable direction remain open. |
| ESP32 cassette ↔ chassis | integrated, provisional | Horizontal 68 × 68 mm cassette has bottom guide rails, inner stop, printed detent and hidden side-service opening. Board posts and cable cuts await actual hardware. |
| Horizontal supports ↔ chassis | partially defined | Four bosses exist, but inserts and assembled fit are unvalidated. |
| Vertical rear/base cover ↔ chassis | integrated, unvalidated | The tapered cover and rear core share four M3 axes; insert fit, connector bend radius, and load test remain open. |

## Status of source models

The remaining `.scad` files are retained as design studies and reusable geometry only. They are **not release parts** and must not be sent to a print service. A source becomes releasable only after it is included in the master assembly, has a defined mating interface, passes collision checks, and receives a fresh export.

## Controlled recovery order

Confirmed architecture: BC-250 and the major internal components are vertical along the long axis, matching the Nyacom reference assembly. The earlier horizontal two-level layout is superseded.

1. Maintain `core-assembly-v0.1.scad` as the master coordinate source.
2. Complete both end-panel seats and their accessible retention.
3. Add final PCB edge clamps and non-contact JF13K transport pads after physical keepout checks.
4. Validate the integrated common PSU receiver with its clearance coupon and
   selected adapter plate.
5. Add horizontal and vertical supports against explicit chassis interfaces.
6. Freeze ESP32 sliding-post positions and cable exits after actual-board fit.
7. Run collision and manifold checks, then populate `cad/exports/release/<version>/` as one versioned set.

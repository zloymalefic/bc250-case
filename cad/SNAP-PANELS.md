# Hidden snap-fit panels v0.1

The 270 × 131 mm JF13K intake is divided into two independently removable halves:

- nominal half-panel print envelope: 140 × 131 × 12 mm including hooks and centre tongue;
- one 120 mm fan field per half;
- four hidden cantilever hooks per half;
- 5 mm overlapping tongue hides and aligns the centre seam;
- no external panel bolts;
- a damaged half can be replaced without reprinting the other side.

Initial PETG/ASA snap parameters:

- arm: 8.0 × 2.2 × 8.0 mm;
- barb engagement: 1.0 mm;
- receiver clearance: 0.30 mm per side.

These numbers are test values, not production values. Print `fit-calibration-coupon-v0.1.scad` first. Test at least five insertion/removal cycles and reject any setting that creates whitening, root cracking, excessive looseness, or a release force likely to damage the panel.

The matching eight receiver pockets are integrated into `chassis-split-v0.1.scad`. No hook is located on the structural front/rear chassis joint.

## Deferred fan-cover depth

These two halves are separate covers above the JF13K fans, not structural walls
and not cooler supports. Their current flat 4 mm skin is only an interface
prototype. Final inner relief/stand-off is intentionally deferred until a
physical fan-side check; it may rise locally beyond the nominal body-side datum.
The released covers must not touch the fan frames, screws, blades, or wiring and
must repeat the airflow/no-contact check independently of the main chassis.

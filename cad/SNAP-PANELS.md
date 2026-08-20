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

These numbers are test values, not production values. Print `snap-fit-coupon-v0.1.scad` first. Test at least five insertion/removal cycles and reject any setting that creates whitening, root cracking, excessive looseness, or a release force likely to damage the panel.

The matching eight receiver pockets are integrated into `chassis-split-v0.1.scad`. No hook is located on the structural front/rear chassis joint.

# Split chassis interface v0.1

> Historical prototype. The released working source is now
> `core-assembly-v0.1.scad`; its split intake, central rib and receiver pockets
> supersede the single 266 × 119 mm opening described below.

The 330 mm Nyacom-style structural tunnel is divided at X=165 mm:

- front section nominal print envelope: 174 × 155 × 195 mm, including its alignment collar;
- rear section nominal print envelope: 165 × 155 × 195 mm;
- both fit within the preliminary 250 × 250 × 250 mm part limit;
- a 9 mm internal octagonal collar aligns all eight shell faces;
- the collar overlaps 1.2 mm into the front shell so it is one fused printable solid rather than a coincident mesh;
- initial radial assembly clearance is 0.35 mm per side;
- the current axial M3 bosses are an obsolete prototype and will be replaced by bottom-access fasteners close to the seam.

## Functional interfaces added

- JF13K intake opening: 266 × 119 mm;
- eight magnet bosses matching the two four-magnet intake panels, plus four longitudinal guide tongues;
- receiver blocks are integrated into the inner top perimeter, not glued-on parts;
- continuous internal tray ledges run along both lower side walls;
- ledge top is Z=49 mm, matching the integrated board-tray origin;
- the intake opening and magnet pattern cross the chassis split without placing a pocket directly on the joint.
- four 13 mm reinforced floor bosses provide the corrected 258 × 99 mm horizontal-support pattern;
- bosses accept M4 clearance screws and provisional 5.6 mm heat-set-insert pilots installed from inside.

The collar clearance is provisional. Before rebuilding complete shell exports, print the three `exports/chassis-joint-coupon-*-v0.1.stl` pairs at 0.25, 0.35, and 0.45 mm clearance per side.

Magnet-pocket allowance remains provisional. Full chassis printing must wait until an 8.25 × 2.20 mm pocket coupon is tested with the selected material, print service, magnet coating and adhesive.

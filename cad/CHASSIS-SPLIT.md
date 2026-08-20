# Split chassis interface v0.1

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
- eight hidden receiver pockets matching the two four-hook intake panels;
- receiver blocks are integrated into the inner top perimeter, not glued-on parts;
- continuous internal tray ledges run along both lower side walls;
- ledge top is Z=49 mm, matching the integrated board-tray origin;
- the intake opening and receiver pattern cross the chassis split without placing a hook directly on the joint.
- four 13 mm reinforced floor bosses provide the corrected 258 × 99 mm horizontal-support pattern;
- bosses accept M4 clearance screws and provisional 5.6 mm heat-set-insert pilots installed from inside.

The collar clearance is provisional. Before printing complete shell sections, print `exports/chassis-joint-coupon-v0.1.stl`, which contains real chamfered interface pairs at 0.25, 0.35, and 0.45 mm clearance per side.

Receiver interference remains tied to the snap calibration coupon. Full chassis printing must wait until the selected material passes repeated insertion/removal testing.

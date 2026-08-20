# Structural core v0.1

`core-assembly-v0.1.scad` is the first replacement built after the assembly audit. It is a single source for both shell halves and their shared interface.

The component architecture follows the Nyacom reference: BC-250 is vertical in the longitudinal X-Z plane, JF13K projects toward the broad side intake, and the Cisco PSU is rotated to a 40 mm Y thickness on the opposite side of the board. The former horizontal two-level layout is superseded.

The JF13K proxy is now fixed to the official 241 × 121 × 92 mm product envelope
and centred on the locally verified 308.0 × 144.3 mm PCB datum. Supplied assembly
photographs validate the orientation and installed height. This leaves 9.4 mm
from the fan-side envelope to the inner intake-panel face; CAD rejects anything
below 6 mm. See `JF13K-PHOTO-FIT.md` for the evidence and residual checks.

## What is now mechanically closed

- front and rear use the same 330 × 155 × 195 mm coordinate system;
- the front half carries the 9 mm octagonal alignment collar;
- a fused collar anchor joins the collar to the front shell;
- two M3 heat-set bosses sit inside the collar near the bottom seam;
- the rear half provides matching bottom-access clearance and countersink holes;
- both screws can be installed after joining the halves without reaching through the 330 mm enclosure;
- screw heads remain underneath the case and outside normal service panels.

## Assembly sequence for the core

1. Install two selected M3 heat-set inserts into the front-core bosses from below.
2. Slide the rear core over the alignment collar.
3. Turn the joined core upside down.
4. Install two M3 countersunk screws through the rear floor into the front-core inserts.
5. Verify that the seam closes without deforming the collar.

The exact screw length and insert pilot remain provisional until the fit coupon is measured. No release STL is published yet.

## Next required interfaces

1. Front and rear bezel seats with accessible retention.
2. Matching snap receivers for both end service panels.
3. One vertical board spine shared by BC-250, JF13K load supports, and chassis.
4. Two rear-cover variants on one four-point M3 interface: a shallow horizontal
   cover and a 44 mm open cable-management base for tower orientation.
4. One internal PSU-rail pattern shared by rail and chassis.

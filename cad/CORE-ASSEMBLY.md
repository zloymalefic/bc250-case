# Structural core v0.1

`core-assembly-v0.1.scad` is the first replacement built after the assembly audit. It is a single source for both shell halves and their shared interface.

The component architecture follows the Nyacom reference: BC-250 is vertical in the longitudinal X-Z plane, JF13K projects toward the broad side intake, and the Cisco PSU is rotated to a 40 mm Y thickness on the opposite side of the board. The former horizontal two-level layout is superseded.

The JF13K proxy is now fixed to the official 241 × 121 × 92 mm product envelope
and centred on the locally verified 308.0 × 144.3 mm PCB datum. Supplied assembly
photographs validate the orientation and installed height. This leaves 9.4 mm
from the fan-side envelope to the inner intake-panel face; CAD rejects anything
below 6 mm. See `JF13K-PHOTO-FIT.md` for the evidence and residual checks.

The broad-side intake now consists of two chamfered 128 × 119 mm windows separated by a
real 10 mm shell rib at the chassis split. Two independent 130 × 131 mm covers
leave that rib visible. Their grille centres are fixed at global X=105 and
X=225 mm, matching the two JF13K fan centres. Eight magnet seats are
fused to the inner wall; the lower right pattern is shifted away from the ESP32
service path.

The covers repeat the same eight-sided outline with a 6 mm sealing overlap and
use a raised 108 mm circular rim around a regular hex field. The ESP32 service
extension is hidden by a recessed skirt attached to the right cover; it stays
inside the lower chassis chamfer instead of extending the exterior silhouette.

## What is now mechanically closed

- front and rear use the same 330 × 155 × 195 mm coordinate system;
- the front half carries the 9 mm octagonal alignment collar;
- a fused collar anchor joins the collar to the front shell;
- two M3 heat-set bosses sit inside the collar near the bottom seam;
- the rear half provides matching bottom-access clearance and countersink holes;
- both screws can be installed after joining the halves without reaching through the 330 mm enclosure;
- screw heads remain underneath the case and outside normal service panels.
- the separate split board spine is placed from the verified PCB datum;
- its eight transverse M4 axes now terminate in matching core bosses;
- shallow boss webs remain outside the central PSU envelope and carry the
  895 g JF13K transport load into the structural shell;
- the board/spine datum is shifted 4 mm below geometric centre, preserving
  2.65 mm between the lower 12 mm bosses and the provisional PSU envelope;
- both spine halves can be exported from the master coordinate source.
- the common NexGen 110 × 46.34 mm PSU receiver is fused into the rear core by
  four short corner bridges to the side walls;
- its rear extent stops at X=318, leaving 12 mm to the outside rear plane;
- server, FlexATX, and LOP adapter plates remain interchangeable service parts,
  while no PSU bracket protrudes outside the enclosure.
- the 125 × 175 mm Nyacom-proportioned front service panel has a rear support
  shoulder and four front-access countersunk M3 screws into fused insert bosses;
- the panel remains separately printable and removable without opening the
  structural chassis seam.
- two ribbed M3 insert bosses now retain the NexGen-derived button plate;
- the baseline Anker A7516 hub uses a vertical 28.6 × 71.0 mm opening and a
  separately printable four-port cassette with two hidden hooks;
- the cassette carries the 103 × 30 × 10 mm hub envelope, so a future cheaper
  hub changes the cassette rather than the main front panel wherever possible.
- both rear-cover variants are monolithic, matching the source-case strategy;
  temporary board/I/O and PSU blanks have been removed. Final connector cuts
  will be made directly in each rear variant after their positions are frozen.
- the front-load 2.5-inch cassette supports 7–15 mm devices on a 76.6 × 61.72
  mm M3 pattern and slides in the free pocket ahead of JF13K;
- two guide walls, retaining lips, a rear stop and one front-access M3 screw
  form a complete chassis interface without blocking the cooler intake.
- the 68 × 68 mm ESP32 relay cassette sits horizontally under JF13K, leaving
  3.6 mm nominal clearance to the cooler envelope;
- bottom guide rails, an inner stop and a printed detent allow side removal;
  a separate 78 × 36 mm vented cover closes the 74 × 28 mm service opening
  with four 8 × 2 mm magnet pairs and a 5 × 2 mm bottom pry notch.

## Assembly sequence for the core

1. Install two selected M3 heat-set inserts into the front-core bosses from below.
2. Slide the rear core over the alignment collar.
3. Turn the joined core upside down.
4. Install two M3 countersunk screws through the rear floor into the front-core inserts.
5. Verify that the seam closes without deforming the collar.

The exact screw length and insert pilot remain provisional until the fit coupon is measured. No release STL is published yet.

## Next required interfaces

1. Validate the 8.25 × 2.20 mm side/ESP32 magnet pockets with a small print coupon.
2. Add final connector apertures directly to both monolithic rear variants after
   cable and port alignment is frozen.
3. Physically check the Anker cassette, M3 button inserts, and switch travel.
4. Verify the selected 2.5-inch drive's SATA/power cable direction.
5. Measure the actual ESP32 relay-board hole pattern and connector exits, then
   freeze its adjustable posts.
3. Final BC-250 edge clamps and non-contact JF13K transport pads after physical
   keepout checks.
4. Two rear-cover variants on one four-point M3 interface: a shallow horizontal
   cover and a 44 mm open cable-management base for tower orientation.
4. Validate the internal PSU receiver and selected adapter with a clearance
   coupon before installing hardware.

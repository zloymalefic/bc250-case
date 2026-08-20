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
- the 125 × 165 mm front service panel now has a 2 mm recessed seat, a rear
  support shoulder, and four matching hidden snap receivers in the front core;
- the panel remains separately printable and removable without opening the
  structural chassis seam.
- two ribbed M3 insert bosses now retain the NexGen-derived button plate;
- the baseline Anker A7516 hub uses a vertical 28.6 × 71.0 mm opening and a
  separately printable four-port cassette with two hidden hooks;
- the cassette carries the 103 × 30 × 10 mm hub envelope, so a future cheaper
  hub changes the cassette rather than the main front panel wherever possible.
- both rear-cover variants now share two vertical snap seats: a 71.30 × 144.30
  mm board/I/O blank and a 47.30 × 144.30 mm PSU blank;
- each rear blank has four hidden hooks and a 2 mm support shoulder; final
  connector apertures are confined to these inexpensive replaceable parts.
- the front-load 2.5-inch cassette supports 7–15 mm devices on a 76.6 × 61.72
  mm M3 pattern and slides in the free pocket ahead of JF13K;
- two guide walls, retaining lips, a rear stop and one front-access M3 screw
  form a complete chassis interface without blocking the cooler intake.

## Assembly sequence for the core

1. Install two selected M3 heat-set inserts into the front-core bosses from below.
2. Slide the rear core over the alignment collar.
3. Turn the joined core upside down.
4. Install two M3 countersunk screws through the rear floor into the front-core inserts.
5. Verify that the seam closes without deforming the collar.

The exact screw length and insert pilot remain provisional until the fit coupon is measured. No release STL is published yet.

## Next required interfaces

1. Validate front- and rear-panel hooks with the existing clearance coupon.
2. Add final connector apertures to the replaceable rear blanks after cable and
   port alignment is frozen.
3. Physically check the Anker cassette, M3 button inserts, and switch travel.
4. Verify the selected 2.5-inch drive's SATA/power cable direction.
3. Final BC-250 edge clamps and non-contact JF13K transport pads after physical
   keepout checks.
4. Two rear-cover variants on one four-point M3 interface: a shallow horizontal
   cover and a 44 mm open cable-management base for tower orientation.
4. Validate the internal PSU receiver and selected adapter with a clearance
   coupon before installing hardware.

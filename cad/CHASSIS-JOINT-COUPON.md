# Chassis joint coupon v0.1

The complete chassis sections are too large and expensive to use as calibration prints. `chassis-joint-coupon-v0.1.scad` therefore extracts the actual bottom-left chamfered corner of the shell and collar.

The export set contains three labelled STL files, each with one male/female pair. Their radial clearances are 0.25, 0.35, and 0.45 mm per side. Every pair includes the real 4 mm shell, 2.4 mm collar wall, chamfer transition, 9 mm insertion length, and a fused anchor extending 1.2 mm into the front shell.

## Procedure

1. Print the three `chassis-joint-coupon-*-v0.1.stl` files together; each file is one matched pair.
2. Print using the final chassis material, orientation, layer height, wall count, and cooling settings.
3. Deburr only the same way planned for production; do not sand a poor fit into compliance.
4. Insert fully, separate, and repeat at least ten times.
5. Select the smallest clearance that seats fully by hand without cracking, whitening, or rocking after repeated cycles.
6. Record the result in the table and update `collar_clearance` in `chassis-split-v0.1.scad`.

| Clearance per side | Seats fully | Releases cleanly | Visible play | Damage after 10 cycles | Decision |
|---:|---|---|---|---|---|
| 0.25 mm | — | — | — | — | — |
| 0.35 mm | — | — | — | — | — |
| 0.45 mm | — | — | — | — | — |

The obsolete axial M3 boss concept is intentionally absent. A production screw cannot practically be inserted along the full enclosure length. Structural retention will use bottom-access fasteners close to the seam and remain hidden by the horizontal or vertical support system.

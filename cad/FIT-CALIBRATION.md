# Fit calibration coupon v0.1

`fit-calibration-coupon-v0.1.scad` combines the material-dependent interfaces that must be tested before ordering full-size case prints.

The exported set contains:

- blind M3 heat-set-insert pilots: 4.0, 4.2, and 4.4 mm;
- blind M4 heat-set-insert pilots: 5.0, 5.2, and 5.4 mm;
- M3 screw holes: 3.0, 3.2, and 3.4 mm;
- M4 screw holes: 4.2, 4.4, and 4.6 mm;
- one production-size snap hook;
- three snap receivers with 0.20, 0.30, and 0.40 mm clearance per side.

## Test procedure

1. Print the coupon in the same material, layer height, wall count, orientation, and printer profile planned for the case.
2. Measure every hole with calipers before installing hardware; record nominal and measured diameters.
3. Install only the exact insert model intended for the build. The insert must enter straight without splitting or visibly bulging the wall.
4. Check M3 and M4 screws by hand. Select the smallest through-hole that does not require threading or excessive force.
5. Test the hook in all three receivers for at least ten insertion/removal cycles. Reject whitening, root cracks, permanent bending, excessive play, or destructive release force.
6. Record the selected values below and update `lib/snap-interface.scad`, `lib/common.scad`, `chassis-split-v0.1.scad`, and `BOM.md` before printing full panels.

## Results

| Parameter | Selected nominal value | Measured printed value | Material/profile | Notes |
|---|---:|---:|---|---|
| M3 insert pilot | — | — | — | — |
| M4 insert pilot | — | — | — | — |
| M3 clearance hole | — | — | — | — |
| M4 clearance hole | — | — | — | — |
| Snap clearance per side | — | — | — | — |

Do not infer the final pilot diameter only from the insert's outside diameter. Heat-set insert geometry and manufacturer recommendations differ.


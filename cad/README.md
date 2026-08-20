# CAD workspace

Current status: **design recovery; no printable enclosure release**.

Read `ASSEMBLY-AUDIT.md` before using any model. It records why the previous collection could not be assembled and defines the recovery order.

## Safe outputs

Only the small test pieces in `exports/` are currently approved for slicing. See `exports/README.md`.

```sh
openscad -o exports/fit-calibration-coupon-v0.1.stl fit-calibration-coupon-v0.1.scad
openscad -D 'clearances=[0.25]' -o exports/chassis-joint-coupon-0.25mm-v0.1.stl chassis-joint-coupon-v0.1.scad
openscad -D 'clearances=[0.35]' -o exports/chassis-joint-coupon-0.35mm-v0.1.stl chassis-joint-coupon-v0.1.scad
openscad -D 'clearances=[0.45]' -o exports/chassis-joint-coupon-0.45mm-v0.1.stl chassis-joint-coupon-v0.1.scad
```

## Retained studies

Other `.scad` files are non-release studies. They preserve useful dimensions and geometry for rebuilding the master assembly, but their interfaces are incomplete. Successful OpenSCAD compilation does not make a study printable or compatible with another study.

The exterior direction is documented by `previews/exterior-nyacom-v0.2.svg`. It is an orthographic visual concept, not a manufacturing drawing.

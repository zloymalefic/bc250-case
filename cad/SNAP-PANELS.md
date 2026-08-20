# Magnetic intake panels v0.2

The JF13K intake is divided into two independently removable 130 × 131 mm covers:

- nominal half-panel print envelope: 130 × 131 × 8 mm including grille relief;
- one 120 mm fan field per half;
- four 8 × 2 mm magnet pairs per half;
- a small bottom-edge pry notch for non-destructive removal;
- two shallow longitudinal guide channels engaging chassis tongues;
- a 10 mm visible gap exposes the structural rib retained in the shell;
- matching eight-sided cover/window outlines and a raised 108 mm fan rim;
- no external panel bolts;
- a damaged half can be replaced without reprinting the other side.

Magnet pockets are 8.25 mm diameter and 2.20 mm deep. The dimensional allowance
is deliberately conservative for ordered printing and adhesive. Print a pocket
coupon with the intended material and service before committing the full covers.

The matching eight chassis magnet seats, four guide tongues and 10 mm central
rib are integrated into `core-assembly-v0.1.scad`. No magnet pocket is placed on
the front/rear chassis joint. The tongues prevent panel shear and act as local
longitudinal stiffeners around the large intake opening; the magnets only resist
pull-off force.

The historical SCAD filename `intake-panel-snap-v0.1.scad` is retained so the
existing export tooling does not break; its production geometry contains no
panel hooks.

## Deferred fan-cover depth

These two halves are separate covers above the JF13K fans, not structural walls
and not cooler supports. Their current flat 4 mm skin is only an interface
prototype. Final inner relief/stand-off is intentionally deferred until a
physical fan-side check; it may rise locally beyond the nominal body-side datum.
The released covers must not touch the fan frames, screws, blades, or wiring and
must repeat the airflow/no-contact check independently of the main chassis.

The rear/lower fan-cover half also hides the ESP32 cassette service extension.
Its local lower skirt must reach the Z=4 mm body datum over X=177–251 mm; this
requirement is frozen even though the final fan-cover depth remains deferred.

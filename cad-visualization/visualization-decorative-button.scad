// Decorative exterior bezel for the NexGen-derived power button.
//
// Visualization-only geometry: the supplied logo cap remains a separate mesh,
// while this part gives it a deliberate exterior surround. Local X is the
// front/rear axis, with X=0 at the panel side and negative X facing outward.

$fn = 96;

outer_d = 23.6;
inner_d = 16.5;
depth = 3.8;
front_lip = 0.9;

module beveled_ring() {
    // Build around Z and rotate so the exported button axis is X.
    rotate([0, -90, 0])
        rotate_extrude(convexity = 10)
            polygon([
                [inner_d / 2, 0],
                [outer_d / 2 - 1.8, 0],
                [outer_d / 2, front_lip],
                [outer_d / 2, depth - 0.7],
                [outer_d / 2 - 0.7, depth],
                [inner_d / 2 + 0.5, depth],
                [inner_d / 2, depth - 0.5]
            ]);
}

module decorative_bezel() {
    difference() {
        beveled_ring();

        // Eight shallow grip cuts catch highlights without competing with the
        // logo. They also make the ring read as a separate machined component.
        for (angle = [0 : 45 : 315])
            rotate([angle, 0, 0])
                translate([-depth + 0.35, outer_d / 2 - 0.25, -0.65])
                    cube([1.2, 1.0, 1.3]);
    }
}

decorative_bezel();

echo("decorative_button_bezel_mm", [depth, outer_d, inner_d]);
echo("axis", "X; X=0 panel side, negative X outward");

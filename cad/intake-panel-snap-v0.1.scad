// Split JF13K intake panel with hidden NexGen-style snap hooks.
include <lib/snap-interface.scad>

$fn = 32;

part = "left"; // left | right | assembly

// Interface prototype only: final fan-facing cover relief is deliberately
// deferred and may be raised locally. Do not release this flat skin for print.
panel_half = [130, 131, 4];
panel_chamfer = 10;
panel_gap = 10;
grille_outer_d = 108;
grille_inner_d = 101;
grille_relief = 1.2;

module chamfered_panel_2d(width, height, cut) {
    polygon([
        [cut, 0], [width - cut, 0], [width, cut],
        [width, height - cut], [width - cut, height],
        [cut, height], [0, height - cut], [0, cut]
    ]);
}

module panel_skin() {
    linear_extrude(height = panel_half[2])
        chamfered_panel_2d(panel_half[0], panel_half[1], panel_chamfer);
}

module fan_field(cx) {
    for (row = [-5 : 5], column = [-5 : 5]) {
        dx = column * 9 + ((abs(row) % 2) * 4.5);
        dy = row * 8;
        if (dx * dx + dy * dy < 46 * 46)
            translate([cx + dx, panel_half[1] / 2 + dy, -1])
                cylinder(h = panel_half[2] + grille_relief + 2,
                         d = 6.8, $fn = 6);
    }
}

module grille_ring(cx) {
    translate([cx, panel_half[1] / 2, panel_half[2] - 0.01])
        difference() {
            cylinder(h = grille_relief, d = grille_outer_d);
            translate([0, 0, -0.1])
                cylinder(h = grille_relief + 0.2, d = grille_inner_d);
        }
}

module recessed_esp32_skirt() {
    // Closes the lower service opening on the right half while remaining 8 mm
    // behind the exterior face, inside the lower chassis chamfer.
    translate([7, -24, -10])
        linear_extrude(height = 2)
            chamfered_panel_2d(74, 28, 5);
    for (x = [20, 68])
        translate([x, 0, -10]) cube([4, 5, 10.2]);
}

module hook_set(lower_x = [18, panel_half[0] - 18]) {
    // Hooks face the long receiver rails. A concealed edge notch releases them.
    for (x = lower_x)
        translate([x, 4, 0]) snap_hook();
    for (x = [18, panel_half[0] - 18])
        translate([x, panel_half[1] - 4, 0]) rotate([0, 0, 180]) snap_hook();
}

module left_panel() {
    union() {
        difference() {
            panel_skin();
            fan_field(75);
        }
        grille_ring(75);
        hook_set();
    }
}

module right_panel() {
    union() {
        difference() {
            panel_skin();
            fan_field(55);
        }
        grille_ring(55);
        recessed_esp32_skirt();
        hook_set([88, panel_half[0] - 18]);
    }
}

if (part == "left") left_panel();
else if (part == "right") right_panel();
else {
    color([0.16, 0.17, 0.19]) left_panel();
    color([0.19, 0.20, 0.22])
        translate([panel_half[0] + panel_gap, 0, 0]) right_panel();
}

echo("part", part);
echo("panel_half_print_bounds_nominal_mm", [panel_half[0], panel_half[1], panel_half[2] + snap_arm_drop]);
echo("structural_gap_mm", panel_gap);
echo("snap_count_per_half", 4);
assert(panel_half[0] <= 250 && panel_half[1] <= 250, "Panel half exceeds 250 mm print-bed limit");

// Split JF13K intake panel with hidden NexGen-style snap hooks.
include <lib/snap-interface.scad>

$fn = 32;

part = "left"; // left | right | assembly

panel_half = [135, 131, 4];
panel_radius = 6;
seam_tongue = 5;
seam_clearance = 0.30;

module rounded_panel(size, radius) {
    hull()
        for (x = [radius, size[0] - radius], y = [radius, size[1] - radius])
            translate([x, y, 0]) cylinder(h = size[2], r = radius);
}

module fan_field(cx) {
    for (dx = [-48 : 10 : 48], dy = [-48 : 9 : 48])
        if (dx * dx + dy * dy < 50 * 50)
            translate([cx + dx + ((round(dy / 9) % 2) * 5), panel_half[1] / 2 + dy, -1])
                cylinder(h = panel_half[2] + 2, d = 6.4, $fn = 6);
}

module hook_set() {
    // Hooks face the long receiver rails. A concealed edge notch releases them.
    for (x = [18, panel_half[0] - 18]) {
        translate([x, 4, 0]) snap_hook();
        translate([x, panel_half[1] - 4, 0]) rotate([0, 0, 180]) snap_hook();
    }
}

module left_panel() {
    union() {
        difference() {
            rounded_panel(panel_half, panel_radius);
            fan_field(74);
        }
        // Low-profile tongue hides and aligns the centre seam.
        translate([panel_half[0] - 0.1, 18, 0.8])
            cube([seam_tongue, panel_half[1] - 36, 2.4]);
        hook_set();
    }
}

module right_panel() {
    difference() {
        union() {
            difference() {
                rounded_panel(panel_half, panel_radius);
                fan_field(60);
            }
            hook_set();
        }
        translate([-0.1, 18 - seam_clearance, 0.5])
            cube([seam_tongue + seam_clearance + 0.2, panel_half[1] - 36 + 2 * seam_clearance, 3.0]);
    }
}

if (part == "left") left_panel();
else if (part == "right") right_panel();
else {
    color([0.16, 0.17, 0.19]) left_panel();
    color([0.19, 0.20, 0.22]) translate([panel_half[0], 0, 0]) right_panel();
}

echo("part", part);
echo("panel_half_print_bounds_nominal_mm", [panel_half[0] + seam_tongue, panel_half[1], panel_half[2] + snap_arm_drop]);
echo("snap_count_per_half", 4);
assert(panel_half[0] + seam_tongue <= 250 && panel_half[1] <= 250, "Panel half exceeds 250 mm print-bed limit");

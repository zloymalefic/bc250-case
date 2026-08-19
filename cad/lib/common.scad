// Shared mechanical parameters and primitives.
// Units: millimetres.

$fn = 48;

chassis = [330, 170, 170];
wall = 3;
corner_radius = 8;

// Common external support interface.
// Four M4 fasteners, symmetric about chassis centreline.
support_station_x = [36, chassis[0] - 36];
support_station_y = [28, chassis[1] - 28];
support_screw_d = 4.5;
support_head_d = 8.5;
support_head_h = 3.2;
support_pad_h = 8;

module rounded_box(size, radius) {
    hull() {
        for (x = [radius, size[0] - radius], y = [radius, size[1] - radius])
            translate([x, y, 0]) cylinder(h = size[2], r = radius);
    }
}

module countersunk_support_hole(height) {
    translate([0, 0, -0.1]) cylinder(h = height + 0.2, d = support_screw_d);
    translate([0, 0, -0.1])
        cylinder(h = support_head_h + 0.1, d1 = support_head_d, d2 = support_screw_d);
}

module interface_marker() {
    for (x = support_station_x, y = support_station_y)
        translate([x, y, 0]) children();
}

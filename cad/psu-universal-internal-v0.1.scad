// Fully internal universal PSU chassis.
// Conceptual interface derived from NexGen's separate PSU mount strategy.
// No part of the PSU carrier may exceed the common body envelope.

$fn = 32;

variant = "cisco"; // cisco | flexatx

body_length = 330;
rear_inner_plane = 318;
rail_origin = [43, 13, 7];
rail_size = [252, 104, 6];
adapter_pitch_y = 82;

// Provisional equipment envelopes. Replace after physical measurement.
cisco = [240, 96, 40];
flexatx = [150, 81.5, 40.5];

module elongated_hole(length = 14, diameter = 4.5, height = 10) {
    hull() {
        translate([-length / 2 + diameter / 2, 0, 0]) cylinder(h = height, d = diameter);
        translate([ length / 2 - diameter / 2, 0, 0]) cylinder(h = height, d = diameter);
    }
}

module common_rail() {
    color([0.20, 0.22, 0.25])
    difference() {
        translate(rail_origin) cube(rail_size);
        for (x = [rail_origin[0] + 22 : 35 : rail_origin[0] + rail_size[0] - 18],
             y = [rail_origin[1] + 11, rail_origin[1] + rail_size[1] - 11])
            translate([x, y, rail_origin[2] - 1]) elongated_hole(16, 4.5, rail_size[2] + 2);
    }
}

module cisco_adapter() {
    origin = [49, 17, rail_origin[2] + rail_size[2]];
    color([0.92, 0.45, 0.08]) {
        translate(origin) cube([cisco[0], 4, 12]);
        translate([origin[0], origin[1] + cisco[1] - 4, origin[2]]) cube([cisco[0], 4, 12]);
        translate([origin[0] + cisco[0] - 5, origin[1], origin[2]]) cube([5, cisco[1], 26]);
    }
    color([0.92, 0.45, 0.08])
        translate([origin[0] - 3, origin[1] + 32, origin[2] + 3]) cube([6, 32, 7]);
}

module flexatx_adapter() {
    origin = [108, 24.25, rail_origin[2] + rail_size[2]];
    color([0.18, 0.48, 0.88]) {
        translate(origin) cube([flexatx[0], 4, 12]);
        translate([origin[0], origin[1] + flexatx[1] - 4, origin[2]]) cube([flexatx[0], 4, 12]);
        translate([origin[0] + flexatx[0] - 5, origin[1], origin[2]]) cube([5, flexatx[1], 30]);
    }
}

module envelope(size, origin) {
    color([0.55, 0.58, 0.62, 0.28]) translate(origin) cube(size);
}

common_rail();
if (variant == "cisco") {
    cisco_adapter();
    envelope(cisco, [49, 17, rail_origin[2] + rail_size[2]]);
} else {
    flexatx_adapter();
    envelope(flexatx, [108, 24.25, rail_origin[2] + rail_size[2]]);
}

echo("variant", variant);
echo("rail_end_x", rail_origin[0] + rail_size[0]);
echo("rear_inner_plane_x", rear_inner_plane);
echo("flush_margin_mm", rear_inner_plane - (rail_origin[0] + rail_size[0]));
assert(rail_origin[0] + rail_size[0] <= rear_inner_plane, "PSU rail protrudes beyond rear inner plane");

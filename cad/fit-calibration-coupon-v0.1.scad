// Combined printer/material calibration coupon for the BC-250 case.
// Tests heat-set insert pilots, screw clearance holes, and snap receiver gaps.
include <lib/snap-interface.scad>

$fn = 48;

plate = [118, 52, 8];
label_depth = 0.5;
insert_depth = 6.2;

m3_insert_pilots = [4.0, 4.2, 4.4];
m4_insert_pilots = [5.0, 5.2, 5.4];
m3_clearance_holes = [3.0, 3.2, 3.4];
m4_clearance_holes = [4.2, 4.4, 4.6];
snap_clearances = [0.20, 0.30, 0.40];

module engraved_label(value, position, size = 3.2) {
    translate([position[0], position[1], plate[2] - label_depth])
        linear_extrude(height = label_depth + 0.1)
            text(value, size = size, halign = "center", valign = "center");
}

module hole_row(values, y, blind = false) {
    for (i = [0 : len(values) - 1]) {
        x = 18 + i * 24;
        if (blind)
            translate([x, y, plate[2] - insert_depth])
                cylinder(h = insert_depth + 0.1, d = values[i]);
        else
            translate([x, y, -0.1])
                cylinder(h = plate[2] + 0.2, d = values[i]);
        engraved_label(str(values[i]), [x, y + 9]);
    }
}

module fastener_plate() {
    difference() {
        cube(plate);

        // Blind pilots are printed vertically and opened from the top.
        hole_row(m3_insert_pilots, 12, true);
        hole_row(m4_insert_pilots, 34, true);

        // Through holes occupy the right side of the same compact plate.
        for (i = [0 : 2]) {
            x = 88 + i * 10;
            translate([x, 12, -0.1]) cylinder(h = plate[2] + 0.2, d = m3_clearance_holes[i]);
            translate([x, 34, -0.1]) cylinder(h = plate[2] + 0.2, d = m4_clearance_holes[i]);
            engraved_label(str(m3_clearance_holes[i]), [x, 21], 2.4);
            engraved_label(str(m4_clearance_holes[i]), [x, 43], 2.4);
        }

        engraved_label("M3 INSERT", [42, 25], 3.0);
        engraved_label("M4 INSERT", [42, 47], 3.0);
    }
}

module receiver_with_clearance(clearance) {
    difference() {
        cube([24, 12, 12]);
        translate([12, 0, 12]) snap_receiver_slot(12, clearance);
    }
}

module snap_hook_coupon() {
    cube([30, 22, 4]);
    translate([15, 20 - snap_arm_thickness, 0]) snap_hook();
}

fastener_plate();

// Separate printable pieces: one hook and three receivers.
// Flip the hook coupon so its arm grows upward without support material.
translate([128, 22, 4]) rotate([180, 0, 0]) snap_hook_coupon();
for (i = [0 : len(snap_clearances) - 1])
    translate([128 + i * 30, 32, 0]) receiver_with_clearance(snap_clearances[i]);

echo("M3 heat-set pilot candidates mm", m3_insert_pilots);
echo("M4 heat-set pilot candidates mm", m4_insert_pilots);
echo("M3 clearance candidates mm", m3_clearance_holes);
echo("M4 clearance candidates mm", m4_clearance_holes);
echo("snap clearance per side candidates mm", snap_clearances);

// Split structural tunnel v0.1.
// Two printable shell sections with an internal alignment collar.
// External styling follows exterior-nyacom-v0.2.scad.
include <lib/snap-interface.scad>

$fn = 32;

part = "assembly"; // front | rear | assembly

body = [330, 155, 195];
chamfer = 16;
wall = 4;
split_x = 165;
collar_length = 9;
collar_embed = 1.2;
collar_clearance = 0.35; // per side; tune with material coupon
collar_wall = 2.4;
assembly_gap = 12;

intake_opening = [266, 119];
intake_origin = [32, 18];
panel_origin = [30, 12];
panel_half_length = 135;
receiver_x_local = [18, panel_half_length - 18];
receiver_y = [panel_origin[1] + 4, panel_origin[1] + 131 - 4];
receiver_block = [12, 9, 12];
tray_ledge_z = 45;
tray_ledge = [body[0] - 12, 7, 4];
support_station_x = [36, body[0] - 36];
support_station_y = [28, body[1] - 28];
support_boss_d = 13;
support_boss_h = 10;
support_screw_d = 4.5;
support_insert_pilot_d = 5.6; // provisional; tune to selected M4 insert

module oct_prism_x(length, width, height, cut) {
    translate([0, 0, height])
        rotate([0, 90, 0])
            linear_extrude(height = length)
                polygon([
                    [cut, 0], [height - cut, 0], [height, cut],
                    [height, width - cut], [height - cut, width],
                    [cut, width], [0, width - cut], [0, cut]
                ]);
}

module full_open_shell() {
    difference() {
        oct_prism_x(body[0], body[1], body[2], chamfer);
        translate([-1, wall, wall])
            oct_prism_x(body[0] + 2, body[1] - 2 * wall, body[2] - 2 * wall, chamfer - wall);
    }
}

module receiver_blocks() {
    for (half_x = [panel_origin[0], panel_origin[0] + panel_half_length],
         local_x = receiver_x_local,
         y = receiver_y)
        translate([
            half_x + local_x - receiver_block[0] / 2,
            y < body[1] / 2 ? 13 : body[1] - 13 - receiver_block[1],
            body[2] - receiver_block[2]
        ]) cube(receiver_block);
}

module tray_ledges() {
    // Continuous ledges carry the tray; screw locations can be drilled into
    // elongated tray slots after the physical fit check.
    translate([6, 3.4, tray_ledge_z]) cube(tray_ledge);
    translate([6, body[1] - 3.4 - tray_ledge[1], tray_ledge_z]) cube(tray_ledge);
}

module support_bosses() {
    for (x = support_station_x, y = support_station_y)
        translate([x, y, 3]) cylinder(h = support_boss_h, d = support_boss_d);
}

module support_boss_holes() {
    for (x = support_station_x, y = support_station_y) {
        // Screw clearance through the floor.
        translate([x, y, -0.1]) cylinder(h = 6.2, d = support_screw_d);
        // Heat-set insert pilot opens from the inside.
        translate([x, y, 5.5]) cylinder(h = support_boss_h + 0.2, d = support_insert_pilot_d);
    }
}

module snap_receiver_cutouts() {
    for (half_x = [panel_origin[0], panel_origin[0] + panel_half_length],
         local_x = receiver_x_local,
         y = receiver_y)
        translate([
            half_x + local_x - snap_arm_width / 2 - snap_slot_clearance,
            y < body[1] / 2 ? 12.8 : body[1] - 12.8 - 5.2,
            body[2] - snap_arm_drop - snap_slot_clearance - 0.5
        ]) cube([
            snap_arm_width + 2 * snap_slot_clearance,
            5.2,
            snap_arm_drop + snap_slot_clearance + 1
        ]);
}

module functional_shell() {
    difference() {
        union() {
            full_open_shell();
            receiver_blocks();
            tray_ledges();
            support_bosses();
        }

        // Large dual-fan intake. The split panels overlap this opening.
        translate([intake_origin[0], intake_origin[1], body[2] - wall - 1])
            cube([intake_opening[0], intake_opening[1], wall + 2]);

        snap_receiver_cutouts();
        support_boss_holes();
    }
}

module shell_slice(x0, length) {
    intersection() {
        functional_shell();
        translate([x0, -1, -1]) cube([length, body[1] + 2, body[2] + 2]);
    }
}

module male_alignment_collar() {
    outer_inset = wall + collar_clearance;
    union() {
        // Working collar starts 0.2 mm inside the front section for a robust union.
        translate([split_x - 0.2, outer_inset, outer_inset])
        difference() {
            oct_prism_x(collar_length + 0.2, body[1] - 2 * outer_inset, body[2] - 2 * outer_inset, chamfer - outer_inset);
            translate([-0.5, collar_wall, collar_wall])
                oct_prism_x(collar_length + 1.2, body[1] - 2 * outer_inset - 2 * collar_wall, body[2] - 2 * outer_inset - 2 * collar_wall, chamfer - outer_inset - collar_wall);
        }

        // Taperless buried anchor bridges the shell wall and clearance gap.
        anchor_inset = wall - 0.2;
        anchor_thickness = collar_wall + collar_clearance + 0.4;
        translate([split_x - collar_embed, anchor_inset, anchor_inset])
        difference() {
            oct_prism_x(collar_embed + 0.4, body[1] - 2 * anchor_inset, body[2] - 2 * anchor_inset, chamfer - anchor_inset);
            translate([-0.5, anchor_thickness, anchor_thickness])
                oct_prism_x(collar_embed + 1.4, body[1] - 2 * anchor_inset - 2 * anchor_thickness, body[2] - 2 * anchor_inset - 2 * anchor_thickness, chamfer - anchor_inset - anchor_thickness);
        }
    }
}

module joint_boss_x(xpos, length, ypos, zpos) {
    // Internal M3 boss. The screw axis crosses the chassis split along X.
    translate([xpos, ypos, zpos])
        rotate([0, 90, 0])
            difference() {
                cylinder(h = length, d = 10);
                translate([0, 0, -0.1]) cylinder(h = length + 0.2, d = 3.2);
            }
}

module front_section() {
    union() {
        shell_slice(0, split_x);
        male_alignment_collar();
        joint_boss_x(split_x - 14, 14, wall + 3, 38);
        joint_boss_x(split_x - 14, 14, body[1] - wall - 3, body[2] - 38);
    }
}

module rear_section() {
    union() {
        shell_slice(split_x, body[0] - split_x);
        joint_boss_x(split_x, 14, wall + 3, 38);
        joint_boss_x(split_x, 14, body[1] - wall - 3, body[2] - 38);
    }
}

if (part == "front")
    front_section();
else if (part == "rear")
    translate([-split_x, 0, 0]) rear_section();
else {
    color([0.10, 0.11, 0.13]) front_section();
    color([0.17, 0.18, 0.20]) translate([assembly_gap, 0, 0]) rear_section();
}

echo("part", part);
echo("front_print_bounds_nominal_mm", [split_x + collar_length, body[1], body[2]]);
echo("rear_print_bounds_nominal_mm", [body[0] - split_x, body[1], body[2]]);
echo("collar_clearance_per_side_mm", collar_clearance);
echo("intake_opening_mm", intake_opening);
echo("snap_receiver_count", 8);
echo("tray_ledge_top_z_mm", tray_ledge_z + tray_ledge[2]);
echo("horizontal_support_pitch_mm", [support_station_x[1] - support_station_x[0], support_station_y[1] - support_station_y[0]]);
assert(split_x + collar_length <= 250, "Front section exceeds preliminary 250 mm print-bed limit");
assert(body[0] - split_x <= 250, "Rear section exceeds preliminary 250 mm print-bed limit");

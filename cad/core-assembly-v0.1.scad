// BC-250 case core v0.1
// Single source for the two structural shell halves and their real retention.
// Units: millimetres. Global axes: X front-to-rear, Y left-to-right, Z bottom-to-top.

$fn = 40;

part = "assembly"; // front-core | rear-core | rear-cover-horizontal | rear-cover-vertical | assembly
exploded_gap = 0;
show_fasteners = true;
show_equipment = true;
rear_cover = "vertical"; // none | horizontal | vertical

body = [330, 155, 195];
split_x = 165;
wall = 4;
chamfer = 16;

collar_length = 9;
collar_clearance = 0.35;
collar_wall = 2.4;
collar_anchor = 1.2;

seam_fastener_x = split_x + 4.5;
seam_fastener_y = [30, body[1] - 30];
seam_boss_d = 11;
seam_boss_h = 11;
m3_insert_pilot_d = 4.2; // provisional; select with fit coupon
m3_floor_clearance_d = 3.4;
m3_csk_head_d = 6.4;
m3_csk_depth = 1.8;

// Common rear-cover interface. Both rear-cover variants use the same four axes
// and accept the same future PSU/I/O service cassette.
rear_mount_y = [30, body[1] - 30];
rear_mount_z = [5, body[2] - 5];
rear_boss_d = 14;
rear_boss_depth = 10;
rear_cover_clearance_d = 3.4;
rear_service_opening = [125, 165];

horizontal_cover_depth = 6;
vertical_cover_depth = 44;
vertical_base_overhang = 15;
vertical_base_footprint = [
    body[1] + 2 * vertical_base_overhang,
    body[2] + 2 * vertical_base_overhang
];
vertical_base_ring_depth = 4;
vertical_pad_d = 12;
vertical_pad_recess = 1.0;

side_intake_opening = [266, 119];
side_intake_origin = [32, 18];

// Confirmed Nyacom architecture: all major components are vertical.
board = [311.7, 1.6, 144];
board_origin = [(body[0] - board[0]) / 2, 48, 25];
cisco_psu = [240, 40, 96];
cisco_origin = [70, 6, 30];
jf13k = [240, 92, 121]; // conservative installed envelope, pending measurement
jf13k_origin = [45, board_origin[1] + board[1] + 0.4, 36];

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

module open_shell() {
    difference() {
        oct_prism_x(body[0], body[1], body[2], chamfer);
        translate([-1, wall, wall])
            oct_prism_x(body[0] + 2, body[1] - 2 * wall, body[2] - 2 * wall, chamfer - wall);

        translate([side_intake_origin[0], body[1] - wall - 1, side_intake_origin[1]])
            cube([side_intake_opening[0], wall + 2, side_intake_opening[1]]);
    }
}

module collar_ring(length, inset, thickness) {
    translate([0, inset, inset])
    difference() {
        oct_prism_x(length, body[1] - 2 * inset, body[2] - 2 * inset, chamfer - inset);
        translate([-0.5, thickness, thickness])
            oct_prism_x(length + 1, body[1] - 2 * inset - 2 * thickness, body[2] - 2 * inset - 2 * thickness, chamfer - inset - thickness);
    }
}

module alignment_collar() {
    working_inset = wall + collar_clearance;
    union() {
        translate([split_x - 0.2, 0, 0])
            collar_ring(collar_length + 0.2, working_inset, collar_wall);

        // Buried anchor overlaps both the shell wall and working collar.
        anchor_inset = wall - 0.2;
        anchor_thickness = collar_wall + collar_clearance + 0.4;
        translate([split_x - collar_anchor, 0, 0])
            collar_ring(collar_anchor + 0.4, anchor_inset, anchor_thickness);
    }
}

module seam_insert_bosses() {
    // Inserts are installed from the bottom before the halves are joined.
    for (y = seam_fastener_y)
        translate([seam_fastener_x, y, wall + collar_clearance - 0.2])
        difference() {
            cylinder(h = seam_boss_h, d = seam_boss_d);
            translate([0, 0, -0.1]) cylinder(h = seam_boss_h + 0.2, d = m3_insert_pilot_d);
        }
}

module rear_seam_holes() {
    for (y = seam_fastener_y) {
        translate([seam_fastener_x, y, -0.1])
            cylinder(h = wall + collar_clearance + 0.5, d = m3_floor_clearance_d);
        translate([seam_fastener_x, y, -0.1])
            cylinder(h = m3_csk_depth + 0.1, d1 = m3_csk_head_d, d2 = m3_floor_clearance_d);
    }
}

module rear_interface_bosses() {
    for (y = rear_mount_y, z = rear_mount_z)
        translate([body[0] - rear_boss_depth, y, z])
        rotate([0, 90, 0])
        difference() {
            cylinder(h = rear_boss_depth, d = rear_boss_d);
            // Blind heat-set pilot opens only at the rear face.
            translate([0, 0, rear_boss_depth - 6.2])
                cylinder(h = 6.3, d = m3_insert_pilot_d);
        }
}

module rear_cover_screw_holes(x0, length) {
    for (y = rear_mount_y, z = rear_mount_z)
        translate([x0 - 0.1, y, z])
        rotate([0, 90, 0]) {
            cylinder(h = length + 0.2, d = rear_cover_clearance_d);
            translate([0, 0, length - m3_csk_depth])
                cylinder(h = m3_csk_depth + 0.2,
                         d1 = rear_cover_clearance_d, d2 = m3_csk_head_d);
        }
}

module rear_service_window(length, margin = 0.4) {
    translate([
        body[0] - 0.1,
        (body[1] - rear_service_opening[0]) / 2 - margin,
        (body[2] - rear_service_opening[1]) / 2 - margin
    ])
        cube([length + 0.2,
              rear_service_opening[0] + 2 * margin,
              rear_service_opening[1] + 2 * margin]);
}

module rear_cover_horizontal_global() {
    difference() {
        translate([body[0], 0, 0])
            oct_prism_x(horizontal_cover_depth, body[1], body[2], chamfer);
        rear_service_window(horizontal_cover_depth);
        rear_cover_screw_holes(body[0], horizontal_cover_depth);
    }
}

module vertical_base_outer_ring() {
    outer_y = -vertical_base_overhang;
    outer_z = -vertical_base_overhang;
    x0 = body[0] + vertical_cover_depth - vertical_base_ring_depth;
    difference() {
        translate([x0, outer_y, outer_z])
            oct_prism_x(vertical_base_ring_depth,
                        vertical_base_footprint[0], vertical_base_footprint[1],
                        chamfer + vertical_base_overhang);
        translate([x0 - 0.1, -0.5, -0.5])
            oct_prism_x(vertical_base_ring_depth + 0.2,
                        body[1] + 1, body[2] + 1, chamfer + 0.5);
    }
}

module vertical_base_pillars() {
    // Four open-sided rails leave the full centre free for plugs and cable bends.
    for (y = rear_mount_y, z = rear_mount_z)
        translate([body[0], y, z])
        rotate([0, 90, 0])
            cylinder(h = vertical_cover_depth, d = rear_boss_d);
}

module vertical_pad_recesses() {
    // Recesses are on the desk-facing plane after the enclosure is rotated upright.
    pad_y = rear_mount_y;
    pad_z = [-7, body[2] + 7];
    for (y = pad_y, z = pad_z)
        translate([body[0] + vertical_cover_depth - vertical_pad_recess, y, z])
        rotate([0, 90, 0])
            cylinder(h = vertical_pad_recess + 0.2, d = vertical_pad_d);
}

module rear_cover_vertical_global() {
    difference() {
        union() {
            vertical_base_outer_ring();
            vertical_base_pillars();
        }
        rear_cover_screw_holes(body[0], vertical_cover_depth);
        vertical_pad_recesses();
    }
}

module complete_core() {
    open_shell();
}

module front_core_global() {
    union() {
        intersection() {
            complete_core();
            translate([-1, -1, -1]) cube([split_x + 1, body[1] + 2, body[2] + 2]);
        }
        alignment_collar();
        seam_insert_bosses();
    }
}

module rear_core_global() {
    difference() {
        union() {
            intersection() {
                complete_core();
                translate([split_x, -1, -1]) cube([body[0] - split_x + 1, body[1] + 2, body[2] + 2]);
            }
            rear_interface_bosses();
        }
        rear_seam_holes();
    }
}

module fastener_proxies() {
    for (y = seam_fastener_y)
        color([0.65, 0.67, 0.70]) {
            translate([seam_fastener_x, y, -0.8]) cylinder(h = 1.8, d1 = 6.4, d2 = 3.4);
            translate([seam_fastener_x, y, 1.0]) cylinder(h = 7, d = 3);
        }
}

module vertical_equipment_proxies() {
    color([0.08, 0.45, 0.22, 0.72]) translate(board_origin) cube(board);
    color([0.75, 0.38, 0.08, 0.68]) translate(cisco_origin) cube(cisco_psu);
    color([0.18, 0.42, 0.80, 0.45]) translate(jf13k_origin) cube(jf13k);
}

if (part == "front-core")
    front_core_global();
else if (part == "rear-core")
    translate([-split_x, 0, 0]) rear_core_global();
else if (part == "rear-cover-horizontal")
    translate([-body[0], 0, 0]) rear_cover_horizontal_global();
else if (part == "rear-cover-vertical")
    translate([-body[0], vertical_base_overhang, vertical_base_overhang])
        rear_cover_vertical_global();
else {
    color([0.10, 0.11, 0.13]) front_core_global();
    color([0.16, 0.17, 0.19]) translate([exploded_gap, 0, 0]) rear_core_global();
    if (show_fasteners && exploded_gap == 0) fastener_proxies();
    if (show_equipment && exploded_gap == 0) vertical_equipment_proxies();
    if (rear_cover == "horizontal")
        color([0.30, 0.31, 0.34]) rear_cover_horizontal_global();
    else if (rear_cover == "vertical")
        color([0.30, 0.31, 0.34]) rear_cover_vertical_global();
}

echo("part", part);
echo("body mm", body);
echo("seam fasteners", "2x M3 countersunk, bottom access");
echo("seam fastener coordinates mm", [seam_fastener_x, seam_fastener_y]);
echo("front print bounds nominal mm", [split_x + collar_length, body[1], body[2]]);
echo("rear print bounds nominal mm", [body[0] - split_x, body[1], body[2]]);
echo("rear cover variants", ["horizontal", "vertical"]);
echo("common rear service cassette mm", rear_service_opening);
echo("vertical base depth/footprint mm", [vertical_cover_depth, vertical_base_footprint]);
echo("vertical base cable cavity mm", vertical_cover_depth - vertical_base_ring_depth);
echo("rear-cover fasteners", "4x M3; horizontal length provisional 10 mm; vertical length provisional 45 mm");
echo("board orientation", "vertical X-Z plane");
echo("board envelope/origin mm", [board, board_origin]);
echo("Cisco envelope/origin mm", [cisco_psu, cisco_origin]);
echo("JF13K envelope/origin mm", [jf13k, jf13k_origin]);
echo("PSU-to-board gap mm", board_origin[1] - (cisco_origin[1] + cisco_psu[1]));
echo("JF13K-to-side-wall gap mm", body[1] - (jf13k_origin[1] + jf13k[1]));
echo("release status", "core validation only; end panels and tray not yet integrated");

assert(split_x + collar_length <= 250, "Front core exceeds preliminary print envelope");
assert(body[0] - split_x <= 250, "Rear core exceeds preliminary print envelope");
assert(vertical_base_footprint[0] <= 250 && vertical_base_footprint[1] <= 250,
       "Vertical rear/base cover exceeds preliminary print envelope");
assert(board_origin[1] - (cisco_origin[1] + cisco_psu[1]) >= 2, "Cisco PSU collides with vertical board plane");
assert(jf13k_origin[1] + jf13k[1] <= body[1] - wall, "JF13K envelope collides with side wall");
assert(board_origin[2] + board[2] <= body[2] - wall, "Vertical board exceeds inner height");

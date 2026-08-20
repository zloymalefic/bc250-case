// BC-250 case core v0.1
// Single source for the two structural shell halves and their real retention.
// Units: millimetres. Global axes: X front-to-rear, Y left-to-right, Z bottom-to-top.

use <board-spine-v0.1.scad>
use <psu-universal-internal-v0.2.scad>
use <front-service-module-v0.1.scad>
use <rear-service-blanks-v0.1.scad>
use <power-button-nexgen-v0.1.scad>

$fn = 40;

part = "assembly"; // front-core | rear-core | board-spine-front | board-spine-rear | front-panel | front-button-mount | front-usb-cassette | rear-blank-board | rear-blank-psu | rear-cover-horizontal | rear-cover-vertical | assembly
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
rear_module_gap = 5;
rear_module_widths = [72, 48];
rear_module_height = 145;
horizontal_cover_depth = 6;
vertical_cover_depth = 44;
rear_module_y0 = (body[1] - rear_service_opening[0]) / 2;
rear_module_z0 = (body[2] - rear_module_height) / 2;
rear_blank_clearance = 0.35;
rear_blank_thickness = 3;
rear_blank_inner_x = body[0] + horizontal_cover_depth - rear_blank_thickness;
rear_seat_depth = 3;
rear_seat_overlap = 2;
rear_blank_widths = [for (w = rear_module_widths) w - 2 * rear_blank_clearance];
rear_blank_height = rear_module_height - 2 * rear_blank_clearance;
rear_snap_block = [9, 12, 12];
rear_snap_z = [rear_module_z0 + rear_blank_clearance + 8,
               rear_module_z0 + rear_blank_clearance + rear_blank_height - 8];

vertical_base_overhang = 15;
vertical_base_footprint = [
    body[1] + 2 * vertical_base_overhang,
    body[2] + 2 * vertical_base_overhang
];
vertical_base_ring_depth = 4;
vertical_base_wall = 8;
vertical_pad_d = 12;
vertical_pad_recess = 1.0;

side_intake_opening = [266, 119];
side_intake_origin = [32, 18];

// Confirmed Nyacom architecture: all major components are vertical.
board = [308.0, 1.6, 144.3];
board_vertical_offset = -4; // clears the lower spine bosses above the PSU bay
board_origin = [(body[0] - board[0]) / 2, 48,
                (body[2] - board[2]) / 2 + board_vertical_offset];
cisco_psu = [240, 40, 96];
cisco_origin = [70, 6, 30];
// JIUSHARK publishes 241 x 121 x 92 mm.  In this coordinate system the
// cooler's 92 mm installed height is Y and its 121 mm width is Z.  The supplied
// side/top photographs confirm that it is centred over the bare PCB closely
// enough to use the board envelope as the assembly datum.
jf13k = [241, 92, 121];
jf13k_origin = [
    board_origin[0] + (board[0] - jf13k[0]) / 2,
    board_origin[1] + board[1],
    board_origin[2] + (board[2] - jf13k[2]) / 2
];
jf13k_panel_gap = body[1] - wall - (jf13k_origin[1] + jf13k[1]);
jf13k_required_gap = 6; // hard no-contact allowance; nominal model leaves 9.4 mm

// Separate 316 x 8 x 152.3 mm board spine.  Its PCB pocket puts the board at
// the global board_origin above; eight M4 screws enter core-side insert bosses.
spine_frame = [316, 8, 152.3];
spine_origin = [board_origin[0] - 4, board_origin[1] - 6,
                board_origin[2] - 4];
spine_split_x = spine_frame[0] / 2;
spine_mount_x_local = [24, 92, spine_frame[0] - 92, spine_frame[0] - 24];
spine_mount_z_local = [4, spine_frame[2] - 4];
spine_boss_d = 12;
spine_boss_y0 = wall;
spine_boss_length = spine_origin[1] - spine_boss_y0;
m4_insert_pilot_d = 5.6; // provisional; select with a dedicated insert coupon
m4_insert_depth = 8;
spine_to_psu_gap = cisco_origin[2] -
    (spine_origin[2] + spine_mount_z_local[0] + spine_boss_d / 2);

// NexGen-compatible universal receiver is fused into the rear core.  These
// values mirror psu-universal-internal-v0.2.scad and are asserted here so the
// two sources cannot drift silently.
psu_receiver_origin = [293.15, 18.5, 30];
psu_receiver_outer = [24.85, 118, 54.34];
psu_receiver_rear_x = 318;
psu_bridge_overlap = 0.4;
psu_bridge_depth = 3;
psu_bridge_height = 4;

// Recessed 125 x 165 mm front service panel. Its outer face sits 2 mm behind
// the front frame and four hidden hooks enter accessible receiver pockets.
front_panel_size = [125, 165, 4];
front_panel_inset = [(body[1] - front_panel_size[0]) / 2,
                     (body[2] - front_panel_size[1]) / 2];
front_panel_front_x = 2;
front_panel_rear_x = front_panel_front_x + front_panel_size[2];
front_seat_depth = 2;
front_seat_overlap = 2.35;
front_snap_y = [front_panel_inset[0] + 18,
                front_panel_inset[0] + front_panel_size[0] - 18];
front_snap_z = [front_panel_inset[1] + 8,
                front_panel_inset[1] + front_panel_size[1] - 8];
front_snap_block = [10, 12, 12];
front_snap_slot = [8.6, 9, 4.4]; // 0.30 mm per-side hook clearance

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

module spine_core_bosses() {
    // All axes sit below/above the PSU envelope, leaving its central bay open.
    for (x_local = spine_mount_x_local, z_local = spine_mount_z_local) {
        x = spine_origin[0] + x_local;
        z = spine_origin[2] + z_local;
        difference() {
            union() {
                translate([x, spine_boss_y0, z])
                    rotate([-90, 0, 0])
                    cylinder(h = spine_boss_length, d = spine_boss_d);

                // A shallow web makes each long transverse boss printable and
                // prevents twisting under the cooler's transport load.
                translate([x - spine_boss_d / 2, spine_boss_y0, z - 2])
                    cube([spine_boss_d, spine_boss_length, 4]);
            }
            translate([x, spine_boss_y0 + spine_boss_length - m4_insert_depth, z])
                rotate([-90, 0, 0])
                    cylinder(h = m4_insert_depth + 0.2, d = m4_insert_pilot_d);
        }
    }
}

module board_spine_global(which = "assembly") {
    translate(spine_origin) {
        if (which == "front")
            front_spine();
        else if (which == "rear")
            rear_spine();
        else {
            front_spine();
            rear_spine();
        }
    }
}

module psu_receiver_bridges() {
    // Four short corner bridges fuse the receiver's rear seat to the two side
    // walls.  They stay out of the 110 x 46.34 mm adapter opening.
    left_length = psu_receiver_origin[1] - wall + psu_bridge_overlap;
    right_y = psu_receiver_origin[1] + psu_receiver_outer[1];
    right_length = body[1] - wall - right_y + psu_bridge_overlap;
    for (z = [psu_receiver_origin[2],
              psu_receiver_origin[2] + psu_receiver_outer[2] - psu_bridge_height]) {
        translate([psu_receiver_rear_x - psu_bridge_depth,
                   wall - psu_bridge_overlap, z])
            cube([psu_bridge_depth, left_length, psu_bridge_height]);
        translate([psu_receiver_rear_x - psu_bridge_depth,
                   right_y, z])
            cube([psu_bridge_depth, right_length, psu_bridge_height]);
    }
}

module front_panel_seat_and_receivers() {
    difference() {
        union() {
            // Visible front ring, with the panel face recessed by 2 mm.
            difference() {
                oct_prism_x(front_panel_rear_x, body[1], body[2], chamfer);
                translate([-0.1, front_panel_inset[0] - 0.35,
                           front_panel_inset[1] - 0.35])
                    cube([front_panel_rear_x + 0.2,
                          front_panel_size[0] + 0.7,
                          front_panel_size[1] + 0.7]);
            }

            // Rear shoulder carries the panel without glue or visible screws.
            difference() {
                translate([front_panel_rear_x, 0, 0])
                    oct_prism_x(front_seat_depth, body[1], body[2], chamfer);
                translate([front_panel_rear_x - 0.1,
                           front_panel_inset[0] + front_seat_overlap,
                           front_panel_inset[1] + front_seat_overlap])
                    cube([front_seat_depth + 0.2,
                          front_panel_size[0] - 2 * front_seat_overlap,
                          front_panel_size[1] - 2 * front_seat_overlap]);
            }

            for (y = front_snap_y, z = front_snap_z)
                translate([front_panel_rear_x, y - front_snap_block[1] / 2,
                           z - front_snap_block[2] / 2])
                    cube(front_snap_block);
        }

        // Slots open toward the service-panel aperture. A thin tool can depress
        // each hook after the opposite edge of the panel is lifted.
        for (y = front_snap_y, z = front_snap_z)
            translate([front_panel_rear_x - 0.1,
                       y - front_snap_slot[0] / 2,
                       z - front_snap_slot[2] / 2])
                cube([front_snap_slot[1] + 0.2,
                      front_snap_slot[0], front_snap_slot[2]]);
    }
}

module front_service_panel_global() {
    // local panel X/Y become global Y/Z; local thickness points toward -X so
    // its hooks extend into the chassis along +X.
    multmatrix([
        [0, 0, -1, front_panel_rear_x],
        [1, 0,  0, front_panel_inset[0]],
        [0, 1,  0, front_panel_inset[1]],
        [0, 0,  0, 1]
    ]) front_panel();
}

module front_button_mount_global() {
    multmatrix([
        [0, 0, -1, front_panel_rear_x],
        [1, 0,  0, front_panel_inset[0]],
        [0, 1,  0, front_panel_inset[1]],
        [0, 0,  0, 1]
    ]) translate([8.35, 116.35, 4 - 5.1]) mounting_plate();
}

module front_usb_cassette_global() {
    multmatrix([
        [0, 0, -1, front_panel_rear_x],
        [1, 0,  0, front_panel_inset[0]],
        [0, 1,  0, front_panel_inset[1]],
        [0, 0,  0, 1]
    ]) translate([88 + (28.6 - 27.93) / 2,
                   75 + (71.0 - 70.35) / 2, 4]) usb_cassette();
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

module rear_module_windows(length) {
    translate([body[0] - 0.1, rear_module_y0, rear_module_z0])
        cube([length + 0.2, rear_module_widths[0], rear_module_height]);
    translate([body[0] - 0.1,
               rear_module_y0 + rear_module_widths[0] + rear_module_gap,
               rear_module_z0])
        cube([length + 0.2, rear_module_widths[1], rear_module_height]);
}

function rear_window_y(index) =
    index == 0 ? rear_module_y0 :
    rear_module_y0 + rear_module_widths[0] + rear_module_gap;

module rear_service_seats_and_receivers() {
    difference() {
        union() {
            for (i = [0 : 1]) {
                y0 = rear_window_y(i);
                width = rear_module_widths[i];

                // A 2 mm shoulder behind each window supports the blank.
                difference() {
                    translate([body[0], y0, rear_module_z0])
                        cube([rear_seat_depth, width, rear_module_height]);
                    translate([body[0] - 0.1, y0 + rear_seat_overlap,
                               rear_module_z0 + rear_seat_overlap])
                        cube([rear_seat_depth + 0.2,
                              width - 2 * rear_seat_overlap,
                              rear_module_height - 2 * rear_seat_overlap]);
                }

                blank_y0 = y0 + rear_blank_clearance;
                snap_y = [blank_y0 + 12,
                          blank_y0 + rear_blank_widths[i] - 12];
                for (y = snap_y, z = rear_snap_z)
                    translate([rear_blank_inner_x - rear_snap_block[0],
                               y - rear_snap_block[1] / 2,
                               z - rear_snap_block[2] / 2])
                        cube(rear_snap_block);

                // Each receiver reaches the nearest horizontal seat rail;
                // none of the snap blocks is a disconnected island.
                for (y = snap_y) {
                    translate([rear_blank_inner_x - rear_snap_block[0],
                               y - rear_snap_block[1] / 2, rear_module_z0])
                        cube([rear_snap_block[0], rear_snap_block[1],
                              rear_snap_z[0] - rear_module_z0]);
                    translate([rear_blank_inner_x - rear_snap_block[0],
                               y - rear_snap_block[1] / 2, rear_snap_z[1]])
                        cube([rear_snap_block[0], rear_snap_block[1],
                              rear_module_z0 + rear_module_height - rear_snap_z[1]]);
                }
            }
        }

        for (i = [0 : 1]) {
            blank_y0 = rear_window_y(i) + rear_blank_clearance;
            snap_y = [blank_y0 + 12,
                      blank_y0 + rear_blank_widths[i] - 12];
            for (y = snap_y, z = rear_snap_z)
                translate([rear_blank_inner_x - 8.4, y - 4.3, z - 2.2])
                    cube([8.6, 8.6, 4.4]);
        }
    }
}

module rear_service_blank_global(index) {
    y0 = rear_window_y(index) + rear_blank_clearance;
    multmatrix([
        [0, 0, 1, rear_blank_inner_x],
        [1, 0, 0, y0],
        [0, 1, 0, rear_module_z0 + rear_blank_clearance],
        [0, 0, 0, 1]
    ]) service_blank(rear_blank_widths[index]);
}

module rear_cover_horizontal_global() {
    difference() {
        union() {
            difference() {
                translate([body[0], 0, 0])
                    oct_prism_x(horizontal_cover_depth, body[1], body[2], chamfer);
                rear_module_windows(horizontal_cover_depth);
            }
            rear_service_seats_and_receivers();
        }
        rear_cover_screw_holes(body[0], horizontal_cover_depth);
    }
}

module vertical_base_outer_solid() {
    hull() {
        translate([body[0], 0, 0])
            oct_prism_x(1, body[1], body[2], chamfer);
        translate([body[0] + vertical_cover_depth - 1,
                   -vertical_base_overhang, -vertical_base_overhang])
            oct_prism_x(1, vertical_base_footprint[0],
                        vertical_base_footprint[1], chamfer + vertical_base_overhang);
    }
}

module vertical_base_inner_cavity() {
    // The first 6 mm remain as the service-panel plane; the rest is hollow.
    hull() {
        translate([body[0] + horizontal_cover_depth, vertical_base_wall, vertical_base_wall])
            oct_prism_x(1, body[1] - 2 * vertical_base_wall,
                        body[2] - 2 * vertical_base_wall, chamfer - vertical_base_wall);
        translate([body[0] + vertical_cover_depth - 1,
                   -vertical_base_overhang + vertical_base_wall,
                   -vertical_base_overhang + vertical_base_wall])
            oct_prism_x(2, vertical_base_footprint[0] - 2 * vertical_base_wall,
                        vertical_base_footprint[1] - 2 * vertical_base_wall,
                        chamfer + vertical_base_overhang - vertical_base_wall);
    }
}

module vertical_base_cable_exits() {
    // Opposed side openings route plugs out without cutting the load-bearing corners.
    exit_x = body[0] + 18;
    exit_length = vertical_cover_depth - 20;
    exit_z = 55;
    exit_height = 85;
    translate([exit_x, -vertical_base_overhang - 1, exit_z])
        cube([exit_length, vertical_base_overhang + vertical_base_wall + 2, exit_height]);
    translate([exit_x, body[1] - vertical_base_wall - 1, exit_z])
        cube([exit_length, vertical_base_overhang + vertical_base_wall + 2, exit_height]);
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
            difference() {
                vertical_base_outer_solid();
                vertical_base_inner_cavity();
                rear_module_windows(horizontal_cover_depth + 0.2);
                vertical_base_cable_exits();
            }
            rear_service_seats_and_receivers();
        }
        rear_cover_screw_holes(body[0], vertical_cover_depth);
        vertical_pad_recesses();
    }
}

module complete_core() {
    union() {
        open_shell();
        spine_core_bosses();
        receiver();
        psu_receiver_bridges();
        front_panel_seat_and_receivers();
    }
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
else if (part == "board-spine-front")
    translate(-spine_origin) board_spine_global("front");
else if (part == "board-spine-rear")
    translate([-spine_origin[0] - spine_split_x, -spine_origin[1], -spine_origin[2]])
        board_spine_global("rear");
else if (part == "front-panel")
    front_panel();
else if (part == "front-button-mount")
    mounting_plate();
else if (part == "front-usb-cassette")
    usb_cassette();
else if (part == "rear-blank-board")
    service_blank(rear_blank_widths[0]);
else if (part == "rear-blank-psu")
    service_blank(rear_blank_widths[1]);
else if (part == "rear-cover-horizontal")
    translate([-body[0], 0, 0]) rear_cover_horizontal_global();
else if (part == "rear-cover-vertical")
    translate([-body[0], vertical_base_overhang, vertical_base_overhang])
        rear_cover_vertical_global();
else {
    color([0.10, 0.11, 0.13]) front_core_global();
    color([0.16, 0.17, 0.19]) translate([exploded_gap, 0, 0]) rear_core_global();
    color([0.24, 0.25, 0.29]) board_spine_global();
    color([0.76, 0.12, 0.09]) front_service_panel_global();
    color([0.10, 0.11, 0.13]) front_button_mount_global();
    color([0.14, 0.15, 0.17]) front_usb_cassette_global();
    if (show_fasteners && exploded_gap == 0) fastener_proxies();
    if (show_equipment && exploded_gap == 0) vertical_equipment_proxies();
    if (rear_cover == "horizontal")
        color([0.64, 0.12, 0.10]) rear_cover_horizontal_global();
    else if (rear_cover == "vertical")
        color([0.64, 0.12, 0.10]) rear_cover_vertical_global();
    if (rear_cover != "none") {
        color([0.22, 0.23, 0.26]) rear_service_blank_global(0);
        color([0.28, 0.29, 0.32]) rear_service_blank_global(1);
    }
}

echo("part", part);
echo("body mm", body);
echo("seam fasteners", "2x M3 countersunk, bottom access");
echo("seam fastener coordinates mm", [seam_fastener_x, seam_fastener_y]);
echo("front print bounds nominal mm", [split_x + collar_length, body[1], body[2]]);
echo("rear print bounds nominal mm", [body[0] - split_x, body[1], body[2]]);
echo("rear cover variants", ["horizontal", "vertical"]);
echo("common rear service cassette mm", rear_service_opening);
echo("rear module windows YxZ mm", [[rear_module_widths[0], rear_module_height],
                                    [rear_module_widths[1], rear_module_height]]);
echo("vertical base depth/footprint mm", [vertical_cover_depth, vertical_base_footprint]);
echo("vertical base cable cavity depth mm", vertical_cover_depth - horizontal_cover_depth);
echo("rear-cover fasteners", "4x M3; horizontal length provisional 10 mm; vertical length provisional 45 mm");
echo("board orientation", "vertical X-Z plane");
echo("board envelope/origin mm", [board, board_origin]);
echo("Cisco envelope/origin mm", [cisco_psu, cisco_origin]);
echo("JF13K envelope/origin mm", [jf13k, jf13k_origin]);
echo("PSU-to-board gap mm", board_origin[1] - (cisco_origin[1] + cisco_psu[1]));
echo("JF13K-to-inner-side-wall gap mm", jf13k_panel_gap);
echo("board-spine origin/frame mm", [spine_origin, spine_frame]);
echo("board-spine M4 global axes X/Z mm",
     [[for (x = spine_mount_x_local) spine_origin[0] + x],
      [for (z = spine_mount_z_local) spine_origin[2] + z]]);
echo("board-spine fasteners", "8x M4 into core-side heat-set inserts; dimensions provisional");
echo("lower board-spine boss to PSU gap mm", spine_to_psu_gap);
echo("integrated PSU receiver bounds mm",
     [psu_receiver_origin,
      psu_receiver_origin + psu_receiver_outer]);
echo("PSU receiver rear setback mm", body[0] - psu_receiver_rear_x);
echo("PSU interface", "NexGen 110 x 46.34 mm server/FlexATX/LOP family; receiver fused to rear core");
echo("front service panel/seat mm", [front_panel_size, front_panel_inset, front_panel_front_x]);
echo("front service panel retention", "4 hidden snap hooks; 0.30 mm nominal receiver clearance");
echo("rear vertical service blanks YxZxX mm",
     [[rear_blank_widths[0], rear_blank_height, rear_blank_thickness],
      [rear_blank_widths[1], rear_blank_height, rear_blank_thickness]]);
echo("rear blank retention", "4 hidden snap hooks each; common to horizontal and vertical rear covers");
echo("release status", "core validation only; peripheral bays and final connector cuts not yet integrated");

assert(split_x + collar_length <= 250, "Front core exceeds preliminary print envelope");
assert(body[0] - split_x <= 250, "Rear core exceeds preliminary print envelope");
assert(vertical_base_footprint[0] <= 250 && vertical_base_footprint[1] <= 250,
       "Vertical rear/base cover exceeds preliminary print envelope");
assert(board_origin[1] - (cisco_origin[1] + cisco_psu[1]) >= 2, "Cisco PSU collides with vertical board plane");
assert(jf13k_origin[1] + jf13k[1] <= body[1] - wall, "JF13K envelope collides with side wall");
assert(jf13k_panel_gap >= jf13k_required_gap, "JF13K has less than 6 mm hard clearance to intake panel");
assert(board_origin[2] + board[2] <= body[2] - wall, "Vertical board exceeds inner height");
assert(spine_boss_length > m4_insert_depth, "Board-spine boss is too short for insert");
assert(spine_origin[0] >= wall && spine_origin[0] + spine_frame[0] <= body[0] - wall,
       "Board spine exceeds inner chassis length");
assert(spine_to_psu_gap >= 2, "Lower board-spine bosses collide with PSU bay");
assert(abs(psu_receiver_origin[0] + psu_receiver_outer[0] - psu_receiver_rear_x) < 0.01,
       "PSU receiver constants drifted from the internal receiver source");
assert(psu_receiver_rear_x < body[0] - wall,
       "PSU receiver reaches the rear exterior plane");
assert(front_panel_size[0] + 2 * front_panel_inset[0] == body[1] &&
       front_panel_size[1] + 2 * front_panel_inset[1] == body[2],
       "Front service panel is not centred on the case end");
assert(rear_module_widths[0] + rear_module_widths[1] + rear_module_gap ==
       rear_service_opening[0],
       "Rear vertical module widths do not fill the common service opening");

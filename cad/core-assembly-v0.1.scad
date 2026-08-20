// BC-250 case core v0.1
// Single source for the two structural shell halves and their real retention.
// Units: millimetres. Global axes: X front-to-rear, Y left-to-right, Z bottom-to-top.

use <board-spine-v0.1.scad>
use <psu-universal-internal-v0.2.scad>
use <front-service-module-v0.1.scad>
use <power-button-nexgen-v0.1.scad>
use <peripheral-bay-v0.1.scad>
use <esp32-service-cover-v0.1.scad>
include <lib/magnet-interface.scad>

$fn = 40;

part = "assembly"; // front-core | rear-core | board-spine-front | board-spine-rear | front-panel | front-button-mount | front-usb-cassette | ssd-cassette | esp32-cassette | esp32-cover | rear-cover-horizontal | rear-cover-vertical | assembly
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

// Common monolithic rear-cover interface. Both variants use the same four axes.
rear_mount_y = [30, body[1] - 30];
rear_mount_z = [5, body[2] - 5];
rear_boss_d = 14;
rear_boss_depth = 10;
rear_cover_clearance_d = 3.4;
horizontal_cover_depth = 6;
vertical_cover_depth = 44;

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
side_intake_origin = [32, 34];
side_intake_bridge = 10;
side_intake_segment_width =
    (side_intake_opening[0] - side_intake_bridge) / 2;
intake_panel_width = 130;
intake_panel_gap = 10;
intake_panel_x = [30, 30 + intake_panel_width + intake_panel_gap];
intake_panel_z = 28;
intake_panel_height = 131;
intake_grille_center_x = [intake_panel_x[0] + 75,
                           intake_panel_x[1] + 55];
intake_magnet_x_local = [24, intake_panel_width - 24];
intake_magnet_z_local = [4, intake_panel_height - 4];
intake_guide_x_local = 22;
intake_guide_length = intake_panel_width - 2 * intake_guide_x_local;
intake_guide_height = 4;
intake_guide_projection = 1.2;

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

// Full-section Nyacom-derived sculpted end cap, retained by four M3 screws.
front_panel_size = [155, 195, 12];
front_panel_inset = [(body[1] - front_panel_size[0]) / 2,
                     (body[2] - front_panel_size[1]) / 2];
front_panel_front_x = -12;
front_panel_rear_x = front_panel_front_x + front_panel_size[2];
front_seat_depth = 2;
front_seat_overlap = 2.35;
front_screw_points = [
    [front_panel_inset[0] + 18, front_panel_inset[1] + 18],
    [front_panel_inset[0] + front_panel_size[0] - 18,
     front_panel_inset[1] + 18],
    [front_panel_inset[0] + 18,
     front_panel_inset[1] + front_panel_size[1] - 18],
    [front_panel_inset[0] + front_panel_size[0] - 18,
     front_panel_inset[1] + front_panel_size[1] - 18]
];
front_insert_boss_d = 16;
front_insert_boss_depth = 8;

// Front-load 2.5-inch bay: the cassette plane is Y-Z and its thickness is X.
// It occupies the free pocket between the front service panel and JF13K.
ssd_tray_size = [110, 80, 2.4]; // local length, width, plate thickness
ssd_device = [100.5, 69.9, 15];
ssd_origin = [22, 60, 42.5];
ssd_receiver_x0 = 7.0; // 1 mm overlap with the front-panel shoulder
ssd_receiver_x1 = ssd_origin[0] + ssd_tray_size[2];
ssd_rail_wall = 3;
ssd_rail_lip = 1.4;
ssd_retention_global = [ssd_origin[0], ssd_origin[1] + 4,
                        ssd_origin[2] + ssd_tray_size[0] / 2];
ssd_insert_boss_length = 9;

// Side-load ESP32 relay cassette below JF13K. The fan cover hides its service
// opening; antenna side faces the plastic intake side rather than the PSU.
esp_tray_size = [68, 68, 2.4];
esp_device = [60, 60, 22];
esp_origin = [180, 70, 5];
esp_receiver_y0 = 68;
esp_receiver_y1 = body[1] - wall;
esp_rail_wall = 3;
esp_rail_height = 4.4;
esp_service_opening = [74, 28]; // X width, Z height
esp_service_origin = [esp_origin[0] - 3, 4];
esp_cover_size = [98, 40, 3];
esp_cover_origin = [esp_service_origin[0] - 12, 0];
esp_cover_magnet_local = [[5, 20], [esp_cover_size[0] - 5, 20],
                          [5, 32], [esp_cover_size[0] - 5, 32]];
esp_top_gap = jf13k_origin[2] -
    (esp_origin[2] + esp_tray_size[2] + esp_device[2]);

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

        // Two fan windows leave a load-bearing rib at the chassis split.
        for (x = [side_intake_origin[0],
                  side_intake_origin[0] + side_intake_segment_width +
                  side_intake_bridge])
            translate([x, body[1] + 1, side_intake_origin[1]])
                rotate([90, 0, 0])
                    linear_extrude(height = wall + 2)
                        polygon([
                            [8, 0], [side_intake_segment_width - 8, 0],
                            [side_intake_segment_width, 8],
                            [side_intake_segment_width,
                             side_intake_opening[1] - 8],
                            [side_intake_segment_width - 8,
                             side_intake_opening[1]],
                            [8, side_intake_opening[1]],
                            [0, side_intake_opening[1] - 8], [0, 8]
                        ]);

        // Hidden extension below the fan opening lets the ESP32 cassette slide
        // out after the removable intake cover is released.
        translate([esp_service_origin[0], body[1] - chamfer - 1,
                   esp_service_origin[1]])
            cube([esp_service_opening[0], chamfer + 2,
                  esp_service_opening[1]]);

        // Remove exactly the 3 mm profiled skin replaced by the flush cover.
        // This prevents coincident/overlapping plastic around the service bay.
        esp32_cover_envelope_global();

        // Blind pockets open from the recessed seat into the remaining shell.
        // All four axes lie on solid frame outside the 74 mm service opening.
        for (p = esp_cover_magnet_local)
            translate([esp_cover_origin[0] + p[0], body[1] - 2.9,
                       esp_cover_origin[1] + p[1]])
                rotate([90, 0, 0])
                    cylinder(h = magnet_pocket_depth + 0.2,
                             d = magnet_pocket_d);
    }
}

module intake_magnets_and_guides_global(panel_x) {
    // Same local axes as a cover. Four magnet bosses resist pull-off; two long
    // tongue rails take shear and brace the broad opening along X.
    multmatrix([
        [1, 0, 0, panel_x],
        [0, 0, 1, body[1] - wall],
        [0, 1, 0, intake_panel_z],
        [0, 0, 0, 1]
    ])
    union() {
        for (x = intake_magnet_x_local, z = intake_magnet_z_local)
            translate([x, z, 0]) magnet_boss_negative();

        for (z = [2, intake_panel_height - 2 - intake_guide_height])
            translate([intake_guide_x_local, z, -intake_guide_projection])
                cube([intake_guide_length, intake_guide_height,
                      intake_guide_projection + 0.4]);
    }
}

module intake_magnets_and_guides() {
    for (x = intake_panel_x) intake_magnets_and_guides_global(x);
}

module esp32_cover_envelope_global() {
    multmatrix([
        [1, 0, 0, esp_cover_origin[0]],
        [0, 0, 1, body[1] - wall],
        [0, 1, 0, esp_cover_origin[1]],
        [0, 0, 0, 1]
    ]) flush_chamfered_solid();
}

module esp32_service_cover_global() {
    multmatrix([
        [1, 0, 0, esp_cover_origin[0]],
        [0, 0, 1, body[1] - wall],
        [0, 1, 0, esp_cover_origin[1]],
        [0, 0, 0, 1]
    ]) esp32_service_cover();
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
    union() {
        // Internal shoulder supports the full-size external end cap.
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

        // Four fused bosses receive M3 heat-set inserts from the front. Their
        // axes match the countersunk holes in the removable panel.
        for (p = front_screw_points)
            difference() {
                union() {
                    translate([front_panel_rear_x, p[0], p[1]])
                        rotate([0, 90, 0])
                            cylinder(h = front_insert_boss_depth,
                                     d = front_insert_boss_d);
                    // Short web reaches the nearest side wall so the insert
                    // boss is structural rather than an isolated island.
                    translate([front_panel_rear_x,
                               p[0] < body[1] / 2 ? 0 : p[0], p[1] - 4])
                        cube([front_insert_boss_depth,
                              p[0] < body[1] / 2 ? p[0] : body[1] - p[0], 8]);
                }
                translate([front_panel_rear_x - 0.1, p[0], p[1]])
                    rotate([0, 90, 0])
                        cylinder(h = front_insert_boss_depth + 0.2,
                                 d = m3_insert_pilot_d);
            }
    }
}

module front_service_panel_global() {
    // Local panel X/Y become global Y/Z; thickness points toward the exterior.
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
    // Plate is entirely behind the cap's internal Z=0 face.
    ]) translate([15.35, 148.35, -5.1]) mounting_plate();
}

module front_button_visible_global() {
    // Complete visible button stack, not merely the hidden mounting plate.
    multmatrix([
        [0, 0, -1, front_panel_rear_x],
        [1, 0,  0, front_panel_inset[0]],
        [0, 1,  0, front_panel_inset[1]],
        [0, 0,  0, 1]
    ]) {
        button_center = [15 + 45.2 / 2, 148 + 32.3 / 2];
        // Existing NexGen light pipe starts at the internal face. A separate
        // extension crosses the additional cap thickness without moving the
        // mounting plate outside.
        translate([button_center[0], button_center[1], 0]) light_pipe();
        translate([button_center[0], button_center[1], 7.8])
            cylinder(h = 5.2, d = 16);
        translate([button_center[0], button_center[1], 13.8])
            nexgen_steam_logo_cap();
    }
}

module front_usb_cassette_global() {
    multmatrix([
        [0, 0, -1, front_panel_rear_x],
        [1, 0,  0, front_panel_inset[0]],
        [0, 1,  0, front_panel_inset[1]],
        [0, 0,  0, 1]
    ]) translate([111 + (28.6 - 27.93) / 2,
                   87 + (71.0 - 70.35) / 2, 12]) usb_cassette();
}

module ssd_cassette_global() {
    multmatrix([
        [0, 0, 1, ssd_origin[0]],
        [0, 1, 0, ssd_origin[1]],
        [1, 0, 0, ssd_origin[2]],
        [0, 0, 0, 1]
    ]) ssd_cassette();
}

module ssd_receiver_rails() {
    rail_length = ssd_receiver_x1 - ssd_receiver_x0;
    // Side guide walls connect directly to the front structural seat.
    for (y = [ssd_origin[1] - ssd_rail_wall,
              ssd_origin[1] + ssd_tray_size[1]]) {
        translate([ssd_receiver_x0, y, ssd_origin[2]])
            cube([rail_length, ssd_rail_wall, ssd_tray_size[0]]);
    }

    // Shallow lips retain the tray edges while leaving the drive open to air.
    translate([ssd_receiver_x0, ssd_origin[1] - ssd_rail_wall,
               ssd_origin[2]])
        cube([rail_length, ssd_rail_wall + ssd_rail_lip, 4]);
    translate([ssd_receiver_x0,
               ssd_origin[1] + ssd_tray_size[1] - ssd_rail_lip,
               ssd_origin[2]])
        cube([rail_length, ssd_rail_wall + ssd_rail_lip, 4]);

    // Rear stop prevents the cassette reaching the JF13K keepout.
    translate([ssd_receiver_x1, ssd_origin[1] - ssd_rail_wall,
               ssd_origin[2]])
        cube([2.4, ssd_tray_size[1] + 2 * ssd_rail_wall, 5]);

    // One M3 insert boss is reached after removing the bolted front panel.
    translate([ssd_receiver_x1, ssd_retention_global[1],
               ssd_retention_global[2]])
        rotate([0, 90, 0])
            difference() {
                cylinder(h = ssd_insert_boss_length, d = 9);
                translate([0, 0, -0.1])
                    cylinder(h = 6.2, d = m3_insert_pilot_d);
            }
    translate([ssd_receiver_x1 - 0.5, ssd_origin[1] - 0.5,
               ssd_retention_global[2] - 2])
        cube([ssd_insert_boss_length + 0.5,
              2.0, 4]);
}

module esp32_cassette_global() {
    translate(esp_origin) esp32_cassette();
}

module esp32_receiver_rails() {
    rail_length = esp_receiver_y1 - esp_receiver_y0;
    // Two X-edge guides run to the intake-side service opening.
    for (x = [esp_origin[0] - esp_rail_wall,
              esp_origin[0] + esp_tray_size[0]])
        translate([x, esp_receiver_y0, wall])
            cube([esp_rail_wall, rail_length, esp_rail_height]);

    // Inward lips retain the 2.4 mm cassette plate without covering the PCB.
    translate([esp_origin[0] - esp_rail_wall, esp_receiver_y0,
               esp_origin[2] + esp_tray_size[2]])
        cube([esp_rail_wall + 1.2, rail_length, 1.0]);
    translate([esp_origin[0] + esp_tray_size[0] - 1.2, esp_receiver_y0,
               esp_origin[2] + esp_tray_size[2]])
        cube([esp_rail_wall + 1.2, rail_length, 1.0]);

    // Inner stop fixes insertion depth.
    translate([esp_origin[0] - esp_rail_wall, esp_receiver_y0, wall])
        cube([esp_tray_size[0] + 2 * esp_rail_wall, 3, esp_rail_height + 1]);

    // Small vertical nub engages the cassette's edge notch at full insertion.
    translate([esp_origin[0] + esp_tray_size[0],
               esp_origin[1] + esp_tray_size[1] - 4, esp_origin[2] - 0.1])
        cylinder(h = esp_tray_size[2] + 0.2, d = 2.2);
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

module rear_cover_horizontal_global() {
    difference() {
        translate([body[0], 0, 0])
            oct_prism_x(horizontal_cover_depth, body[1], body[2], chamfer);
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
                vertical_base_cable_exits();
            }
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
        intake_magnets_and_guides();
        ssd_receiver_rails();
        esp32_receiver_rails();
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
else if (part == "ssd-cassette")
    ssd_cassette();
else if (part == "esp32-cassette")
    esp32_cassette();
else if (part == "esp32-cover")
    esp32_service_cover();
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
    front_button_visible_global();
    color([0.14, 0.15, 0.17]) front_usb_cassette_global();
    color([0.38, 0.40, 0.44]) ssd_cassette_global();
    color([0.18, 0.36, 0.62]) esp32_cassette_global();
    color([0.22, 0.23, 0.26]) esp32_service_cover_global();
    if (show_fasteners && exploded_gap == 0) fastener_proxies();
    if (show_equipment && exploded_gap == 0) vertical_equipment_proxies();
    if (rear_cover == "horizontal")
        color([0.64, 0.12, 0.10]) rear_cover_horizontal_global();
    else if (rear_cover == "vertical")
        color([0.64, 0.12, 0.10]) rear_cover_vertical_global();
}

echo("part", part);
echo("body mm", body);
echo("seam fasteners", "2x M3 countersunk, bottom access");
echo("seam fastener coordinates mm", [seam_fastener_x, seam_fastener_y]);
echo("front print bounds nominal mm", [split_x + collar_length, body[1], body[2]]);
echo("rear print bounds nominal mm", [body[0] - split_x, body[1], body[2]]);
echo("rear cover variants", ["horizontal", "vertical"]);
echo("rear panel construction", "monolithic; final I/O and PSU cuts pending");
echo("vertical base depth/footprint mm", [vertical_cover_depth, vertical_base_footprint]);
echo("vertical base cable cavity depth mm", vertical_cover_depth - horizontal_cover_depth);
echo("rear-cover fasteners", "4x M3; horizontal length provisional 10 mm; vertical length provisional 45 mm");
echo("board orientation", "vertical X-Z plane");
echo("board envelope/origin mm", [board, board_origin]);
echo("Cisco envelope/origin mm", [cisco_psu, cisco_origin]);
echo("JF13K envelope/origin mm", [jf13k, jf13k_origin]);
echo("PSU-to-board gap mm", board_origin[1] - (cisco_origin[1] + cisco_psu[1]));
echo("JF13K-to-inner-side-wall gap mm", jf13k_panel_gap);
echo("split intake windows / structural rib mm",
     [[side_intake_segment_width, side_intake_opening[1]],
      side_intake_bridge]);
echo("intake grille centre X mm", intake_grille_center_x);
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
echo("front service panel retention", "4x front-access M3 countersunk screws into heat-set inserts");
echo("2.5-inch bay origin/receiver X bounds mm",
     [ssd_origin, [ssd_receiver_x0, ssd_receiver_x1 + ssd_insert_boss_length]]);
echo("2.5-inch supported device mm", ssd_device);
echo("2.5-inch retention", "4x device M3 plus 1x front-access cassette M3");
echo("ESP32 bay origin/service opening mm",
     [esp_origin, esp_service_origin, esp_service_opening]);
echo("ESP32 provisional device/top gap mm", [esp_device, esp_top_gap]);
echo("ESP32 retention", "adjustable post slots plus side-rail printed detent");
echo("release status", "core validation only; final ESP32 posts and connector cuts not yet frozen");

assert(split_x + collar_length <= 250, "Front core exceeds preliminary print envelope");
assert(body[0] - split_x <= 250, "Rear core exceeds preliminary print envelope");
assert(vertical_base_footprint[0] <= 250 && vertical_base_footprint[1] <= 250,
       "Vertical rear/base cover exceeds preliminary print envelope");
assert(board_origin[1] - (cisco_origin[1] + cisco_psu[1]) >= 2, "Cisco PSU collides with vertical board plane");
assert(jf13k_origin[1] + jf13k[1] <= body[1] - wall, "JF13K envelope collides with side wall");
assert(jf13k_panel_gap >= jf13k_required_gap, "JF13K has less than 6 mm hard clearance to intake panel");
assert(intake_grille_center_x == [105, 225],
       "Intake grille centres drifted from the JF13K fan centres");
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
assert(ssd_origin[0] + ssd_tray_size[2] + ssd_device[2] < jf13k_origin[0],
       "2.5-inch drive reaches the JF13K envelope");
assert(ssd_origin[1] + ssd_tray_size[1] <= body[1] - wall,
       "2.5-inch cassette exceeds the inner side wall");
assert(esp_top_gap >= 3, "ESP32 envelope reaches the JF13K keepout");
assert(esp_origin[0] >= jf13k_origin[0] &&
       esp_origin[0] + esp_tray_size[0] <= jf13k_origin[0] + jf13k[0],
       "ESP32 bay is not contained below the JF13K footprint");

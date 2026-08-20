// Split BC-250 perimeter tray with open backplate channel and cooler-load anchors.
// Board mounting-hole coordinates are intentionally not assumed.

$fn = 40;

part = "assembly"; // front | rear | assembly

tray = [318, 146.2, 4];
board_proxy = [311.7, 144, 1.6];
split_x = 159;
frame_width = 11;
joint_tongue = 8;
joint_clearance = 0.30;
board_plane_z = 16;
backplate_channel = board_plane_z - tray[2];

slot_length = 16;
slot_d = 4.2;
anchor_d = 16;
anchor_h = 7;

module elongated_hole(length, diameter, height) {
    hull() {
        translate([-length / 2 + diameter / 2, 0, 0]) cylinder(h = height, d = diameter);
        translate([ length / 2 - diameter / 2, 0, 0]) cylinder(h = height, d = diameter);
    }
}

module perimeter_frame() {
    difference() {
        cube(tray);
        translate([frame_width, frame_width, -0.1])
            cube([tray[0] - 2 * frame_width, tray[1] - 2 * frame_width, tray[2] + 0.2]);

        // Adjustable chassis fasteners; exact body inserts remain provisional.
        for (x = [24, 78, tray[0] - 78, tray[0] - 24],
             y = [frame_width / 2, tray[1] - frame_width / 2])
            translate([x, y, -0.1]) elongated_hole(slot_length, slot_d, tray[2] + 0.2);
    }
}

module cooler_anchor(x, y) {
    // M4 anchor for a future adjustable radiator transport/support tower.
    difference() {
        translate([x, y, tray[2]]) cylinder(h = anchor_h, d = anchor_d);
        translate([x, y, tray[2] - 0.1]) cylinder(h = anchor_h + 0.2, d = 4.5);
    }
}

module board_edge_support(x, y) {
    // Low pad only. Final clamp/isolator is generated after board measurement.
    translate([x, y, tray[2]])
    difference() {
        cylinder(h = board_plane_z - tray[2], d = 10);
        translate([0, 0, -0.1]) cylinder(h = board_plane_z - tray[2] + 0.2, d = 3.4);
    }
}

module complete_tray() {
    union() {
        perimeter_frame();

        // Four generic edge-support stations, outside the open backplate area.
        for (x = [18, tray[0] - 18], y = [7, tray[1] - 7])
            board_edge_support(x, y);

        // Independent JF13K load-path anchors on the strong perimeter rails.
        for (x = [106, 212], y = [8, tray[1] - 8])
            cooler_anchor(x, y);
    }
}

module tray_slice(x0, length) {
    intersection() {
        complete_tray();
        translate([x0, -1, -1]) cube([length, tray[1] + 2, board_plane_z + 2]);
    }
}

module front_tray() {
    union() {
        tray_slice(0, split_x);
        // Two internal tongues keep the tray plane aligned without blocking airflow.
        for (y = [3, tray[1] - frame_width + 3])
            translate([split_x - 0.2, y, 0.6]) cube([joint_tongue, frame_width - 6, tray[2] - 1.2]);
    }
}

module rear_tray() {
    difference() {
        tray_slice(split_x, tray[0] - split_x);
        for (y = [3 - joint_clearance, tray[1] - frame_width + 3 - joint_clearance])
            translate([split_x - 0.3, y, 0.4])
                cube([joint_tongue + joint_clearance + 0.5, frame_width - 6 + 2 * joint_clearance, tray[2] - 0.8]);
    }
}

module board_envelope() {
    color([0.10, 0.55, 0.28, 0.30])
        translate([(tray[0] - board_proxy[0]) / 2, (tray[1] - board_proxy[1]) / 2, board_plane_z])
            cube(board_proxy);
}

if (part == "front") front_tray();
else if (part == "rear") translate([-split_x, 0, 0]) rear_tray();
else {
    color([0.18, 0.19, 0.21]) front_tray();
    color([0.23, 0.24, 0.27]) rear_tray();
    board_envelope();
}

echo("part", part);
echo("tray_mm", tray);
echo("board_proxy_mm", board_proxy);
echo("board_side_clearance_each_mm", (tray[1] - board_proxy[1]) / 2);
echo("backplate_channel_mm", backplate_channel);
echo("front_print_length_mm", split_x + joint_tongue);
echo("rear_print_length_mm", tray[0] - split_x);
assert(backplate_channel >= 12, "Backplate channel is below the 12 mm minimum");
assert(split_x + joint_tongue <= 250 && tray[0] - split_x <= 250, "Tray section exceeds 250 mm print-bed limit");

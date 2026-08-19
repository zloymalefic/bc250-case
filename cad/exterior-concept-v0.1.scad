// BC-250 + JF13K exterior concept v0.1
// Visual architecture model, not yet a printable production shell.
include <lib/common.scad>

$fn = 32;

orientation = "horizontal"; // "horizontal" or "vertical"
show_top_panel = true;
show_front_insert = true;
show_rear_panel = true;

body_size = chassis;
body_radius = 10;
body_wall = 4;

top_panel_origin = [31, 13, body_size[2] - 5];
top_panel_size = [268, 144, 5];
top_panel_radius = 7;

front_bezel_x = 6;
front_margin = 9;
front_insert_origin = [-0.2, 48, 60];
front_insert_size = [6.4, 74, 50];

module rounded_cuboid(size, radius) {
    translate([radius, radius, radius])
        minkowski() {
            cube(size - [2 * radius, 2 * radius, 2 * radius]);
            sphere(r = radius);
        }
}

module vent_slot_x(length = 22, width = 4, depth = 8) {
    hull() {
        translate([-length / 2 + width / 2, 0, 0]) cylinder(h = depth, d = width);
        translate([ length / 2 - width / 2, 0, 0]) cylinder(h = depth, d = width);
    }
}

module main_body() {
    color([0.08, 0.09, 0.11])
    difference() {
        rounded_cuboid(body_size, body_radius);
        translate([body_wall, body_wall, body_wall])
            rounded_cuboid(body_size - [2 * body_wall, 2 * body_wall, 2 * body_wall], body_radius - body_wall);

        // Removable JF13K intake panel opening.
        translate(top_panel_origin - [1, 1, 2])
            rounded_box(top_panel_size + [2, 2, 4], top_panel_radius + 1);

        // Front service-panel opening.
        translate([-1, front_insert_origin[1], front_insert_origin[2]])
            cube(front_insert_size + [2, 0, 0]);

        // Long exhaust banks low on both side walls.
        for (x = [72 : 20 : 272], z = [24, 36]) {
            translate([x, -1, z]) rotate([-90, 0, 0]) vent_slot_x(13, 3.4, body_wall + 2);
            translate([x, body_size[1] - body_wall - 1, z]) rotate([-90, 0, 0]) vent_slot_x(13, 3.4, body_wall + 2);
        }

        // Rear service opening remains intentionally generic pending I/O measurements.
        translate([body_size[0] - body_wall - 1, 16, 16])
            cube([body_wall + 2, body_size[1] - 32, 104]);
    }
}

module top_mesh_panel() {
    color([0.78, 0.80, 0.82])
    difference() {
        translate(top_panel_origin) rounded_box(top_panel_size, top_panel_radius);

        // Two restrained circular fields aligned with the JF13K fans.
        for (cx = [105, 226], x = [-50 : 10 : 50], y = [-50 : 9 : 50])
            if (x * x + y * y < 52 * 52)
                translate([cx + x + ((round(y / 9) % 2) * 5), 85 + y, top_panel_origin[2] - 1])
                    cylinder(h = top_panel_size[2] + 2, d = 6.4, $fn = 6);
    }
}

module front_insert() {
    color([0.16, 0.17, 0.19])
    difference() {
        translate(front_insert_origin) cube(front_insert_size);

        // 16 mm power button.
        translate([-1, 72, 85]) rotate([0, 90, 0])
            cylinder(h = front_insert_size[0] + 2, d = 16.4);

        // Replaceable hub apertures: USB-A and USB-C, deliberately oversized.
        translate([-1, 92, 91]) cube([front_insert_size[0] + 2, 15, 8]);
        translate([-1, 94.5, 74]) cube([front_insert_size[0] + 2, 10, 4.6]);
    }

    // Recessed accent channel; visual indication only.
    color([0.10, 0.42, 0.90])
        translate([-0.8, 66, 65]) cube([0.9, 44, 2.2]);
}

module rear_panel() {
    color([0.12, 0.13, 0.15])
    difference() {
        translate([body_size[0] - 5.8, 13, 13])
            cube([6, body_size[1] - 26, 110]);

        // Provisional BC-250 I/O and PSU exhaust zones; not manufacturing cuts.
        translate([body_size[0] - 7, 24, 69]) cube([9, 122, 42]);
        translate([body_size[0] - 7, 30, 25]) cube([9, 96, 31]);
    }
}

module horizontal_feet_visual() {
    color([0.05, 0.05, 0.06]) {
        translate([28, 18, -7]) rounded_box([142, 22, 7], 4);
        translate([160, body_size[1] - 40, -7]) rounded_box([142, 22, 7], 4);
    }
}

module vertical_stand_visual() {
    color([0.05, 0.05, 0.06])
        translate([-14, -30, -30]) rounded_box([28, body_size[1] + 60, 230], 7);
}

module case_assembly() {
    main_body();
    if (show_top_panel) top_mesh_panel();
    if (show_front_insert) front_insert();
    if (show_rear_panel) rear_panel();
    if (orientation == "horizontal") horizontal_feet_visual();
    else vertical_stand_visual();
}

if (orientation == "horizontal")
    case_assembly();
else
    rotate([0, -90, 0]) case_assembly();

echo("concept", "exterior v0.1");
echo("body_mm", body_size);
echo("orientation", orientation);
echo("status", "visual architecture; openings provisional");

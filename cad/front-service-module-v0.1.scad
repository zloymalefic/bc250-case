// Nyacom-style front service panel with replaceable NexGen button and USB hub cassette.
// All dimensions in millimetres. USB PCB envelope remains provisional.
include <lib/snap-interface.scad>

$fn = 48;

part = "assembly"; // panel | usb-cassette | assembly

panel = [125, 165, 4];
panel_chamfer = 12;
button_opening = [45.2, 32.3];
button_origin = [8, 116];
usb_opening = [58.6, 42.6];
usb_origin = [59, 111];

usb_face = [58, 42, 3];
usb_board_provisional = [52, 30, 12];
usb_a_cut = [15.0, 7.8];
usb_c_cut = [10.2, 4.8];

module chamfered_panel_2d(width, height, cut) {
    polygon([
        [cut, 0], [width - cut, 0], [width, cut],
        [width, height - cut], [width - cut, height],
        [cut, height], [0, height - cut], [0, cut]
    ]);
}

module capsule(length, width, depth) {
    hull() {
        translate([-length / 2 + width / 2, 0, 0]) cylinder(h = depth, d = width);
        translate([ length / 2 - width / 2, 0, 0]) cylinder(h = depth, d = width);
    }
}

module front_panel() {
    color([0.94, 0.72, 0.05])
    difference() {
        linear_extrude(height = panel[2])
            chamfered_panel_2d(panel[0], panel[1], panel_chamfer);

        // NexGen button mounting plate opening.
        translate([button_origin[0], button_origin[1], -0.1])
            cube([button_opening[0], button_opening[1], panel[2] + 0.2]);

        // Replaceable USB cassette opening.
        translate([usb_origin[0], usb_origin[1], -0.1])
            cube([usb_opening[0], usb_opening[1], panel[2] + 0.2]);

        // Nyacom-like lower industrial ventilation slots.
        for (y = [25 : 13 : 90])
            translate([panel[0] / 2, y, -0.1]) rotate([0, 0, -12])
                capsule(72, 5, panel[2] + 0.2);

        // Concealed finger release notches at the upper module edges.
        translate([button_origin[0] + button_opening[0] / 2, button_origin[1] - 0.1, -0.1])
            cylinder(h = panel[2] + 0.2, d = 7);
        translate([usb_origin[0] + usb_opening[0] / 2, usb_origin[1] - 0.1, -0.1])
            cylinder(h = panel[2] + 0.2, d = 7);
    }

    // Hidden panel-to-ring hooks on the inner face.
    for (x = [18, panel[0] - 18]) {
        translate([x, 8, 0]) snap_hook();
        translate([x, panel[1] - 8, 0]) rotate([0, 0, 180]) snap_hook();
    }
}

module usb_cassette() {
    color([0.13, 0.14, 0.16])
    difference() {
        union() {
            cube(usb_face);

            // Open-backed tray. Rails can be changed without reprinting front panel.
            translate([3, 4, usb_face[2]]) cube([usb_board_provisional[0], 3, usb_board_provisional[2]]);
            translate([3, usb_face[1] - 7, usb_face[2]]) cube([usb_board_provisional[0], 3, usb_board_provisional[2]]);
            translate([3, 4, usb_face[2]]) cube([3, usb_face[1] - 8, usb_board_provisional[2]]);
        }

        // USB-A data port.
        translate([9, 23, -0.1])
            cube([usb_a_cut[0], usb_a_cut[1], usb_face[2] + 0.2]);

        // USB-C data port.
        translate([36, 24.5, -0.1])
            hull() {
                translate([usb_c_cut[1] / 2, 0, 0]) cylinder(h = usb_face[2] + 0.2, d = usb_c_cut[1]);
                translate([usb_c_cut[0] - usb_c_cut[1] / 2, 0, 0]) cylinder(h = usb_face[2] + 0.2, d = usb_c_cut[1]);
            }

        // Small indicator aperture; optional and easy to blank.
        translate([usb_face[0] / 2, 10, -0.1]) cylinder(h = usb_face[2] + 0.2, d = 2.4);
    }

    // Two internal hooks retain the cassette in the standard front opening.
    translate([10, 2.2, 0]) scale([0.72, 0.72, 0.72]) snap_hook();
    translate([usb_face[0] - 10, usb_face[1] - 2.2, 0])
        rotate([0, 0, 180]) scale([0.72, 0.72, 0.72]) snap_hook();
}

module button_envelope() {
    // Envelope of the separate NexGen-derived mounting plate.
    color([0.12, 0.13, 0.15])
        cube([44.5, 31.6, 5.1]);
}

if (part == "panel") front_panel();
else if (part == "usb-cassette") usb_cassette();
else {
    front_panel();
    translate([button_origin[0] + 0.35, button_origin[1] + 0.35, panel[2]]) button_envelope();
    translate([usb_origin[0] + 0.3, usb_origin[1] + 0.3, panel[2]]) usb_cassette();
}

echo("part", part);
echo("front_panel_mm", panel);
echo("button_opening_mm", button_opening);
echo("usb_cassette_face_mm", usb_face);
echo("usb_board_envelope_provisional_mm", usb_board_provisional);
assert(panel[0] <= 250 && panel[1] <= 250, "Front panel exceeds 250 mm print-bed limit");

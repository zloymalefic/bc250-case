// Nyacom-style front service panel with replaceable NexGen button and USB hub cassette.
// All dimensions in millimetres. Baseline hub: Anker A7516 used by NexGen PRO V2.
include <lib/snap-interface.scad>
include <lib/magnet-interface.scad>

$fn = 48;

part = "assembly"; // panel | usb-cassette | assembly

panel = [125, 165, 4];
panel_chamfer = 12;
button_opening = [45.2, 32.3];
button_origin = [8, 116];
usb_opening = [28.6, 71.0];
usb_origin = [88, 75];

// NexGen supplied cover: 70.35 x 27.93 x 12.65 mm raw mesh envelope.
// Anker publishes 103 x 30 x 10 mm for the short-cable A7516 body.
usb_face = [27.93, 70.35, 3];
anker_hub = [30, 103, 10]; // panel X, panel Y, inward Z
hub_clearance = 0.40;
usb_a_cut = [15.0, 7.8];
usb_port_pitch = 16.4;
usb_port_y0 = 10.575;

button_plate = [44.5, 31.6, 5.1];
button_mount_pitch = 34;
button_boss_d = 9;
button_boss_depth = 6;
button_insert_pilot_d = 4.2;
panel_magnet_points = [[20, 7], [panel[0] - 20, 7],
                       [panel[0] / 2, panel[1] - 7],
                       [7, panel[1] / 2]];

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
    color([0.94, 0.72, 0.05]) union() {
        difference() {
            linear_extrude(height = panel[2])
                chamfered_panel_2d(panel[0], panel[1], panel_chamfer);

        // NexGen button mounting plate opening.
        translate([button_origin[0], button_origin[1], -0.1])
            cube([button_opening[0], button_opening[1], panel[2] + 0.2]);

            // Replaceable vertical Anker cassette opening.
            translate([usb_origin[0], usb_origin[1], -0.1])
                cube([usb_opening[0], usb_opening[1], panel[2] + 0.2]);

            // Nyacom-like lower industrial ventilation slots.
            for (y = [25 : 13 : 64])
                translate([panel[0] / 2, y, -0.1]) rotate([0, 0, -12])
                    capsule(72, 5, panel[2] + 0.2);

            // Concealed finger release notches at the module edges.
            translate([button_origin[0] + button_opening[0] / 2,
                       button_origin[1] - 0.1, -0.1])
                cylinder(h = panel[2] + 0.2, d = 7);
            translate([usb_origin[0] - 0.1,
                       usb_origin[1] + usb_opening[1] / 2, -0.1])
                cylinder(h = panel[2] + 0.2, d = 7);

            // Four blind pockets open from the inner face. The remaining
            // 1.8 mm skin keeps magnets invisible from the exterior.
            for (p = panel_magnet_points)
                translate([p[0], p[1], 0]) magnet_pocket_positive();
        }

        // Two real M3 insert bosses retain the NexGen-derived button plate.
        // Short ribs connect them to the opening edges instead of leaving
        // isolated cylinders inside the cut-out.
        for (i = [0 : 1]) {
            x = button_origin[0] + button_opening[0] / 2 +
                (i == 0 ? -button_mount_pitch / 2 : button_mount_pitch / 2);
            y = button_origin[1] + button_opening[1] / 2;
            difference() {
                union() {
                    translate([x, y, -button_boss_depth])
                        cylinder(h = button_boss_depth, d = button_boss_d);
                    translate([i == 0 ? button_origin[0] - 1 : x,
                               y - button_boss_d / 2, -3])
                        cube([i == 0 ? x - button_origin[0] + 1 :
                                      button_origin[0] + button_opening[0] + 1 - x,
                              button_boss_d, 3]);
                }
                translate([x, y, -button_boss_depth - 0.1])
                    cylinder(h = button_boss_depth + 0.2,
                             d = button_insert_pilot_d);
            }
        }

        // Two internal rails receive the cassette's reduced snap hooks.
        difference() {
            union() {
                translate([usb_origin[0] - 3, usb_origin[1] - 1, -5])
                    cube([usb_opening[0] + 6, 8, 5]);
                translate([usb_origin[0] - 3,
                           usb_origin[1] + usb_opening[1] - 7, -5])
                    cube([usb_opening[0] + 6, 8, 5]);
            }
            cassette_x0 = usb_origin[0] + (usb_opening[0] - usb_face[0]) / 2;
            cassette_y0 = usb_origin[1] + (usb_opening[1] - usb_face[1]) / 2;
            for (p = [[cassette_x0 + 8, cassette_y0 + 2.2],
                      [cassette_x0 + usb_face[0] - 8,
                       cassette_y0 + usb_face[1] - 2.2]])
                translate([p[0] - 3.2, p[1] - 2.2, -5.1])
                    cube([6.4, 4.4, 5.3]);
        }
    }

}

module usb_cassette() {
    color([0.13, 0.14, 0.16])
    difference() {
        union() {
            cube(usb_face);

            // Open cradle extends inward. The 103 mm hub overhangs the visible
            // 70.35 mm port cover equally at both ends.
            hub_y = (usb_face[1] - anker_hub[1]) / 2;
            hub_x = (usb_face[0] - anker_hub[0]) / 2;
            translate([hub_x - 2.4, hub_y, -anker_hub[2] - hub_clearance])
                cube([2.4, anker_hub[1], anker_hub[2] + hub_clearance + 0.2]);
            translate([hub_x + anker_hub[0], hub_y,
                       -anker_hub[2] - hub_clearance])
                cube([2.4, anker_hub[1], anker_hub[2] + hub_clearance + 0.2]);
            translate([hub_x - 2.4, hub_y - 2.4,
                       -anker_hub[2] - hub_clearance])
                cube([anker_hub[0] + 4.8, 2.4,
                      anker_hub[2] + hub_clearance + 0.2]);
            // Thin lips join the wider 30 mm cradle to the 27.93 mm face
            // outside the hub's occupied depth.
            translate([hub_x - 2.4, 0, -0.4])
                cube([3.0, usb_face[1], 0.6]);
            translate([usb_face[0] - 0.4, 0, -0.4])
                cube([hub_x + anker_hub[0] + 2.4 - usb_face[0] + 0.4,
                      usb_face[1], 0.6]);
        }

        // Four USB-A data ports of the Anker A7516.
        for (i = [0 : 3])
            translate([(usb_face[0] - usb_a_cut[0]) / 2,
                       usb_port_y0 + i * usb_port_pitch, -0.1])
                cube([usb_a_cut[0], usb_a_cut[1], usb_face[2] + 0.2]);

        // Small indicator aperture; optional and easy to blank.
        translate([usb_face[0] / 2, 10, -0.1]) cylinder(h = usb_face[2] + 0.2, d = 2.4);
    }

    // Two internal hooks retain the cassette in the standard front opening.
    translate([8, 2.2, 0]) scale([0.72, 0.72, 0.72]) snap_hook();
    translate([usb_face[0] - 8, usb_face[1] - 2.2, 0])
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
    translate([button_origin[0] + 0.35, button_origin[1] + 0.35,
               panel[2] - button_plate[2]]) button_envelope();
    translate([usb_origin[0] + (usb_opening[0] - usb_face[0]) / 2,
               usb_origin[1] + (usb_opening[1] - usb_face[1]) / 2,
               panel[2]]) usb_cassette();
}

echo("part", part);
echo("front_panel_mm", panel);
echo("button_opening_mm", button_opening);
echo("usb_cassette_face_mm", usb_face);
echo("baseline_hub", "Anker A7516 4-port USB 3.0 hub");
echo("anker_hub_envelope_mm", anker_hub);
echo("button_fasteners", "2x M3 into rear bosses");
echo("front_panel_retention", "4 pairs of 8 x 2 mm magnets");
assert(panel[0] <= 250 && panel[1] <= 250, "Front panel exceeds 250 mm print-bed limit");

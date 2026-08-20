// Flush Nyacom-style rear panel with replaceable I/O and PSU inserts.
// Exact connector apertures remain intentionally parametric/provisional.
include <lib/snap-interface.scad>

$fn = 40;

part = "assembly"; // rear-panel | io-blank | cisco | flexatx | assembly

rear_panel = [125, 165, 4];
rear_chamfer = 12;
module_face = [104, 48, 3];

psu_opening_origin = [10.2, 13];
io_opening_origin = [10.2, 91];
opening = [104.6, 48.6];

cisco_rear_provisional = [96, 40];
flexatx_rear_provisional = [81.5, 40.5];

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

module rear_main_panel() {
    color([0.88, 0.13, 0.08])
    difference() {
        linear_extrude(height = rear_panel[2])
            chamfered_panel_2d(rear_panel[0], rear_panel[1], rear_chamfer);

        translate([psu_opening_origin[0], psu_opening_origin[1], -0.1])
            cube([opening[0], opening[1], rear_panel[2] + 0.2]);
        translate([io_opening_origin[0], io_opening_origin[1], -0.1])
            cube([opening[0], opening[1], rear_panel[2] + 0.2]);

        // Concealed release notches between the two modules.
        translate([rear_panel[0] / 2, psu_opening_origin[1] + opening[1], -0.1])
            cylinder(h = rear_panel[2] + 0.2, d = 7);
        translate([rear_panel[0] / 2, io_opening_origin[1] - 0.1, -0.1])
            cylinder(h = rear_panel[2] + 0.2, d = 7);
    }

    // Main rear insert snaps into the coloured end ring.
    for (x = [18, rear_panel[0] - 18]) {
        translate([x, 8, 0]) snap_hook();
        translate([x, rear_panel[1] - 8, 0]) rotate([0, 0, 180]) snap_hook();
    }
}

module module_hooks() {
    translate([12, 2.2, 0]) scale([0.72, 0.72, 0.72]) snap_hook();
    translate([module_face[0] - 12, module_face[1] - 2.2, 0])
        rotate([0, 0, 180]) scale([0.72, 0.72, 0.72]) snap_hook();
}

module io_blank() {
    color([0.16, 0.17, 0.19]) {
        cube(module_face);
        module_hooks();
    }
}

module cisco_insert() {
    color([0.16, 0.17, 0.19])
    difference() {
        cube(module_face);

        // Provisional PSU exhaust field; the power inlet remains blank until measured.
        for (x = [10 : 10 : 70], y = [10 : 9 : 38])
            translate([x + ((round(y / 9) % 2) * 5), y, -0.1])
                cylinder(h = module_face[2] + 0.2, d = 5.8, $fn = 6);

        // Replaceable blank cable/connector zone.
        translate([79, 10, -0.1]) cube([17, 28, module_face[2] + 0.2]);
    }
    module_hooks();
}

module flexatx_insert() {
    color([0.16, 0.17, 0.19])
    difference() {
        cube(module_face);

        // Generic FlexATX rear envelope, not final mounting holes.
        translate([(module_face[0] - flexatx_rear_provisional[0]) / 2,
                   (module_face[1] - flexatx_rear_provisional[1]) / 2,
                   -0.1])
            cube([flexatx_rear_provisional[0], flexatx_rear_provisional[1], module_face[2] + 0.2]);
    }
    module_hooks();
}

if (part == "rear-panel") rear_main_panel();
else if (part == "io-blank") io_blank();
else if (part == "cisco") cisco_insert();
else if (part == "flexatx") flexatx_insert();
else {
    rear_main_panel();
    translate([io_opening_origin[0] + 0.3, io_opening_origin[1] + 0.3, rear_panel[2]]) io_blank();
    translate([psu_opening_origin[0] + 0.3, psu_opening_origin[1] + 0.3, rear_panel[2]]) cisco_insert();
}

echo("part", part);
echo("rear_panel_mm", rear_panel);
echo("standard_module_face_mm", module_face);
echo("cisco_rear_envelope_provisional_mm", cisco_rear_provisional);
echo("flexatx_rear_envelope_provisional_mm", flexatx_rear_provisional);
assert(rear_panel[0] <= 250 && rear_panel[1] <= 250, "Rear panel exceeds 250 mm print-bed limit");

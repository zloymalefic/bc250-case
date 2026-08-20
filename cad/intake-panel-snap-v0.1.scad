// Split JF13K intake panel with Nyacom-style magnetic retention.
include <lib/magnet-interface.scad>
include <lib/interface-contracts.scad>

$fn = 32;

part = "left"; // left | right | assembly

// Interface prototype only: final fan-facing cover relief is deliberately
// deferred and may be raised locally. Do not release this flat skin for print.
panel_half = intake_contract_half;
panel_chamfer = 10;
panel_gap = intake_contract_gap;
magnet_x = [intake_contract_magnet_local[0][0],
            intake_contract_magnet_local[1][0]];
magnet_y = [intake_contract_magnet_local[0][1],
            intake_contract_magnet_local[2][1]];
pry_notch = [5, 2];

module chamfered_panel_2d(width, height, cut) {
    polygon([
        [cut, 0], [width - cut, 0], [width, cut],
        [width, height - cut], [width - cut, height],
        [cut, height], [0, height - cut], [0, cut]
    ]);
}

module panel_skin() {
    linear_extrude(height = panel_half[2])
        chamfered_panel_2d(panel_half[0], panel_half[1], panel_chamfer);
}

module fan_field(cx) {
    for (row = [-5 : 5], column = [-5 : 5]) {
        dx = column * 9 + ((abs(row) % 2) * 4.5);
        dy = row * 8;
        if (dx * dx + dy * dy < 46 * 46)
            // The cover is raised 4 mm to clear the ESP32 service cover;
            // keep the grille field on the unchanged physical fan axis.
            translate([cx + dx, panel_half[1] / 2 - 4 + dy, -1])
                cylinder(h = panel_half[2] + 2,
                         d = 6.8, $fn = 6);
    }
}

module magnet_pockets_and_pry_notch() {
    for (x = magnet_x, y = magnet_y)
        translate([x, y, 0]) magnet_pocket_positive();
    // Only a tiny rectangular relief remains visible at the bottom edge.
    translate([panel_half[0] / 2 - pry_notch[0] / 2, -0.1,
               panel_half[2] - pry_notch[1]])
        cube([pry_notch[0], 2.1, pry_notch[1] + 0.2]);

    // Shallow channels capture the chassis tongues. They prevent the magnets
    // carrying shear and make the two long rails work as side-wall stiffeners.
    for (y = [2, panel_half[1] - 6])
        translate([22, y, -0.1]) cube([86, 4, 1.5]);
}

module left_panel() {
    difference() {
        panel_skin();
        fan_field(75);
        magnet_pockets_and_pry_notch();
    }
}

module right_panel() {
    difference() {
        panel_skin();
        fan_field(55);
        magnet_pockets_and_pry_notch();
    }
}

if (part == "left") left_panel();
else if (part == "right") right_panel();
else {
    color([0.16, 0.17, 0.19]) left_panel();
    color([0.19, 0.20, 0.22])
        translate([panel_half[0] + panel_gap, 0, 0]) right_panel();
}

echo("part", part);
echo("panel_half_print_bounds_nominal_mm", panel_half);
echo("structural_gap_mm", panel_gap);
echo("magnets_per_cover", 4);
echo("pry_notch_mm", pry_notch);
assert(panel_half[0] <= 250 && panel_half[1] <= 250, "Panel half exceeds 250 mm print-bed limit");
assert(2 * panel_half[0] + panel_gap == 270,
       "Intake covers and structural gap drifted from the shell interface");

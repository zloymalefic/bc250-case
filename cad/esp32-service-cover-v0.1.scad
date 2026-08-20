// Separate magnetic cover for the side-load ESP32 relay cassette.
include <lib/magnet-interface.scad>

$fn = 40;

// Local axes: X along the case, Y upward, Z toward the case exterior.
// The lower 16 mm follows the enclosure chamfer; above it the outer face is
// flush with the straight Y=155 side wall.
cover = [98, 40, 3];
cover_chamfer = 5;
magnet_points = [[5, 20], [cover[0] - 5, 20],
                 [5, 32], [cover[0] - 5, 32]];
flat_inner_z = 1;

module cover_outline_2d() {
    polygon([[cover_chamfer, 0], [cover[0] - cover_chamfer, 0],
             [cover[0], cover_chamfer],
             [cover[0], cover[1] - cover_chamfer],
             [cover[0] - cover_chamfer, cover[1]],
             [cover_chamfer, cover[1]], [0, cover[1] - cover_chamfer],
             [0, cover_chamfer]]);
}

module slot(length = 40, width = 3.2) {
    hull()
        for (x = [-length / 2 + width / 2, length / 2 - width / 2])
            translate([x, 0, -20]) cylinder(h = 30, d = width);
}

module flush_chamfered_solid() {
    intersection() {
        // Face outline and 5 mm corner cuts.
        translate([0, 0, -20])
            linear_extrude(height = 30) cover_outline_2d();

        // Y/Z section: 3 mm material following the lower case chamfer, then
        // a constant Z=1..4 slab on the straight side wall.
        multmatrix([
            [0, 0, 1, 0],
            [1, 0, 0, 0],
            [0, 1, 0, 0],
            [0, 0, 0, 1]
        ])
            linear_extrude(height = cover[0])
                polygon([[0, -15], [16, 1], [cover[1], 1],
                         [cover[1], 4], [16, 4], [0, -12]]);
    }
}

module esp32_service_cover() {
    difference() {
        flush_chamfered_solid();

        // Narrow vents preserve Wi-Fi/thermal openness without exposing the bay.
        for (y = [13, 20, 27])
            translate([cover[0] / 2, y, 0]) slot();

        for (p = magnet_points)
            translate([p[0], p[1], flat_inner_z])
                magnet_pocket_positive();

        // Small 5 x 2 mm bottom chamfer/notch for a fingernail or plastic pick.
        translate([cover[0] / 2 - 2.5, -0.1, -15.1])
            cube([5, 2.1, 3.3]);
    }
}

esp32_service_cover();

echo("ESP32 service cover mm", cover);
echo("retention", "4 pairs of 8 x 2 mm magnets");
echo("bottom pry notch mm", [5, 2]);

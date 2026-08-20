// Separate magnetic cover for the side-load ESP32 relay cassette.
include <lib/magnet-interface.scad>

$fn = 40;

cover = [78, 36, 3];
cover_chamfer = 5;
magnet_points = [[8, 5], [cover[0] - 8, 5],
                 [8, cover[1] - 3], [cover[0] - 8, cover[1] - 3]];

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
            translate([x, 0, -0.1]) cylinder(h = cover[2] + 0.2, d = width);
}

module esp32_service_cover() {
    difference() {
        linear_extrude(height = cover[2]) cover_outline_2d();

        // Narrow vents preserve Wi-Fi/thermal openness without exposing the bay.
        for (y = [13, 20, 27])
            translate([cover[0] / 2, y, 0]) slot();

        for (p = magnet_points)
            translate([p[0], p[1], 0]) magnet_pocket_positive();

        // Small 5 x 2 mm bottom chamfer/notch for a fingernail or plastic pick.
        translate([cover[0] / 2 - 2.5, -0.1, cover[2] - 2])
            cube([5, 2.1, 2.1]);
    }
}

esp32_service_cover();

echo("ESP32 service cover mm", cover);
echo("retention", "4 pairs of 8 x 2 mm magnets");
echo("bottom pry notch mm", [5, 2]);

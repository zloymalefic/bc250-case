// Separate snap-fit cover for the side-load ESP32 relay cassette.
include <lib/snap-interface.scad>
include <lib/interface-contracts.scad>

$fn = 40;

// Local axes: X along the case, Y upward, Z toward the case exterior.
// The lower 16 mm follows the enclosure chamfer; above it the outer face is
// flush with the straight Y=155 side wall.
cover = esp_contract_cover;
cover_chamfer = 5;
snap_x = esp_contract_snap_x;
snap_y = esp_contract_snap_y;
flat_inner_z = 1;

// Inner surface follows the enclosure's lower 16 mm chamfer.  A snap anchored
// to the constant Z=1 plane at the lower edge would sit outside the case.
function inner_z_at(y, case_chamfer = 16) =
    y < case_chamfer ? flat_inner_z - case_chamfer + y : flat_inner_z;

module cover_outline_2d(cover_size = cover) {
    polygon([[cover_chamfer, 0], [cover_size[0] - cover_chamfer, 0],
             [cover_size[0], cover_chamfer],
             [cover_size[0], cover_size[1] - cover_chamfer],
             [cover_size[0] - cover_chamfer, cover_size[1]],
             [cover_chamfer, cover_size[1]], [0, cover_size[1] - cover_chamfer],
             [0, cover_chamfer]]);
}

module flush_chamfered_solid(cover_size = cover, case_chamfer = 16,
                             wall_thickness = 3) {
    intersection() {
        // Face outline and 5 mm corner cuts.
        translate([0, 0, -20])
            linear_extrude(height = 30) cover_outline_2d(cover_size);

        // Y/Z section: 3 mm material following the lower case chamfer, then
        // a constant Z=1..4 slab on the straight side wall.
        multmatrix([
            [0, 0, 1, 0],
            [1, 0, 0, 0],
            [0, 1, 0, 0],
            [0, 0, 0, 1]
        ])
            linear_extrude(height = cover_size[0])
                polygon([[0, 1 - case_chamfer], [case_chamfer, 1],
                         [cover_size[1], 1],
                         [cover_size[1], 1 + wall_thickness],
                         [case_chamfer, 1 + wall_thickness],
                         [0, 1 + wall_thickness - case_chamfer]]);
    }
}

module esp32_service_cover(cover_size = cover, case_chamfer = 16) {
    difference() {
        union() {
            flush_chamfered_solid(cover_size, case_chamfer, cover_size[2]);

            // Two hooks per side engage the vertical opening edges.  Side
            // retention avoids the intake cover immediately above this part.
            for (y = snap_y) {
                translate([snap_x[0], y, inner_z_at(y, case_chamfer)])
                    rotate([y < case_chamfer ? 45 : 0, 0, 0])
                        rotate([0, 0, 90]) snap_hook();
                translate([snap_x[1], y, inner_z_at(y, case_chamfer)])
                    rotate([y < case_chamfer ? 45 : 0, 0, 0])
                        rotate([0, 0, -90]) snap_hook();
            }
        }

        // Small 5 x 2 mm bottom chamfer/notch for a fingernail or plastic pick.
        translate([cover_size[0] / 2 - 2.5, -0.1,
                   0.9 - case_chamfer])
            cube([5, 2.1, 3.3]);
    }
}

esp32_service_cover();

echo("ESP32 service cover mm", cover);
echo("retention", "4 hidden cantilever snap hooks");
echo("bottom pry notch mm", [5, 2]);
echo("exterior openings", "none; solid outer face");
assert(cover[2] >= 3, "ESP32 cover is thinner than the structural minimum");
assert(snap_y[1] <= cover[1], "ESP32 snap axes exceed the cover");
assert(inner_z_at(snap_y[0], case_chamfer) < 0,
       "Lower ESP32 snaps do not follow the enclosure chamfer inward");

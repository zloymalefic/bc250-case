// Reduced-cost coupon for the real octagonal chassis split interface.
// Each row contains a male corner and a matching female shell corner.

$fn = 32;

body_y = 155;
body_z = 195;
chamfer = 16;
wall = 4;
shell_length = 18;
collar_length = 9;
collar_embed = 1.2;
collar_wall = 2.4;
corner_window = 52;
clearances = [0.25, 0.35, 0.45];

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

module shell_ring(length) {
    difference() {
        oct_prism_x(length, body_y, body_z, chamfer);
        translate([-0.5, wall, wall])
            oct_prism_x(length + 1, body_y - 2 * wall, body_z - 2 * wall, chamfer - wall);
    }
}

module collar(clearance) {
    inset = wall + clearance;
    union() {
        translate([collar_embed - 0.2, inset, inset])
        difference() {
            oct_prism_x(collar_length + 0.2, body_y - 2 * inset, body_z - 2 * inset, chamfer - inset);
            translate([-0.5, collar_wall, collar_wall])
                oct_prism_x(collar_length + 1.2, body_y - 2 * inset - 2 * collar_wall, body_z - 2 * inset - 2 * collar_wall, chamfer - inset - collar_wall);
        }

        anchor_inset = wall - 0.2;
        anchor_thickness = collar_wall + clearance + 0.4;
        translate([0, anchor_inset, anchor_inset])
        difference() {
            oct_prism_x(collar_embed + 0.4, body_y - 2 * anchor_inset, body_z - 2 * anchor_inset, chamfer - anchor_inset);
            translate([-0.5, anchor_thickness, anchor_thickness])
                oct_prism_x(collar_embed + 1.4, body_y - 2 * anchor_inset - 2 * anchor_thickness, body_z - 2 * anchor_inset - 2 * anchor_thickness, chamfer - anchor_inset - anchor_thickness);
        }
    }
}

module corner_crop() {
    // Bottom-left chamfer plus portions of its two adjacent straight walls.
    intersection() {
        children();
        translate([-1, -1, -1]) cube([shell_length + collar_length + 2, corner_window + 1, corner_window + 1]);
    }
}

module male_corner(clearance) {
    corner_crop()
        union() {
            shell_ring(shell_length);
            translate([shell_length - collar_embed, 0, 0]) collar(clearance);
        }
}

module female_corner() {
    corner_crop() shell_ring(shell_length);
}

for (i = [0 : len(clearances) - 1]) {
    y = i * 60;
    translate([0, y, 0]) male_corner(clearances[i]);
    translate([42, y, 0]) female_corner();
}

echo("collar clearance per side candidates mm", clearances);
echo("coupon part count", len(clearances) * 2);
echo("retention", "not represented; full interface will use bottom-access M3 fasteners");

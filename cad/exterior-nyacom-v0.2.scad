// BC-250 + JF13K exterior concept v0.2
// Nyacom-inspired adaptation: long dark tunnel, chamfered end rings,
// recessed end panels, snap-fit broad-side cover, coloured accent stripe.
// Visual architecture model; not yet print-ready.

$fn = 32;

body = [330, 170, 170];
end_ring = 12;
chamfer = 16;
panel_gap = 2;
orientation = "horizontal"; // horizontal | vertical

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

module capsule_slot(length = 22, width = 4, depth = 8) {
    hull() {
        translate([-length / 2 + width / 2, 0, 0]) cylinder(h = depth, d = width);
        translate([ length / 2 - width / 2, 0, 0]) cylinder(h = depth, d = width);
    }
}

module tunnel() {
    color([0.055, 0.06, 0.07])
        translate([end_ring, 0, 0])
            oct_prism_x(body[0] - 2 * end_ring, body[1], body[2], chamfer);
}

module end_frame(xpos, accent = [0.95, 0.22, 0.08]) {
    color(accent)
    translate([xpos, 0, 0])
    difference() {
        oct_prism_x(end_ring, body[1], body[2], chamfer);
        translate([-1, 7, 7])
            oct_prism_x(end_ring + 2, body[1] - 14, body[2] - 14, chamfer - 6);
    }
}

module broad_snap_cover() {
    cover_x = 270;
    cover_y = 146;
    cover_z = 4;
    ox = (body[0] - cover_x) / 2;
    oy = (body[1] - cover_y) / 2;

    color([0.14, 0.15, 0.17])
    difference() {
        translate([ox, oy, body[2] - cover_z + 0.8])
            cube([cover_x, cover_y, cover_z]);

        // Two JF13K intake fields, kept visually separate like Nyacom modules.
        for (cx = [105, 226], dx = [-48 : 10 : 48], dy = [-48 : 9 : 48])
            if (dx * dx + dy * dy < 50 * 50)
                translate([cx + dx + ((round(dy / 9) % 2) * 5), body[1] / 2 + dy, body[2] - cover_z])
                    cylinder(h = cover_z + 3, d = 6.4, $fn = 6);
    }

    // Nyacom-like bright perimeter stripe.
    color([0.05, 0.38, 0.95]) {
        translate([ox, oy, body[2] + 5.0]) cube([cover_x, 2.2, 1.8]);
        translate([ox, oy + cover_y - 2.2, body[2] + 5.0]) cube([cover_x, 2.2, 1.8]);
        translate([ox, oy, body[2] + 5.0]) cube([2.2, cover_y, 1.8]);
        translate([ox + cover_x - 2.2, oy, body[2] + 5.0]) cube([2.2, cover_y, 1.8]);
    }
}

module side_cover() {
    // Flush, magnetically removable service cover on the visible long side.
    color([0.10, 0.11, 0.13])
    difference() {
        translate([28, -1.8, 28]) cube([274, 4, 114]);
        // Signature diagonal Nyacom-style exhaust gills at the rear quarter.
        for (x = [235 : 12 : 283], z = [50 : 12 : 122])
            translate([x, -3, z]) rotate([90, 0, 0]) rotate([0, 0, -18])
                capsule_slot(17, 3.2, 8);
    }
    color([0.05, 0.38, 0.95])
        translate([28, -2.5, 28]) cube([274, 1.2, 2.5]);
}

module front_panel() {
    color([0.16, 0.17, 0.19])
    difference() {
        translate([2.5, 11, 11])
            oct_prism_x(6, body[1] - 22, body[2] - 22, chamfer - 7);

        // Button and modular front I/O insert.
        translate([1, 43, 52]) rotate([0, 90, 0]) cylinder(h = 10, d = 16.5);
        translate([1, 67, 66]) cube([10, 15, 8]);
        translate([1, 69.5, 51]) cube([10, 10, 4.8]);

        // Vertical industrial vents copied as a design language, not geometry.
        for (y = [103 : 10 : 143])
            translate([1, y, 45]) rotate([0, 90, 0]) capsule_slot(58, 4, 10);
    }
    color([0.05, 0.38, 0.95])
        translate([1.4, 28, 26]) cube([1.2, 48, 3]);
}

module rear_panel() {
    color([0.13, 0.14, 0.16])
    difference() {
        translate([body[0] - 8.5, 11, 11])
            oct_prism_x(6, body[1] - 22, body[2] - 22, chamfer - 7);
        // Deliberately generic service zones pending measured I/O coordinates.
        translate([body[0] - 10, 25, 74]) cube([10, 120, 42]);
        translate([body[0] - 10, 28, 27]) cube([10, 98, 32]);
    }
}

module horizontal_support() {
    color([0.04, 0.045, 0.05]) {
        translate([42, 24, -7]) cube([104, 18, 7]);
        translate([184, body[1] - 42, -7]) cube([104, 18, 7]);
    }
}

module vertical_support() {
    color([0.04, 0.045, 0.05])
        translate([-8, -30, -28]) oct_prism_x(16, body[1] + 60, 226, 12);
}

module assembly() {
    tunnel();
    end_frame(0, [0.94, 0.72, 0.05]);
    end_frame(body[0] - end_ring, [0.92, 0.12, 0.08]);
    broad_snap_cover();
    side_cover();
    front_panel();
    rear_panel();
    if (orientation == "horizontal") horizontal_support();
    else vertical_support();
}

if (orientation == "horizontal") assembly();
else rotate([0, -90, 0]) assembly();

echo("concept", "Nyacom-inspired exterior v0.2");
echo("body_mm", body);
echo("status", "visual architecture; JF13K and I/O cuts provisional");

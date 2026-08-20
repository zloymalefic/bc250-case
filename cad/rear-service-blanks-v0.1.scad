// Two vertical magnetic rear service blanks shared by both rear-cover variants.
// Connector-specific cuts are deliberately deferred; these freeze the interface.
include <lib/magnet-interface.scad>

$fn = 32;

part = "assembly"; // board-io | psu | assembly

panel_thickness = 3;
window_height = 145;
window_widths = [72, 48];
edge_clearance = 0.35;
blank_height = window_height - 2 * edge_clearance;
blank_widths = [for (w = window_widths) w - 2 * edge_clearance];

module rounded_blank(width, height, radius = 3) {
    linear_extrude(height = panel_thickness)
        hull()
            for (x = [radius, width - radius], y = [radius, height - radius])
                translate([x, y]) circle(r = radius);
}

module service_blank(width) {
    difference() {
        rounded_blank(width, blank_height);
        for (x = [7, width - 7], y = [7, blank_height - 7])
            translate([x, y, 0]) magnet_pocket_positive();
    }
}

if (part == "board-io")
    service_blank(blank_widths[0]);
else if (part == "psu")
    service_blank(blank_widths[1]);
else {
    color([0.18, 0.19, 0.22]) service_blank(blank_widths[0]);
    color([0.24, 0.25, 0.28])
        translate([blank_widths[0] + 8, 0, 0]) service_blank(blank_widths[1]);
}

echo("part", part);
echo("rear service blank widths/height/thickness mm",
     [blank_widths, blank_height, panel_thickness]);
echo("retention", "4 pairs of 8 x 2 mm magnets per blank");
assert(max(blank_widths) <= 250 && blank_height <= 250,
       "Rear service blank exceeds 250 mm print-bed target");

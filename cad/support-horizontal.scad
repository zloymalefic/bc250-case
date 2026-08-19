// Horizontal support set: two printable skids using the common M4 interface.
include <lib/common.scad>

skid_length = 142;
skid_width = 28;
skid_height = support_pad_h;
skid_radius = 5;
rubber_recess_d = 12;
rubber_recess_h = 1.5;

module horizontal_skid() {
    difference() {
        rounded_box([skid_length, skid_width, skid_height], skid_radius);

        // Two chassis fasteners per skid.
        for (x = [14, skid_length - 14])
            translate([x, skid_width / 2, 0]) countersunk_support_hole(skid_height);

        // Optional self-adhesive rubber pads on the floor side.
        for (x = [10, skid_length - 10])
            translate([x, skid_width / 2, -0.1])
                cylinder(h = rubber_recess_h + 0.1, d = rubber_recess_d);
    }
}

// Export contains both identical skids with a 12 mm printing gap.
horizontal_skid();
translate([0, skid_width + 12, 0]) horizontal_skid();

echo("part", "horizontal support set");
echo("skid_mm", [skid_length, skid_width, skid_height]);
echo("fastener", "M4 countersunk, 4 pieces");

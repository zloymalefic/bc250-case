// Vertical support set: two printable transverse feet that cradle the short end.
include <lib/common.scad>

foot_length = 230;
foot_depth = 34;
foot_height = 14;
cradle_width = chassis[1] + 1.0; // 0.5 mm assembly clearance per side
cradle_depth = 9;
lip_width = (foot_length - cradle_width) / 2;
rubber_recess_d = 14;
rubber_recess_h = 1.5;

module vertical_foot() {
    difference() {
        union() {
            rounded_box([foot_length, foot_depth, foot_height], 6);

            // Side lips locate the 170 mm chassis end without blocking airflow.
            translate([0, 0, foot_height])
                cube([lip_width, foot_depth, cradle_depth]);
            translate([lip_width + cradle_width, 0, foot_height])
                cube([lip_width, foot_depth, cradle_depth]);
        }

        // Common M4 attachment points, transferred to the standing end.
        for (x = [lip_width + 28.5, lip_width + cradle_width - 28.5])
            translate([x, foot_depth / 2, 0]) countersunk_support_hole(foot_height);

        // Optional rubber feet.
        for (x = [14, foot_length - 14])
            translate([x, foot_depth / 2, -0.1])
                cylinder(h = rubber_recess_h + 0.1, d = rubber_recess_d);
    }
}

// Two feet stabilize the chassis along its 330 mm height axis.
vertical_foot();
translate([0, foot_depth + 12, 0]) vertical_foot();

echo("part", "vertical support set");
echo("foot_mm", [foot_length, foot_depth, foot_height + cradle_depth]);
echo("chassis_cradle_mm", cradle_width);
echo("fastener", "M4 countersunk, 4 pieces");

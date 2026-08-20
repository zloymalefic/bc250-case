// Two-piece snap calibration coupon.
include <lib/snap-interface.scad>

part = "set"; // hook | receiver | set

module hook_coupon() {
    cube([30, 22, 4]);
    translate([15, 20 - snap_arm_thickness, 0]) snap_hook();
}

module receiver_coupon() {
    difference() {
        cube([30, 12, 12]);
        translate([15, 0, 12]) snap_receiver_slot(12);
    }
}

if (part == "hook") hook_coupon();
else if (part == "receiver") receiver_coupon();
else {
    hook_coupon();
    translate([40, 0, 0]) receiver_coupon();
}

echo("snap_arm_mm", [snap_arm_width, snap_arm_thickness, snap_arm_drop]);
echo("barb_depth_mm", snap_barb_depth);
echo("slot_clearance_per_side_mm", snap_slot_clearance);

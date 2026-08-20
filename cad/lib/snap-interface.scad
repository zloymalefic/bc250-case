// Hidden panel snap interface v0.1.
// Print and test the coupon before committing full panels to a printer.

snap_arm_width = 8;
snap_arm_thickness = 2.2;
snap_arm_drop = 8;
snap_barb_depth = 1.0;
snap_barb_height = 2.0;
snap_slot_clearance = 0.30;

module snap_hook() {
    // Panel underside is Z=0; hook extends downward.
    union() {
        translate([-snap_arm_width / 2, 0, -snap_arm_drop])
            cube([snap_arm_width, snap_arm_thickness, snap_arm_drop + 0.4]);
        hull() {
            translate([-snap_arm_width / 2, snap_arm_thickness, -snap_arm_drop])
                cube([snap_arm_width, 0.2, snap_barb_height]);
            translate([-snap_arm_width / 2, snap_arm_thickness + snap_barb_depth, -snap_arm_drop + snap_barb_height])
                cube([snap_arm_width, 0.2, 0.2]);
        }
    }
}

module snap_receiver_slot(depth = 8, clearance = snap_slot_clearance) {
    translate([
        -snap_arm_width / 2 - clearance,
        -0.1,
        -snap_arm_drop - clearance
    ])
        cube([
            snap_arm_width + 2 * clearance,
            depth + 0.2,
            snap_arm_drop + 2 * clearance
        ]);
}

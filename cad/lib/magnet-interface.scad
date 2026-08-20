// Shared removable-panel magnet interface.
// Baseline hardware follows the Nyacom source: 8 x 2 mm disc magnets.

$fn = 48;

magnet_nominal_d = 8;
magnet_nominal_h = 2;
magnet_pocket_d = 8.25;
magnet_pocket_depth = 2.20;
magnet_boss_d = 12;
magnet_boss_height = 4.5;

module magnet_pocket_positive(depth = magnet_pocket_depth) {
    translate([0, 0, -0.1])
        cylinder(h = depth + 0.1, d = magnet_pocket_d);
}

module magnet_boss_positive() {
    difference() {
        cylinder(h = magnet_boss_height, d = magnet_boss_d);
        magnet_pocket_positive();
    }
}

module magnet_boss_negative() {
    rotate([180, 0, 0]) magnet_boss_positive();
}

echo("panel magnets", "8 x 2 mm disc; 8.25 x 2.20 mm adhesive pockets");

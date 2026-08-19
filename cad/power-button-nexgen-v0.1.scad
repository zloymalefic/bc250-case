// Three-part, backlit, rotatable power-button module.
// Architecture follows the supplied NexGen PRO V2 reference.
// Geometry is recreated for this project and is not an imported mesh.

$fn = 64;

exploded = true;
plate = [44.5, 31.6, 5.1];
plate_radius = 4;
button_d = 16.2;
light_pipe_d = 19.8;
cap_d = 16.0;
mount_pitch = 34;

module rounded_plate(size, radius) {
    hull()
        for (x = [radius, size[0] - radius], y = [radius, size[1] - radius])
            translate([x, y, 0]) cylinder(h = size[2], r = radius);
}

module mounting_plate() {
    color([0.12, 0.13, 0.15])
    difference() {
        rounded_plate(plate, plate_radius);
        translate([plate[0] / 2, plate[1] / 2, -0.1]) cylinder(h = plate[2] + 0.2, d = light_pipe_d + 0.4);
        for (x = [plate[0] / 2 - mount_pitch / 2, plate[0] / 2 + mount_pitch / 2])
            translate([x, plate[1] / 2, -0.1]) cylinder(h = plate[2] + 0.2, d = 3.4);
    }
}

module light_pipe() {
    color([0.75, 0.90, 1.0, 0.55])
    difference() {
        union() {
            cylinder(h = 6, d = light_pipe_d);
            translate([0, 0, 5.8]) cylinder(h = 2.2, d1 = light_pipe_d, d2 = 17.2);
        }
        translate([0, 0, -0.1]) cylinder(h = 8.2, d = button_d);
    }
}

module button_cap() {
    color([0.10, 0.11, 0.13])
    difference() {
        cylinder(h = 6.2, d = cap_d);
        // Simple illuminated power glyph; final emblem remains replaceable.
        translate([0, 0, 5.4]) {
            difference() {
                cylinder(h = 1, d = 8.2);
                cylinder(h = 1.2, d = 5.3);
                translate([-1.4, -5, -0.1]) cube([2.8, 5.5, 1.4]);
            }
            translate([-1.1, 0, 0]) cube([2.2, 5.2, 1]);
        }
    }
}

mounting_plate();
translate([plate[0] / 2, plate[1] / 2, exploded ? 12 : 0]) light_pipe();
translate([plate[0] / 2, plate[1] / 2, exploded ? 25 : 1.8]) button_cap();

echo("module", "three-part rotatable backlit power button");
echo("plate_mm", plate);
echo("switch_nominal_mm", 16);
echo("fasteners", "2x M3");

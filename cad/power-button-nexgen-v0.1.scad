// Three-part, backlit, rotatable power-button module.
// Architecture follows the supplied NexGen PRO V2 reference.
// Geometry is recreated for this project and is not an imported mesh.

$fn = 64;

exploded = true;
show_nexgen_logo_preview = true;
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

module nexgen_steam_logo_cap() {
    // Original supplied NexGen asset. Source bounds are 6.20 x 16 x 16 mm
    // with thickness along X; transform places it flat with Z=0 at its rear.
    color([0.10, 0.11, 0.13])
        translate([0, 0, 3.566254])
            rotate([0, 90, 0])
                translate([0, -4.527873, -95.01802])
                    import("vendor/nexgen/pro-v2-steam-logo.stl");
}

mounting_plate();
translate([plate[0] / 2, plate[1] / 2, exploded ? 12 : 0]) light_pipe();
// The original logo is a three-body multi-material object. Reference-only
// display avoids destructively unioning it during OpenSCAD export.
if (show_nexgen_logo_preview)
    %translate([plate[0] / 2, plate[1] / 2, exploded ? 25 : 1.8]) nexgen_steam_logo_cap();

echo("module", "three-part rotatable backlit power button");
echo("plate_mm", plate);
echo("switch_nominal_mm", 16);
echo("fasteners", "2x M3");
echo("logo_source", "NexGen PRO V2 pro-v2-steam-logo.3mf");

// Removable peripheral cassettes: 7-15 mm 2.5-inch drive and ESP32 relay board.
// Device-hole coordinates remain adjustable until hardware is measured.

$fn = 40;

part = "set"; // ssd | esp32 | set

ssd_envelope = [100.5, 69.9, 15];
ssd_tray = [110, 80, 2.4];
esp_envelope = [60, 60, 22];
esp_tray = [68, 68, 2.4];
esp_board_clearance = 0.6;
esp_detent_center = [esp_tray[0], esp_tray[1] - 4];

slot_d = 3.6;
slot_length = 12;
ssd_hole_pitch = [76.6, 61.72];
ssd_hole_origin = [(ssd_tray[0] - ssd_hole_pitch[0]) / 2,
                   (ssd_tray[1] - ssd_hole_pitch[1]) / 2];
ssd_retention_axis = [ssd_tray[0] / 2, 4];

module elongated_hole(length, diameter, height) {
    hull() {
        translate([-length / 2 + diameter / 2, 0, 0]) cylinder(h = height, d = diameter);
        translate([ length / 2 - diameter / 2, 0, 0]) cylinder(h = height, d = diameter);
    }
}

module ssd_cassette() {
    color([0.24, 0.25, 0.28])
    difference() {
        union() {
            // Open-centre bridge minimizes obstruction of the backplate channel.
            cube([ssd_tray[0], 8, ssd_tray[2]]);
            translate([0, ssd_tray[1] - 8, 0]) cube([ssd_tray[0], 8, ssd_tray[2]]);
            cube([8, ssd_tray[1], ssd_tray[2]]);
            translate([ssd_tray[0] - 8, 0, 0]) cube([8, ssd_tray[1], ssd_tray[2]]);

            // Low corner locators do not constrain drive thickness; the same
            // tray accepts common 7, 9.5, 12.5 and 15 mm 2.5-inch devices.
            for (x = [5, ssd_tray[0] - 9], y = [5, ssd_tray[1] - 9])
                translate([x, y, ssd_tray[2] - 0.4]) cube([4, 4, 3.4]);

            // Front service ear for one axial M3 retention screw.
            translate([ssd_retention_axis[0] - 7, 0, 0])
                cube([14, 10, 4.8]);
        }

        // SFF-style 76.6 x 61.72 mm bottom pattern with longitudinal tolerance.
        for (x = [ssd_hole_origin[0], ssd_hole_origin[0] + ssd_hole_pitch[0]],
             y = [ssd_hole_origin[1], ssd_hole_origin[1] + ssd_hole_pitch[1]])
            translate([x, y, -0.1])
                elongated_hole(7, slot_d, ssd_tray[2] + 0.2);

        translate([ssd_retention_axis[0], ssd_retention_axis[1], -0.1])
            cylinder(h = 5.0, d = 3.4);
    }
}

module esp32_cassette() {
    color([0.18, 0.36, 0.62])
    difference() {
        union() {
            // Base and three edges; antenna edge remains completely open.
            cube(esp_tray);
            translate([0, 0, esp_tray[2]]) cube([3, esp_tray[1], 8]);
            translate([esp_tray[0] - 3, 0, esp_tray[2]]) cube([3, esp_tray[1], 8]);
            translate([0, 0, esp_tray[2]]) cube([esp_tray[0], 3, 8]);

            // Low pull tab remains accessible from the side service opening.
            translate([esp_tray[0] / 2 - 10, esp_tray[1], 0])
                cube([20, 6, 4]);
        }

        // Four broad slots accept sliding PCB posts after hole measurement.
        for (x = [10, esp_tray[0] - 10], y = [12, esp_tray[1] - 12])
            translate([x, y, -0.1]) elongated_hole(10, 3.4, esp_tray[2] + 0.2);

        // Service opening for USB programming cable.
        translate([esp_tray[0] / 2 - 8, -0.1, 5]) cube([16, 4, 5]);

        // Edge notch engages a small printed detent in the chassis rail.
        translate([esp_detent_center[0], esp_detent_center[1], -0.1])
            cylinder(h = esp_tray[2] + 0.2, d = 2.8);
    }
}

if (part == "ssd") ssd_cassette();
else if (part == "esp32") esp32_cassette();
else {
    ssd_cassette();
    translate([ssd_tray[0] + 15, 0, 0]) esp32_cassette();
}

echo("part", part);
echo("supported_ssd_envelope_mm", ssd_envelope);
echo("ssd_bottom_hole_pitch_mm", ssd_hole_pitch);
echo("ssd_retention", "1x front-access M3 plus 4x device M3");
echo("esp32_board_envelope_provisional_mm", esp_envelope);
echo("esp32_retention", "four adjustable post slots plus side-rail detent");
assert(ssd_envelope[2] <= 15, "SSD exceeds supported maximum thickness");

// Removable peripheral cassettes: 7 mm 2.5-inch SSD and ESP32 relay board.
// Device-hole coordinates remain adjustable until hardware is measured.

$fn = 40;

part = "set"; // ssd7 | esp32 | set

ssd_envelope = [100, 70, 7];
ssd_tray = [110, 80, 2.4];
esp_envelope = [60, 60, 22];
esp_tray = [68, 68, 2.4];

slot_d = 3.6;
slot_length = 12;

module elongated_hole(length, diameter, height) {
    hull() {
        translate([-length / 2 + diameter / 2, 0, 0]) cylinder(h = height, d = diameter);
        translate([ length / 2 - diameter / 2, 0, 0]) cylinder(h = height, d = diameter);
    }
}

module ssd7_cassette() {
    color([0.24, 0.25, 0.28])
    difference() {
        union() {
            // Open-centre bridge minimizes obstruction of the backplate channel.
            cube([ssd_tray[0], 8, ssd_tray[2]]);
            translate([0, ssd_tray[1] - 8, 0]) cube([ssd_tray[0], 8, ssd_tray[2]]);
            cube([8, ssd_tray[1], ssd_tray[2]]);
            translate([ssd_tray[0] - 8, 0, 0]) cube([8, ssd_tray[1], ssd_tray[2]]);

            // Four low adjustable retainers; total cassette height remains under 10 mm.
            for (x = [5, ssd_tray[0] - 9], y = [5, ssd_tray[1] - 9])
                translate([x, y, ssd_tray[2] - 1.0]) cube([4, 4, 7.5]);
        }

        // Adjustable M3 device slots instead of unverified fixed hole coordinates.
        for (x = [18, ssd_tray[0] - 18], y = [4, ssd_tray[1] - 4])
            translate([x, y, -0.1])
                elongated_hole(slot_length, slot_d, ssd_tray[2] + 0.2);
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
        }

        // Four broad slots accept sliding PCB posts after hole measurement.
        for (x = [10, esp_tray[0] - 10], y = [12, esp_tray[1] - 12])
            translate([x, y, -0.1]) elongated_hole(10, 3.4, esp_tray[2] + 0.2);

        // Service opening for USB programming cable.
        translate([esp_tray[0] / 2 - 8, -0.1, 5]) cube([16, 4, 5]);
    }
}

if (part == "ssd7") ssd7_cassette();
else if (part == "esp32") esp32_cassette();
else {
    ssd7_cassette();
    translate([ssd_tray[0] + 15, 0, 0]) esp32_cassette();
}

echo("part", part);
echo("supported_ssd_envelope_mm", ssd_envelope);
echo("ssd_cassette_height_mm", ssd_tray[2] + 6.5);
echo("esp32_board_envelope_provisional_mm", esp_envelope);
assert(ssd_tray[2] + 6.5 <= 10, "SSD cassette exceeds allocated local channel height");

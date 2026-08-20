// BC-250 + JF13K — Layout A envelope study
// Units: millimetres. This is a collision/architecture model, not a printable case.

$fn = 48;

// ---- Display ---------------------------------------------------------------
show_chassis = true;
show_components = true;
show_horizontal_support = true;
show_vertical_support = false;
show_airflow_guides = true;
section_view = true;
export_projection = false;

// ---- Confidence ------------------------------------------------------------
// confirmed: measured from local mesh or manufacturer data
// provisional: replace after physical measurement

// Common chassis, provisional target envelope.
chassis = [330, 155, 195];
wall = 3;
corner_radius = 8;

// BC-250 proxy envelope: confirmed from bc250_alt.stl.
bc250 = [311.7, 144, 31.8];
pcb_thickness = 1.6;
pcb_origin = [9.15, 5.5, 55];

// JF13K manufacturer envelope. Installed Z origin is provisional.
jf13k = [241, 121, 92];
jf13k_origin = [44.5, 17, pcb_origin[2] + pcb_thickness];
jf13k_install_extra = 8; // conservative adapter/mount allowance; not additive fact

// Cisco UCSC-PSU-650W V02: provisional external envelope.
cisco_psu = [240, 96, 40];
cisco_psu_origin = [10, 8, 3];

// Standard peripheral envelopes.
ssd25 = [70, 100, 15];
ssd25_origin = [253, 52, 7];
esp_relay = [60, 60, 22];
esp_relay_origin = [263, 5, 7];

// Required functional gaps.
mesh_gap = 10;
backplate_channel = pcb_origin[2] - (cisco_psu_origin[2] + cisco_psu[2]);

// ---- Helpers ---------------------------------------------------------------
module rounded_box(size, radius) {
    hull() {
        for (x = [radius, size[0] - radius], y = [radius, size[1] - radius])
            translate([x, y, 0]) cylinder(h = size[2], r = radius);
    }
}

module shell() {
    color([0.75, 0.77, 0.80, 0.22])
    difference() {
        rounded_box(chassis, corner_radius);
        translate([wall, wall, wall])
            rounded_box(chassis - [2 * wall, 2 * wall, 2 * wall], corner_radius - wall);

        // Main JF13K intake opening.
        translate([jf13k_origin[0] - 5, jf13k_origin[1] - 5, chassis[2] - wall - 1])
            cube([jf13k[0] + 10, jf13k[1] + 10, wall + 2]);

        // I/O and service end left open in section view.
        if (section_view)
            translate([chassis[0] - wall - 1, wall, wall])
                cube([wall + 2, chassis[1] - 2 * wall, chassis[2] - 2 * wall]);
    }
}

module bc250_envelope() {
    // PCB plane.
    color([0.12, 0.55, 0.28, 0.85])
        translate(pcb_origin) cube([bc250[0], bc250[1], pcb_thickness]);

    // Component/backplate keepout around the PCB plane.
    color([0.12, 0.55, 0.28, 0.18])
        translate([pcb_origin[0], pcb_origin[1], pcb_origin[2] - 10])
            cube([bc250[0], bc250[1], bc250[2]]);
}

module jf13k_envelope() {
    color([0.12, 0.42, 0.85, 0.45])
        translate(jf13k_origin)
            cube([jf13k[0], jf13k[1], jf13k[2] + jf13k_install_extra]);

    // Two fan discs indicate intake positions.
    for (x = [jf13k_origin[0] + 60, jf13k_origin[0] + 181])
        color([0.15, 0.55, 0.95, 0.65])
            translate([x, jf13k_origin[1] + 60.5, jf13k_origin[2] + jf13k[2] + jf13k_install_extra + 0.2])
                cylinder(h = 1.2, d = 116);
}

module lower_modules() {
    color([0.95, 0.48, 0.12, 0.65])
        translate(cisco_psu_origin) cube(cisco_psu);
    color([0.55, 0.30, 0.82, 0.70])
        translate(esp_relay_origin) cube(esp_relay);
    color([0.70, 0.33, 0.72, 0.55])
        translate(ssd25_origin) cube(ssd25);
}

module airflow_guides() {
    // JF13K intake guide cylinders; visual only.
    for (x = [jf13k_origin[0] + 60, jf13k_origin[0] + 181])
        color([0.15, 0.65, 1.0, 0.24])
            translate([x, jf13k_origin[1] + 60.5, jf13k_origin[2] + jf13k[2] + jf13k_install_extra])
                cylinder(h = chassis[2] - (jf13k_origin[2] + jf13k[2] + jf13k_install_extra), d = 108);

    // Backplate channel indicator.
    color([0.18, 0.75, 0.95, 0.20])
        translate([pcb_origin[0], pcb_origin[1], cisco_psu_origin[2] + cisco_psu[2]])
            cube([bc250[0], bc250[1], max(backplate_channel, 0.1)]);
}

module horizontal_support() {
    foot = [55, 18, 6];
    color([0.20, 0.20, 0.22, 0.85]) {
        for (x = [18, chassis[0] - foot[0] - 18], y = [12, chassis[1] - foot[1] - 12])
            translate([x, y, -foot[2]]) cube(foot);
    }
}

module vertical_support() {
    // Fits the short end; actual anti-tip width remains a design variable.
    base = [28, chassis[1] + 80, 8];
    color([0.20, 0.20, 0.22, 0.85])
        translate([-base[2], -40, -40]) cube(base);
}

module layout_a() {
    if (show_chassis) shell();
    if (show_components) {
        bc250_envelope();
        jf13k_envelope();
        lower_modules();
    }
    if (show_airflow_guides) airflow_guides();
    if (show_horizontal_support) horizontal_support();
    if (show_vertical_support) vertical_support();
}

if (export_projection)
    projection(cut = false) layout_a();
else
    layout_a();

echo("chassis_mm", chassis);
echo("chassis_litres", chassis[0] * chassis[1] * chassis[2] / 1000000);
echo("backplate_channel_mm", backplate_channel);
echo("jf13k_top_z_mm", jf13k_origin[2] + jf13k[2] + jf13k_install_extra);

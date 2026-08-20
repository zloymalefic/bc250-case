// Integrated packaging check: split chassis + board tray + internal Cisco PSU rail.
// This is a validation assembly, not a single printable part.

$fn = 32;

show_chassis = true;
show_tray = true;
show_psu = true;
show_board = true;

body = [330, 155, 195];
board_proxy = [311.7, 144, 1.6];
tray_origin = [6, 4.4, 49];
board_plane_z = tray_origin[2] + 16;
psu_top_z = 53; // current Cisco envelope on the universal internal rail
jf13k_stack_above_board = 101.6; // 1.6 PCB datum + 92 cooler + 8 allowance
jf13k_top_z = board_plane_z + jf13k_stack_above_board;

module chassis_assembly() {
    color([0.08, 0.09, 0.11, 0.28]) {
        import("exports/chassis-front-v0.1.stl");
        translate([165, 0, 0]) import("exports/chassis-rear-v0.1.stl");
    }
}

module tray_assembly() {
    color([0.20, 0.22, 0.25])
    translate(tray_origin) {
        import("exports/board-tray-front-v0.1.stl");
        translate([159, 0, 0]) import("exports/board-tray-rear-v0.1.stl");
    }
}

module cisco_psu_assembly() {
    color([0.92, 0.45, 0.08, 0.55])
        import("exports/psu-internal-cisco-v0.1.stl");
}

module board_envelope() {
    color([0.10, 0.56, 0.28, 0.42])
        translate([(body[0] - board_proxy[0]) / 2, (body[1] - board_proxy[1]) / 2, board_plane_z])
            cube(board_proxy);
}

if (show_chassis) chassis_assembly();
if (show_tray) tray_assembly();
if (show_psu) cisco_psu_assembly();
if (show_board) board_envelope();

echo("body_mm", body);
echo("board_plane_z_mm", board_plane_z);
echo("psu_top_z_mm", psu_top_z);
echo("psu_to_board_channel_mm", board_plane_z - psu_top_z);
echo("jf13k_top_z_mm", jf13k_top_z);
echo("jf13k_to_body_clearance_mm", body[2] - jf13k_top_z);
assert(board_plane_z - psu_top_z >= 12, "PSU-to-board channel below 12 mm");
assert(jf13k_top_z <= body[2], "JF13K envelope exceeds chassis height");

// BC-250 vertical board spine v0.1
// Independent geometry based on the factual bare-PCB envelope and open-licensed
// adapter checks. No restricted third-party mesh is imported or redistributed.

$fn = 40;

part = "assembly"; // front | rear | assembly
show_board = true;
assembly_gap = 0;

board = [308.0, 1.6, 144.3]; // X length, Y thickness, Z height
board_clearance = 0.40;
frame_margin = 4;
frame_depth = 8;
frame_rail = 8;
frame = [board[0] + 2 * frame_margin, frame_depth,
         board[2] + 2 * frame_margin];

split_x = frame[0] / 2;
tongue_length = 10;
tongue_clearance = 0.30;
tongue_height = 4;

board_pocket_depth = 2.0;
board_pocket = [board[0] + 2 * board_clearance,
                board[1] + board_clearance,
                board[2] + 2 * board_clearance];

shell_mount_x = [24, 92, frame[0] - 92, frame[0] - 24];
shell_mount_z = [frame_rail / 2, frame[2] - frame_rail / 2];
m4_clearance_d = 4.5;

module y_hole(x, z, diameter, length) {
    translate([x, -0.1, z])
        rotate([-90, 0, 0]) cylinder(h = length + 0.2, d = diameter);
}

module complete_spine() {
    difference() {
        cube(frame);

        // Open centre preserves backplate access and rear-component airflow.
        translate([frame_rail, -0.1, frame_rail])
            cube([frame[0] - 2 * frame_rail, frame_depth + 0.2,
                  frame[2] - 2 * frame_rail]);

        // The board nests 2 mm into the front face. The remaining 6 mm is the
        // structural rail and future heat-set-insert depth.
        translate([
            frame_margin - board_clearance,
            frame_depth - board_pocket_depth,
            frame_margin - board_clearance
        ])
            cube([board_pocket[0], board_pocket_depth + 0.1,
                  board_pocket[2]]);

        // Eight transverse chassis points remain accessible with the PCB fitted.
        for (x = shell_mount_x, z = shell_mount_z)
            y_hole(x, z, m4_clearance_d, frame_depth);
    }
}

module spine_slice(x0, length) {
    intersection() {
        complete_spine();
        translate([x0, -1, -1]) cube([length, frame_depth + 2, frame[2] + 2]);
    }
}

module front_spine() {
    union() {
        spine_slice(0, split_x);
        for (z = [2, frame[2] - 2 - tongue_height])
            translate([split_x - 0.2, 1.5, z])
                cube([tongue_length + 0.2, frame_depth - 3, tongue_height]);
    }
}

module rear_spine() {
    difference() {
        spine_slice(split_x, frame[0] - split_x);
        for (z = [2 - tongue_clearance,
                  frame[2] - 2 - tongue_height - tongue_clearance])
            translate([split_x - 0.3, 1.5 - tongue_clearance, z])
                cube([tongue_length + tongue_clearance + 0.5,
                      frame_depth - 3 + 2 * tongue_clearance,
                      tongue_height + 2 * tongue_clearance]);
    }
}

module board_proxy() {
    color([0.10, 0.48, 0.29, 0.42])
        translate([frame_margin, frame_depth - board_pocket_depth,
                   frame_margin])
            cube(board);
}

if (part == "front")
    front_spine();
else if (part == "rear")
    translate([-split_x, 0, 0]) rear_spine();
else {
    color([0.16, 0.17, 0.20]) front_spine();
    color([0.22, 0.23, 0.27]) translate([assembly_gap, 0, 0]) rear_spine();
    if (show_board && assembly_gap == 0) board_proxy();
}

echo("part", part);
echo("bare PCB XxZxY mm", [board[0], board[2], board[1]]);
echo("spine print envelope mm", [split_x + tongue_length, frame[2], frame_depth]);
echo("board pocket clearance each edge mm", board_clearance);
echo("chassis M4 axes X/Z mm", [shell_mount_x, shell_mount_z]);
echo("retention status", "edge clamps not frozen; requires physical keepout check");

assert(split_x + tongue_length <= 220, "Front spine exceeds 220 mm print-bed target");
assert(frame[2] <= 220, "Spine height exceeds 220 mm print-bed target");
assert(board_pocket_depth >= board[1], "Board pocket is shallower than PCB");

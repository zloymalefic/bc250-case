// Fully internal NexGen-compatible PSU receiver v0.2
// Shared adapter family stays in front of the X=318 rear inner plane.
include <lib/interface-contracts.scad>

$fn = 40;

part = "assembly"; // receiver | clamp | adapter-proxy | assembly
adapter = "server"; // server | flexatx | lop
show_adapter = true;

rear_inner_plane = psu_contract_rear_inner_x;
rear_shell_plane = case_body[0];
adapter_face = psu_contract_face; // Y width, Z height
adapter_depths = [21.5, 7.2, 11.3];
adapter_clearance = 0.35;
max_adapter_depth = max(adapter_depths);

receiver_wall = 4;
receiver_depth = max_adapter_depth + adapter_clearance + 3;
receiver_outer = [receiver_depth,
                  adapter_face[0] + 2 * receiver_wall,
                  adapter_face[1] + 2 * receiver_wall];
receiver_origin = [rear_inner_plane - receiver_outer[0],
                   (case_body[1] - receiver_outer[1]) / 2, 30];

seat_depth = 3;
clamp_size = [4, 28, 12];
m3_clearance_d = 3.4;

function adapter_depth(name) =
    name == "server" ? adapter_depths[0] :
    name == "flexatx" ? adapter_depths[1] : adapter_depths[2];

module x_hole(x, y, z, length, diameter) {
    translate([x, y, z]) rotate([0, 90, 0]) cylinder(h = length, d = diameter);
}

module receiver() {
    difference() {
        union() {
            // Rear seat frame. Its stop remains 12 mm ahead of the exterior.
            translate([rear_inner_plane - seat_depth,
                       receiver_origin[1], receiver_origin[2]])
            difference() {
                cube([seat_depth, receiver_outer[1], receiver_outer[2]]);
                translate([-0.1, receiver_wall, receiver_wall])
                    cube([seat_depth + 0.2, adapter_face[0], adapter_face[1]]);
            }

            // Four longitudinal corner guides accept every adapter depth.
            for (y = [receiver_origin[1],
                      receiver_origin[1] + receiver_outer[1] - receiver_wall],
                 z = [receiver_origin[2],
                      receiver_origin[2] + receiver_outer[2] - receiver_wall])
                translate([receiver_origin[0], y, z])
                    cube([receiver_depth - seat_depth + 0.2,
                          receiver_wall, receiver_wall]);

            // Mid-side guides prevent the thin plates from bowing.
            for (y = [receiver_origin[1],
                      receiver_origin[1] + receiver_outer[1] - receiver_wall])
                translate([receiver_origin[0], y,
                           receiver_origin[2] + receiver_outer[2] / 2 - 2])
                    cube([receiver_depth - seat_depth + 0.2, receiver_wall, 4]);
        }

        for (y = [receiver_origin[1] + 18,
                  receiver_origin[1] + receiver_outer[1] - 18])
            x_hole(receiver_origin[0] - 0.1, y,
                   receiver_origin[2] + receiver_outer[2] / 2,
                   receiver_depth + 0.2, m3_clearance_d);
    }
}

module clamp_bar() {
    difference() {
        cube(clamp_size);
        translate([-0.1, clamp_size[1] / 2, clamp_size[2] / 2])
            rotate([0, 90, 0])
                cylinder(h = clamp_size[0] + 0.2, d = m3_clearance_d);
    }
}

module adapter_proxy(name) {
    depth = adapter_depth(name);
    color(name == "server" ? [0.88, 0.39, 0.08, 0.65] :
          name == "flexatx" ? [0.18, 0.47, 0.85, 0.65] :
                               [0.48, 0.70, 0.25, 0.65])
        translate([rear_inner_plane - seat_depth - depth,
                   receiver_origin[1] + receiver_wall + adapter_clearance,
                   receiver_origin[2] + receiver_wall + adapter_clearance])
            cube([depth,
                  adapter_face[0] - 2 * adapter_clearance,
                  adapter_face[1] - 2 * adapter_clearance]);
}

module clamp_pair_global() {
    for (y = [receiver_origin[1] + 4,
              receiver_origin[1] + receiver_outer[1] - 4 - clamp_size[1]])
        translate([receiver_origin[0] - clamp_size[0], y,
                   receiver_origin[2] + receiver_outer[2] / 2 - clamp_size[2] / 2])
            clamp_bar();
}

if (part == "receiver")
    translate(-receiver_origin) receiver();
else if (part == "clamp")
    clamp_bar();
else if (part == "adapter-proxy")
    translate([-(rear_inner_plane - seat_depth - adapter_depth(adapter)),
               -(receiver_origin[1] + receiver_wall + adapter_clearance),
               -(receiver_origin[2] + receiver_wall + adapter_clearance)])
        adapter_proxy(adapter);
else {
    color([0.20, 0.22, 0.25]) receiver();
    color([0.55, 0.57, 0.61]) clamp_pair_global();
    if (show_adapter) adapter_proxy(adapter);
}

echo("part", part);
echo("adapter", adapter);
echo("shared NexGen-derived face YxZ mm", adapter_face);
echo("supported raw adapter depths mm", adapter_depths);
echo("receiver X bounds mm", [receiver_origin[0], rear_inner_plane]);
echo("distance to external shell plane mm", rear_shell_plane - rear_inner_plane);
echo("receiver print envelope mm", receiver_outer);

assert(receiver_origin[0] >= 0, "PSU receiver exceeds the front of the chassis");
assert(rear_inner_plane < rear_shell_plane,
       "PSU receiver protrudes beyond the exterior shell plane");
assert(receiver_outer[1] <= case_body[1] && receiver_outer[2] <= case_body[2],
       "PSU receiver exceeds the case cross-section");

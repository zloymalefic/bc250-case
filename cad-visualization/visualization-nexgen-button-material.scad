// Export wrapper for the separated materials of the supplied NexGen cap.
//
// The source 3MF keeps the coordinates of the complete NexGen assembly.  Move
// both material bodies onto one small, shared button-local datum so the viewer
// can place the cap and logo as a single assembly instead of maintaining two
// unrelated sets of magic coordinates.  Local X is the button axis: X=0 is
// the panel-side face and negative X points out of the case.
part = "black"; // black | white

source_face_x = 3.566254;
source_center_y = 4.527873;
source_center_z = 95.01802;

module normalized_button_material(path) {
    translate([-source_face_x, -source_center_y, -source_center_z])
        import(path);
}

if (part == "black")
    normalized_button_material("../cad/vendor/nexgen/button-cap-black.3mf");
else if (part == "white")
    normalized_button_material("../cad/vendor/nexgen/button-logo-white.3mf");

// Visualization-only exports of supplied reference components.
// These meshes remain separate from production CAD and retain their source licenses.

part = "button-plate"; // button-plate | button-light-pipe | button-cap | usb-cover

if (part == "button-plate")
    import("../references/printables-1793043-nexgen-pro-v2/Power Button/pro-v2-button-mounting-plate.3mf");
else if (part == "button-light-pipe")
    import("../references/printables-1793043-nexgen-pro-v2/Power Button/pro-v2-transparent-rear-section.3mf");
else if (part == "button-cap")
    import("../references/printables-1793043-nexgen-pro-v2/Power Button/pro-v2-steam-logo.3mf");
else if (part == "usb-cover")
    import("../references/printables-1793043-nexgen-pro-v2/Case/pro-v2-usb-cover-multi-material.3mf");

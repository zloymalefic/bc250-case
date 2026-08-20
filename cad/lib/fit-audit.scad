// Shared axis-aligned envelope helpers for assembly-level fit checks.
// Bounds are [origin, size], in the global X/Y/Z coordinate system.

function bounds_min(bounds) = bounds[0];
function bounds_max(bounds) = bounds[0] + bounds[1];
function axis_gap(a, b, axis) = max(
    bounds_min(b)[axis] - bounds_max(a)[axis],
    bounds_min(a)[axis] - bounds_max(b)[axis]
);
function bounds_overlap(a, b) =
    axis_gap(a, b, 0) < 0 && axis_gap(a, b, 1) < 0 && axis_gap(a, b, 2) < 0;
function bounds_inside(inner, outer, clearance = 0) =
    min([for (axis = [0:2])
        bounds_min(inner)[axis] - bounds_min(outer)[axis]]) >= clearance &&
    min([for (axis = [0:2])
        bounds_max(outer)[axis] - bounds_max(inner)[axis]]) >= clearance;

module bounds_proxy(bounds, tint = [0.2, 0.6, 0.9, 0.25], clearance = 0) {
    color(tint)
        translate(bounds[0] - [clearance, clearance, clearance])
            cube(bounds[1] + [2 * clearance, 2 * clearance, 2 * clearance]);
}

module overlap_proxy(a, b, tint = [1, 0, 0, 0.9]) {
    color(tint)
        intersection() {
            translate(a[0]) cube(a[1]);
            translate(b[0]) cube(b[1]);
        }
}

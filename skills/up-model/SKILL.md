---
name: up-model
description: Audit BC-250 visualization models against CAD sources and refresh only derived browser STL assets. Use for /up-model, $up-model, model synchronization, or viewer/CAD mismatch checks in this repository.
---

# Update visualization models

Run `tools/up-model` from the repository root.

Treat `cad/` and `cad-visualization/` as strictly read-only. Update only derived files under `visualization/assets/`. If a required source is absent, report its exact path and stop; do not fabricate a replacement.

After a successful update, verify that the viewer defaults to the horizontal rear cover and provide the local viewer link. Use `tools/up-model --check` for an audit without changes.

For layout validation, also enforce the mandatory interface rules in
`DESIGN-BRIEF.md`: no unintended geometry outside the enclosure envelope,
exact cover-to-seat and cutout correspondence, no unsupported/floating parts,
and explicit structural and airflow consideration for every occupied internal
volume. Report violations instead of masking them with viewer-only geometry.

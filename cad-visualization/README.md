# Visualization-only CAD sources

This directory contains non-printable geometry used only to prepare browser
rendering assets. Files here must not be treated as manufacturing models.

- `cad/` is the authoritative engineering CAD source.
- `cad-visualization/` contains visualization-only wrappers and decorative meshes.
- `visualization/assets/` contains generated render assets and is never authoritative.

The visualization agent treats both `cad/` and `cad-visualization/` as
read-only. Missing or incompatible source geometry must be reported instead of
being silently replaced or adjusted for appearance.

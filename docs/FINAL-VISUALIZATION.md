# Final model rendering and viewing plan

The project will provide three different representations because one file format cannot correctly serve engineering, printing, and presentation at the same time.

## 1. Engineering assembly

- Source: `cad/final-assembly.scad` or its final equivalent.
- Purpose: dimensional inspection, component visibility toggles, section views, and regeneration after parameter changes.
- Viewer: OpenSCAD, already installed on the development machine.

## 2. Printable parts

- Source: individual STL/3MF files under `cad/exports/`.
- Purpose: slicing, print orientation, support inspection, and per-part replacement.
- Viewer: OrcaSlicer or PrusaSlicer.
- Parts must not be forcibly merged merely to create one assembly file.

## 3. Presentation assembly

- Source scene: `visualization/bc250-case.blend`.
- Portable model: `visualization/bc250-case.glb`.
- Purpose: rotate and inspect the completed enclosure with colours, materials, panels, supports, button, and internal components in their assembled positions.
- Viewer: Blender or any offline/WebGL viewer supporting GLB.

## Required final views

- horizontal three-quarter front;
- horizontal rear and connector view;
- vertical three-quarter front;
- intake-panel close-up;
- front button and USB cassette close-up;
- rear Cisco and FlexATX variants;
- panels removed, showing tray, PSU, SSD, and ESP32;
- exploded assembly view;
- optional 360-degree turntable animation.

## Proposed workflow

1. Export each validated part individually from OpenSCAD.
2. Import parts into Blender without merging them.
3. Apply saved transforms from an assembly manifest.
4. Assign black body, coloured end rings, accent stripe, translucent button light pipe, metal PSU, and PCB materials.
5. Export the assembled scene as GLB.
6. Render still images and optional turntable animation.
7. Verify that the GLB opens independently and that every printable file remains available separately.

This work should begin only after the external geometry and major component locations are stable; otherwise visual transforms and material assignments would need to be repeatedly rebuilt.

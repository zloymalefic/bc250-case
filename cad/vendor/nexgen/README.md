# NexGen button asset

`pro-v2-steam-logo.stl` is a geometry-preserving conversion of:

`references/printables-1793043-nexgen-pro-v2/Power Button/pro-v2-steam-logo.3mf`

The conversion is required because OpenSCAD 2021 fails with a CGAL error when the original multi-material 3MF is imported into another compiled assembly. The STL retains all three connected mesh parts in their original coordinates; colour metadata is not retained.

The earlier transformed export was withdrawn during the assembly audit. This source asset remains pinned for a future button rebuild; a new release must preserve the three original colour objects and document its coordinate transform.

Source project: https://www.printables.com/model/1793043-nexgen3d-diy-steam-machine-pro-v2-liquid-cooled-bc/files

Author: NexGen-3D-Printing. License: CC BY-NC 4.0 as identified in the supplied Printables package. This converted file is not original geometry of the BC-250 + JF13K case project.

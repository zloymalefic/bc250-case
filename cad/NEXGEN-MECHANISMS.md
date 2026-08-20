# NexGen PRO V2 mechanisms adopted by this project

Only the mechanisms below are taken from the NexGen reference. Exterior styling remains based on Nyacom model 1737913.

## Rotatable power button

The supplied NexGen files separate the module into:

- mounting plate, measured raw envelope 44.54 × 31.59 × 5.10 mm;
- transparent rear/light-pipe section, 6.00 × 19.80 × 22.06 mm in its print orientation;
- removable Steam-emblem cap, 6.20 × 16.00 × 16.00 mm in its print orientation. The original `pro-v2-steam-logo.3mf` is imported directly and retains NexGen attribution.

The project recreation uses a 16 mm switch, two M3 fasteners, separate light pipe, and removable cap. The complete plate can be removed, rotated 90 degrees, and snapped back into the Nyacom-style front insert when the case orientation changes.

The logo remains a separate multi-material 3MF so its original three colour bodies are not destructively merged. Load `power-button-nexgen-v0.2.3mf` and `power-button-steam-logo-nexgen-v0.2.3mf` as parts of the same assembly in the slicer.

## Snap-fit access panels

Routine panels must use hidden hooks engaging the chassis perimeter, following the NexGen service concept. No decorative panel is retained by visible bolts. A concealed release notch is allowed; structural chassis joints may still use internal screws.

The exact hook thickness and interference will be selected with a small PETG/ASA calibration coupon because printer, material, and layer direction materially affect snap life.

## Universal internal PSU chassis

The supplied NexGen package contains separate server-PSU, FlexATX/FSP500, and Mean Well LOP mounts. This project recreates that strategy as a perforated internal rail with replaceable adapters for Cisco and FlexATX.

The major project-specific constraint is stricter: the rail, adapter, latch, PSU body, and cabling must remain inside the enclosure envelope. No PSU carrier may project through the coloured rear ring.

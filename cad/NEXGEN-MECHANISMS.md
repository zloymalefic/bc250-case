# NexGen PRO V2 mechanisms adopted by this project

Only the mechanisms below are taken from the NexGen reference. Exterior styling remains based on Nyacom model 1737913.

## Rotatable power button

The supplied NexGen files separate the module into:

- mounting plate, measured raw envelope 44.54 × 31.59 × 5.10 mm;
- transparent rear/light-pipe section, 6.00 × 19.80 × 22.06 mm in its print orientation;
- removable Steam-emblem cap, 6.20 × 16.00 × 16.00 mm in its print orientation. The original `pro-v2-steam-logo.3mf` is imported directly and retains NexGen attribution.

The project recreation uses a 16 mm switch, two M3 fasteners, separate light pipe, and removable cap. The complete plate can be removed, rotated 90 degrees, and snapped back into the Nyacom-style front insert when the case orientation changes.

The earlier standalone exports were withdrawn during the assembly audit. The rebuilt release will keep the light pipe and Bazzite cap as separate bodies generated from the master assembly.

## Dual 180-degree USB return

PRO V2 already specifies two black 180-degree USB adapters and includes `pro-v2-usb-cover-multi-material.3mf`. This is the baseline mechanism for routing rear BC-250 USB ports back into the enclosure. Redux is only a later implementation reference, not the source of this requirement.

The selected seller lists A-D variants with maximum stated dimensions of about
32 × 30 × 29 mm, 10 Gbit/s theoretical transfer, and 3 A current. Because the
dimension list does not map axes to variants reliably, the project uses that
maximum envelope with clearance and keeps the contact insert replaceable. See
`USB-RETURN-INTERFACE.md`.

## Magnetic access panels

Routine service panels use concealed 8 × 2 mm magnets and support shoulders. The side grilles additionally use a bottom pry notch and guide tongues so magnets carry pull-off load while printed geometry carries shear. Structural chassis joints and the load-bearing rear cover may still use internal M3 screws.

## Universal internal PSU chassis

The supplied NexGen package contains separate server-PSU, FlexATX/FSP500, and Mean Well LOP mounts. This project recreates that strategy as a perforated internal rail with replaceable adapters for Cisco and FlexATX.

The major project-specific constraint is stricter: the rail, adapter, latch, PSU body, and cabling must remain inside the enclosure envelope. No PSU carrier may project through the coloured rear ring.

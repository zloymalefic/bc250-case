# Peripheral bay feasibility and cassettes v0.1

## 2.5-inch storage

The current two-level architecture can accommodate a common 7 mm 2.5-inch SSD in a local section of the 12 mm backplate channel:

- supported provisional device envelope: 100 × 70 × 7 mm;
- open bridge cassette: 110 × 80 × 8.9 mm maximum;
- adjustable slots avoid claiming unverified drive-hole coordinates;
- the cassette is removable without changing the main chassis.

The cassette locally obstructs backplate airflow and must therefore be included in thermal testing. Devices 9.5 mm or 15 mm thick are not currently compatible; supporting them would require raising the board plane, moving the PSU, or increasing the enclosure.

## ESP32 relay controller

- provisional board envelope: 60 × 60 × 22 mm;
- separate 68 × 68 mm open-edge cassette;
- adjustable PCB-post slots;
- dedicated programming-USB opening;
- antenna edge remains open and must face the plastic front/side panel;
- intended location is the front lower pocket, outside the PSU envelope and away from its power wiring.

Final post positions, connector cut-outs, and cable restraints require measurement of the actual combined ESP32-WROOM dual-relay board.

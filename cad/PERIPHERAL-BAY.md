# Peripheral bay and cassettes v0.2

## 2.5-inch storage

The active vertical architecture uses the free front pocket ahead of JF13K. The
drive stands in the Y-Z plane and slides out through the front service opening:

- supported device envelope: 100.5 × 69.9 × 15 mm maximum;
- compatible nominal thicknesses: 7, 9.5, 12.5 and 15 mm;
- open 110 × 80 × 2.4 mm bridge cassette;
- four elongated M3 slots on a 76.6 × 61.72 mm bottom pattern;
- two chassis guide walls, shallow retaining lips and a rear travel stop;
- one front-access M3 cassette screw, reached after removing the bolted front panel;
- the drive/cassette end at X=39.4 while JF13K starts at X=44.5.

The bay is outside the JF13K fan footprint and does not use the two-millimetre
PSU-to-board channel. SATA/power connector direction remains a final cable-route
check, but it does not change the cassette or body envelope.

## ESP32 relay controller

- provisional board envelope: 60 × 60 × 22 mm;
- separate 68 × 68 mm open-edge cassette;
- adjustable PCB-post slots;
- dedicated programming-USB opening;
- antenna edge remains open and faces the plastic intake side;
- horizontal position below JF13K, with 3.6 mm nominal vertical clearance;
- two bottom rails guide the cassette toward the intake side;
- a printed edge detent retains it without another screw;
- a 74 × 28 mm hidden service extension lets it slide out after the fan cover
  is removed.

The final fan-cover geometry must include a lower skirt over this service
extension down to Z=4 mm. Final post positions, connector cut-outs, and cable
restraints still require measurement of the actual combined ESP32-WROOM
dual-relay board; the adjustable cassette allows the main chassis work to
continue before that measurement.

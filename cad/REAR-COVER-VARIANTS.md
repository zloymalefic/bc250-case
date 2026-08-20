# Rear-cover variants v0.1

The active core has one rear interface and two interchangeable covers. This
keeps the enclosure itself unchanged when it is turned from horizontal use into
an Xbox Series X-like tower.

## Shared interface

- four M3 axes at Y = 30/125 mm and Z = 5/190 mm;
- four blind heat-set insert bosses integrated into the rear structural core;
- monolithic rear wall; final PSU and I/O cuts are made directly in each variant;
- two portrait inserts sit side-by-side inside that envelope: provisional
  openings 72 × 145 mm for board I/O and 48 × 145 mm for PSU;
- no PSU bracket or electrical connector projects outside the case envelope.

## Horizontal rear cover

The shallow 6 mm cover is flush with the case silhouette. It surrounds the
common service-cassette opening and uses four short countersunk M3 screws.

## Vertical rear/base cover

The case is rotated so its rear X+ face points down. The replacement cover is a
single red 44 mm-deep truncated-pyramid shell expanding continuously from the
155 × 195 mm rear face to a 185 × 225 mm desk footprint:

- the continuous 8 mm perimeter shell carries the enclosure load;
- the 38 mm-deep internal cavity remains open for HDMI/DP, power and USB plugs;
- two opposed side openings let cables leave without a sharp desk bend;
- the desk face has four 12 mm recesses for adhesive rubber or TPU pads;
- four bottom-access M3 screws retain the complete base.

The architecture follows the idea of DeepCool's 47.5 mm-tall Vertical Base 100
for CH160/CH170, scaled to this project's 155 × 195 mm case section. The 44 mm
depth is provisional until the longest real power/video connector is measured.

## Current validation status

This is an integrated source model, not a release STL. Before release:

1. Measure the longest connector body plus safe bend radius.
2. Print the fit coupon and select the actual M3 insert pilot.
3. Load-test the tapered perimeter shell with the assembled case mass.
4. Replace the blank service-cassette envelope with measured Cisco PSU and
   BC-250 I/O inserts.

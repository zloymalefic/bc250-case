# Nyacom structural and airflow adaptation

Primary reference: Printables model 1737913, local archive in
`references/printables-1737913-nyacom-flex/`.

## Source principles retained

- The enclosure halves are structural frames, not empty skins populated by
  isolated fastener posts.
- The BC-250 and PSU slide into continuous guides and shelves.
- Screw reactions return into a perimeter wall, rail or equipment face.
- The PSU rear face is fixed directly and remains open for its own airflow.
- Cooling is pressure-driven: the large side fan feeds the heatsink, PSU intake
  is kept distinct, and later Nyacom revisions add backplate ventilation.

## Project-specific implementation

- Two continuous longitudinal shelves join all eight board-spine bosses to the
  shell above and below the Cisco PSU envelope.
- A 10 mm rear perimeter frame joins all four rear-cover bosses.
- Both rear-cover variants expose the 110 x 46.34 mm universal PSU adapter face.
- Segmented exhaust slots on the side opposite the JF13K sit above the PSU and
  preserve vertical and longitudinal structural webs.
- The JF13K-side split intake remains the dominant inlet. The opposite upper
  slots and PSU rear aperture are outlets; they must not be populated with
  unfiltered intake fans.

## Validation still required

- Smoke-test the assembled airflow path and log JF13K inlet, BC-250 backplate
  and PSU exhaust temperatures.
- Confirm the selected Cisco adapter does not reduce the rear free area below
  its native outlet area.
- Check every new shelf against physical connector and cable keepouts before a
  print release.
- Structural and airflow changes must be reviewed together: openings require
  remaining load paths on every side.

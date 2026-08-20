# Integrated packaging check 01

The first combined assembly includes:

- front and rear structural shell sections;
- front and rear BC-250 tray sections;
- universal internal rail with provisional Cisco PSU envelope;
- BC-250 proxy envelope.

The combined check required raising the board plane from the earlier 55 mm study to Z=65 mm. The current universal PSU assembly reaches Z=53 mm, so the revised placement restores the required 12 mm PSU-to-board/backplate channel.

With the conservative JF13K stack, the cooler reaches Z=166.6 mm. The 195 mm body therefore retains 28.4 mm for the snap-fit intake panel, structural radiator supports, vibration clearance, and manufacturing tolerance.

These values are internally consistent but still depend on provisional Cisco PSU and installed-JF13K envelopes. Physical measurements remain mandatory before production printing.

The integrated view is distributed as native OpenSCAD source rather than a merged 3MF. The assembly intentionally contains separate, overlapping joints and service parts; forcing them into one mesh would create a misleading non-manifold export. Individual printable components remain available as validated STL/3MF files.

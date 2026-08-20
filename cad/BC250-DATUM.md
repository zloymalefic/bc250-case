# BC-250 mechanical datum v0.1

## Source handling

The locally supplied Printables 1341336 package contains STEP, STL, and a
two-page PDF. Its Standard Digital File License prohibits redistribution,
hosting, and derivatives. None of those files is committed to this repository,
and production CAD does not import or link the restricted geometry.

The model is used only as a local dimensional cross-check. Publishable geometry
is constructed independently from factual dimensions and the already supplied
Public Domain AN600 and MK7 adapter models.

## Locally verified factual envelope

The supplied assembly contains six named solids: board, two mount plates,
radiator, memory radiator, and power adapter.

| Item | Envelope |
|---|---:|
| Bare PCB | 308.0 × 144.3 × 1.6 mm |
| Complete supplied stock assembly | 341.55 × 144.3 × 32.1 mm |

The 341.55 mm length must not define the JF13K case. It includes stock cooling
and mounting parts that are removed or replaced. The power-adapter projection
still requires a dedicated keepout check at the rear of the final carrier.

## Open-reference cross-check

The Public Domain AN600 and MK7 adapters both show an outer 96 × 96 mm hole
square. Their inner cooler-bar patterns differ, so only the outer square is a
strong candidate for the BC-250-side interface. No JF13K hole is frozen until
the actual Intel bars or a physical fit-check confirm it.

## Implemented consequence

`board-spine-v0.1.scad` replaces the former generic horizontal tray study:

- real bare-PCB envelope: 308.0 × 144.3 × 1.6 mm;
- vertical open-centre perimeter spine;
- 0.40 mm provisional pocket clearance per edge;
- split into two printable 168 × 152.3 × 8 mm nominal sections;
- eight transverse M4 chassis points;
- open backplate and rear-component airflow area.

PCB retention clamps remain intentionally unfinished. Their safe positions
depend on a real-board edge-component keepout inspection.

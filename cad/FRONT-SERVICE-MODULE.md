# Front service module v0.1

The yellow Nyacom-style front insert is now independent from both service components:

- front panel: full 155 × 195 × 12 mm sculpted end cap derived from the Nyacom source mesh, scaled only in its face plane to match this enclosure;
- NexGen-derived button opening: 45.2 × 32.3 mm;
- replaceable vertical USB cassette opening: 28.6 × 71.0 mm;
- cassette face: 27.93 × 70.35 × 3 mm;
- baseline hub: Anker A7516 four-port USB 3.0, 103 × 30 × 10 mm;
- front apertures: four vertical USB-A data ports;
- four front-access countersunk M3 screws retain the main panel on its support shoulder;
- the small USB cassette can be serviced after the four front-panel screws are removed;
- authoritative shape source: `references/printables-1737913-nyacom-flex/body-front-panel.stl`;
- the NexGen 44.5 × 31.6 mm mounting plate is fastened exclusively against the
  inside face; only the light pipe/pusher and logo cap pass through to the
  exterior. A separate extension accounts for the 12 mm cap thickness.
- concealed release notches permit servicing without visible screws.
- two M3 insert bosses and edge ribs retain the NexGen-derived button plate.

NexGen PRO V2 explicitly specifies the Anker four-port hub and its supplied USB
cover measures approximately 70.35 × 27.93 × 12.65 mm. This is the current
baseline. If a cheaper hub is selected later, only the small cassette is
reworked; the 28.6 × 71.0 mm front-panel interface and its receiver rails remain
unchanged wherever possible.

The rear USB return is now specified independently in `USB-RETURN-INTERFACE.md`.
Its provisional per-adapter envelope is 32 × 30 × 29 mm plus clearance; only a
small contact insert depends on the delivered A/D variant.

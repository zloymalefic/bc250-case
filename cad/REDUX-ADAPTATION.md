# NexGen3D Steam Machine REDUX — adaptation notes

Source: [Printables model 1649679](https://www.printables.com/model/1649679-nexgen3d-diy-steam-machine-redux-edition), archive downloaded 2026-08-20.

Redux is not a dimensional donor for the Nyacom exterior. It is used for service mechanisms and modular interfaces.

## Dual 180-degree USB routing hood

- Reference part: `redux-optional-usb-cover.3mf`.
- Raw mesh envelope: approximately 12.65 × 70.35 × 32.58 mm.
- It protects two 180-degree USB 3.0 adapters that loop rear BC-250 ports back into the enclosure.
- Adapter direction is critical. Redux documentation specifies the black version and warns that the blue version connects in the opposite direction.
- Our hood will be redrawn against measured BC-250 ports and exact adapters; Redux geometry will not be copied into the Nyacom shell.
- It must not obstruct video output, exhaust, PSU removal, or either support orientation.

This mechanism may replace the earlier single angled-adapter pocket if two suitable adapters are confirmed.

## Bazzite power-button cap

- Redux V4.2.1 uses a two-piece cover: a translucent rear body carries ring-LED light and the visible cap rotates by 90 degrees.
- Editable `blank-button.step` and `blank-faceplate.step` are included.
- Our button retains the rotatable architecture and gains a separate Bazzite-logo cap.
- The cap remains independent from the switch body so orientation changes require no rewiring.
- Exact Bazzite artwork and permitted trademark treatment must be sourced before release.

## Principles selected for development

- one rear structure with PSU-specific brackets;
- replaceable faceplates with improved snap tabs;
- split large covers with small joiners for 220 mm beds;
- heat-set inserts in structural joints;
- cable tie points around fans and the rear service area;
- a removable storage caddy with a defined chassis receiver.

## Not adopted directly

- Redux proportions and hex styling; Nyacom remains the exterior reference;
- Redux PSU dimensions; the Cisco latch and connector remain unmeasured;
- its dual 120 mm fan stack; our cooler remains JIUSHARK JF13K;
- its latching-switch electrical scheme; this project uses the ESP32 remote-control architecture.

Redux specifies 16 M3 inserts described as `M3 × 3.5 × 4.6 × 6` and 16 M3×10 flat-head socket screws. These quantities belong to Redux, not our BOM, but are candidates for later standardisation.


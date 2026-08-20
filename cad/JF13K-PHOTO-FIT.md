# JF13K photo fit check

## Result

The supplied photographs are sufficient to freeze the cooler envelope for the
case layout. They are not sufficient to manufacture the cooler-to-APU adapter,
which remains a separate part supplied by the builder.

The case model now uses a **241 × 92 × 121 mm** JF13K envelope in its own
coordinate system: 241 mm along the board, 92 mm away from the PCB, and 121 mm
across the board height.

With the 308.0 × 144.3 × 1.6 mm bare-PCB datum, centring this envelope gives:

| Check | Model result |
|---|---:|
| Cooler margin at each 308 mm board end | 33.5 mm |
| Cooler margin across the 144.3 mm board | 11.65 mm each side |
| Cooler top to nominal body-side datum | 9.4 mm |
| Temporarily enforced core-layout allowance | 6.0 mm |

Therefore the present 330 × 155 × 195 mm body does not need to become wider.
The covers directly above the two fans are separate snap-in components. Their
final height and inner relief are deliberately deferred, so the 9.4 mm value is
a body-layout datum rather than a frozen cover clearance. Those covers may be
locally raised if airflow or fan-screw clearance requires it.

## Evidence and confidence

- JIUSHARK's official product page specifies 241 × 121 × 92 mm and 895 g for
  JF13K: <https://www.jiushark.com/products/jf13k.html>.
- The local licensed board model gives the factual bare-PCB envelope of
  308.0 × 144.3 × 1.6 mm; the source geometry itself is not redistributed.
- The near-side photographs show the PCB plane and the fan top in one view.
  Their proportion agrees with the official 92 mm installed height; there is no
  evidence of a further large adapter-height addition.
- The near-top photograph shows the cooler inside the PCB ends and approximately
  centred across the board. The computed 33.5 mm and 11.65 mm margins match that
  observation.

Photo perspective, lens distortion, and the absence of a ruler make sub-mm
measurement impossible. For that reason photographs are used only to establish
orientation and validate the official envelope. The temporary CAD assertion
preserves at least 6 mm at the core-layout stage; the separate cover geometry
must repeat its own no-contact and airflow checks when it is finalized.

## Structural consequence

JF13K weighs 895 g. The removable intake panel must never carry or locate it.
The cooler remains attached to its APU adapter, while transport loads must pass
through the board spine/cooler support into the structural core. Final support
pad positions still require a harmless contact-zone check against the physical
radiator; this does not affect the outer case envelope.

## Remaining physical checks before printing the final case

Only three local checks remain useful; none changes the body size:

1. Verify that no fan screw or cable rises more than 3 mm above the nominal fan
   frame.
2. Route and tie the fan leads so they cannot enter either fan or cross the
   6 mm protected panel gap.
3. Check the longest studs/backplate projection on the PSU side before freezing
   the board-spine clamps.

4. Before releasing the two separate fan covers, verify their lowest internal
   point against the real spinning fan frames and preserve a visible safety gap.

The original seven-measurement guide is retained as an optional final sanity
check, not as a blocker for continuing the case CAD.

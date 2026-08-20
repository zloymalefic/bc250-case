# BC-250 heatsink mount comparison

## Compared models

| Property | DeepCool AN600 adapter | Sean MK7 mount |
|---|---:|---:|
| Source model | Printables 1707972 | Printables 1217021 |
| Intended cooler | DeepCool AN600 Intel bars | PCCOOLER RZ620 Intel clip bracket |
| STL envelope | 105 × 105 × 8 mm | 105.56 × 104.39 × 8 mm |
| STL volume | 20,382 mm³ | 36,497 mm³ |
| Mesh | 1 closed part, 17,868 facets | 1 closed part, 9,016 facets |
| Author fastener note | 4× M3×12, 4× M3×20, 8× M3 nuts | M4 from below, self-tapped or through with top nuts; mixes cooler and stock hardware |
| License in supplied PDF | Public Domain | Public Domain |

## Conclusion for this case

The MK7 STL is not a revised JF13K mount and must not replace the AN600 adapter
unchanged. It is designed around the much taller PCCOOLER RZ620 and a different
Intel clip system. Its value is that it is a second, independent model of the
same BC-250 heatsink area with an almost identical 105 mm square outer envelope.

The following features should be carried into the project fit-check:

- use the MK7 underside as a second reference for the BC-250 stock-heatsink
  footprint and obstruction relief;
- compare both models' board-side contact surfaces and hole centres before
  freezing the JF13K adapter;
- test M3 and M4 strategies rather than assuming the AN600 M3 hardware is the
  only workable solution;
- keep the adapter separate from the structural JF13K transport supports: the
  adapter controls APU clamping while the chassis supports the 895 g radiator.

No hole coordinates are copied into production CAD yet. The two source STLs do
not prove that JF13K's Intel bars match either model, and the real assembled
cooler must still be measured.

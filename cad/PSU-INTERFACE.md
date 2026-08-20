# Fully internal universal PSU interface v0.2

The NexGen PRO V2 and Redux packages use a common 110 × 46.34 mm face for
server-PSU, FlexATX, and Mean Well adapter plates. Their raw plate depths are
21.5, 7.2, and 11.3 mm. This project recreates that interchangeable interface
inside the shell; no Cisco body measurement is required to design the receiver.

- common internal receiver: 24.85 × 118 × 54.34 mm;
- receiver supports adapter plates up to 21.5 mm deep;
- rear stop plane is X=318 mm while the exterior shell ends at X=330 mm;
- two removable interior clamp bars retain the selected adapter;
- server, FlexATX, and LOP mounts use the same receiver;
- only a flush rear connector/exhaust panel is visible from outside;
- the PSU-specific mount may be revised from the supplied NexGen adapter, but
  every feature must remain at or in front of X=318 mm.

`psu-universal-internal-v0.2.scad` is a printable receiver and clamp study. The
actual server-PSU adapter plate can be adapted from NexGen without changing the
case, rear cover, or receiver.

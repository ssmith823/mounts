# TRMNL Laptop Back Mount — "Breadcrumbs"

Magnetic mount for attaching a TRMNL OG 7.5" e-ink display to the back of a MacBook Pro 14" lid. Designed for the [Breadcrumbs thesis project](https://github.com/ssmith823/mounts) — reducing activation energy for starting conversations in public spaces.

## Concept

A slim bezel/tray that holds the TRMNL display, attaching to the MacBook lid via neodymium magnets. The display content (conversation starters) faces outward when the laptop is open.

## Dimensions

### TRMNL OG (from official STLs)
| Component | Width (mm) | Height (mm) | Depth (mm) |
|-----------|-----------|-------------|------------|
| E-paper display (EPD) | 170.0 | 113.8 | 7.7 |
| PCB assembly | 65.2 | 24.2 | 8.1 |
| Standard battery | 60.0 | 31.0 | 8.0 |
| Large battery | 59.0 | 36.0 | 9.0 |

**Total assembled thickness estimate:** ~16-18mm (display + PCB + battery stacked)

### MacBook Pro 14" (M3 Max)
| Dimension | Value |
|-----------|-------|
| Width | 312.6 mm |
| Depth | 221.2 mm |
| Thickness (closed) | 15.5 mm |
| Lid (aluminum, estimated) | ~2-3 mm |

### Lid usable area (estimated)
The Apple logo is roughly centered. Usable area for mounting (avoiding logo, hinges, edges):
- ~280 × 190 mm safe zone
- TRMNL at 170 × 114 fits comfortably with margins

## Design V1: Magnetic Bezel Mount

### Features
- Thin frame (2.5mm walls) with inner lip to hold TRMNL
- Display window cutout exposing the e-ink screen
- 6× neodymium magnets (8mm × 3mm disc) press-fit into recesses on the back
- Slide-in from one side, friction + magnets hold it
- Matte black PLA or PETG

### Print Settings (Bambu Labs)
- Layer height: 0.16mm (for smooth finish)
- Infill: 15-20% grid
- Walls: 3
- Material: PLA (prototype), PETG (final)
- Supports: none needed (flat design)
- Estimated print time: ~1.5-2 hours

## Hardware Needed
- 6× neodymium disc magnets, 8mm × 3mm (N52 preferred)
- Optional: thin adhesive foam pads for cushioning

## Files
- `breadcrumbs_mount_v1.scad` — parametric OpenSCAD source
- `stl/breadcrumbs_mount_v1.stl` — ready-to-print STL (after export)

## Status
- [x] Fork repo & gather dimensions
- [ ] V1 parametric model
- [ ] Test print & fit check
- [ ] V2 refinements
- [ ] Final version
- [ ] PR back to usetrmnl/mounts

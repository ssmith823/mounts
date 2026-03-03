#!/usr/bin/env python3
"""
Breadcrumbs Mount V1 — Magnetic Bezel for TRMNL OG on MacBook Pro 14"
Parametric design using CadQuery.

Usage:
  python3 breadcrumbs_mount_v1.py  # generates STL in stl/ directory
"""

import cadquery as cq

# =============================================================================
# PARAMETERS — Adjust these to tune the fit
# =============================================================================

# TRMNL OG dimensions (from official STLs)
TRMNL_WIDTH = 170.0       # mm (X) - e-paper display width
TRMNL_HEIGHT = 113.8      # mm (Y) - e-paper display height
TRMNL_DEPTH = 18.0        # mm (Z) - total assembled thickness estimate
                            #   (display 7.7 + PCB 8.1 + battery overlap)

# Display active area (slightly smaller than EPD board)
SCREEN_WIDTH = 163.0       # mm - visible e-ink area (estimated)
SCREEN_HEIGHT = 98.0       # mm - visible e-ink area (estimated)

# Frame parameters
WALL_THICKNESS = 2.5       # mm - frame wall thickness
LIP_DEPTH = 2.0           # mm - inner lip that holds the TRMNL
LIP_HEIGHT = 1.5          # mm - how far lip extends over device edge
CORNER_RADIUS = 3.0        # mm - rounded corners
TOLERANCE = 0.4            # mm - clearance for snug fit (per side)

# Magnet recesses (for 8mm × 3mm neodymium disc magnets)
MAGNET_DIAMETER = 8.0      # mm
MAGNET_DEPTH = 3.2         # mm (slightly deeper than magnet for flush fit)
MAGNET_COUNT_X = 3         # magnets along width (top/bottom rows)
MAGNET_MARGIN = 15.0       # mm from outer edge to magnet center

# Slide-in slot (open on one short side for inserting the TRMNL)
SLIDE_IN = True            # True = open bottom edge for slide-in
SLIDE_CHAMFER = 1.0        # mm - entry chamfer for easy insertion

# =============================================================================
# DERIVED DIMENSIONS
# =============================================================================

# Inner pocket dimensions (TRMNL + tolerance)
pocket_w = TRMNL_WIDTH + 2 * TOLERANCE
pocket_h = TRMNL_HEIGHT + 2 * TOLERANCE
pocket_d = TRMNL_DEPTH  # full depth pocket

# Outer frame dimensions
frame_w = pocket_w + 2 * WALL_THICKNESS
frame_h = pocket_h + 2 * WALL_THICKNESS
frame_d = pocket_d + LIP_HEIGHT  # total thickness: pocket + lip overlap on top

# Back plate thickness (base that sits against laptop lid)
BACK_THICKNESS = 1.5  # mm

# =============================================================================
# BUILD THE MODEL
# =============================================================================

def make_mount():
    # --- Outer shell ---
    # Rounded rectangle outer body
    outer = (
        cq.Workplane("XY")
        .box(frame_w, frame_h, frame_d, centered=(True, True, False))
        .edges("|Z")
        .fillet(CORNER_RADIUS)
    )
    
    # --- Inner pocket (cut from top, leaving back plate) ---
    pocket = (
        cq.Workplane("XY")
        .workplane(offset=BACK_THICKNESS)
        .box(pocket_w, pocket_h, pocket_d + LIP_HEIGHT + 1, centered=(True, True, False))
    )
    mount = outer - pocket
    
    # --- Screen window (cut through back plate so display is visible) ---
    window = (
        cq.Workplane("XY")
        .box(SCREEN_WIDTH, SCREEN_HEIGHT, BACK_THICKNESS + 2, centered=(True, True, False))
        .translate((0, 0, -1))
    )
    mount = mount - window
    
    # --- Inner lip (retaining ledge around the top opening) ---
    # The lip is the remaining material after the pocket cut — the walls 
    # extend above the pocket bottom by LIP_HEIGHT, creating a ledge.
    # This is already handled by making frame_d = pocket_d + LIP_HEIGHT
    # and cutting the pocket starting from BACK_THICKNESS.
    
    # --- Magnet recesses (on the back/bottom face) ---
    # Place magnets in a grid pattern on the back surface
    magnet_positions = []
    
    # Calculate X positions for magnets
    x_positions = []
    if MAGNET_COUNT_X == 1:
        x_positions = [0]
    else:
        x_start = -(frame_w / 2 - MAGNET_MARGIN)
        x_end = frame_w / 2 - MAGNET_MARGIN
        x_step = (x_end - x_start) / (MAGNET_COUNT_X - 1)
        x_positions = [x_start + i * x_step for i in range(MAGNET_COUNT_X)]
    
    # Two rows: top and bottom of frame
    y_top = frame_h / 2 - MAGNET_MARGIN
    y_bottom = -(frame_h / 2 - MAGNET_MARGIN)
    
    for x in x_positions:
        magnet_positions.append((x, y_top))
        magnet_positions.append((x, y_bottom))
    
    # Cut magnet pockets from bottom face
    for (mx, my) in magnet_positions:
        magnet_hole = (
            cq.Workplane("XY")
            .workplane(offset=-0.01)  # slightly below bottom face
            .center(mx, my)
            .circle(MAGNET_DIAMETER / 2)
            .extrude(MAGNET_DEPTH + 0.01)
        )
        mount = mount - magnet_hole
    
    # --- Slide-in slot (open one short edge) ---
    if SLIDE_IN:
        # Remove the bottom wall entirely for slide-in insertion
        slot_cut = (
            cq.Workplane("XY")
            .workplane(offset=BACK_THICKNESS)
            .center(0, -(frame_h / 2))
            .box(pocket_w, WALL_THICKNESS + 2, pocket_d + LIP_HEIGHT + 1, 
                 centered=(True, False, False))
            .translate((0, -1, 0))
        )
        mount = mount - slot_cut
    
    # --- Chamfer top edges for a polished look ---
    try:
        mount = mount.edges(">Z").chamfer(0.5)
    except Exception:
        pass  # Skip if chamfer fails on complex geometry
    
    return mount


def main():
    import os
    
    print("Building Breadcrumbs Mount V1...")
    print(f"  TRMNL pocket: {pocket_w:.1f} × {pocket_h:.1f} × {pocket_d:.1f} mm")
    print(f"  Outer frame:  {frame_w:.1f} × {frame_h:.1f} × {frame_d:.1f} mm")
    print(f"  Screen window: {SCREEN_WIDTH:.1f} × {SCREEN_HEIGHT:.1f} mm")
    print(f"  Magnets: {MAGNET_COUNT_X * 2}× ⌀{MAGNET_DIAMETER}×{MAGNET_DEPTH}mm")
    print(f"  Slide-in: {'bottom edge open' if SLIDE_IN else 'fully enclosed'}")
    
    mount = make_mount()
    
    stl_dir = os.path.join(os.path.dirname(__file__), "stl")
    os.makedirs(stl_dir, exist_ok=True)
    stl_path = os.path.join(stl_dir, "breadcrumbs_mount_v1.stl")
    
    cq.exporters.export(mount, stl_path)
    
    step_path = os.path.join(stl_dir, "breadcrumbs_mount_v1.step")
    cq.exporters.export(mount, step_path)
    
    print(f"\n  ✅ STL exported: {stl_path}")
    print(f"  ✅ STEP exported: {step_path}")
    print(f"\nOpen the STEP file in Bambu Studio or any slicer to preview.")


if __name__ == "__main__":
    main()

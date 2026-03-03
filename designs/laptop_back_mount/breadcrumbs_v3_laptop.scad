// =============================================================================
// Breadcrumbs V3 — Laptop Mount (based on TRMNL thin wall frame)
//
// Takes the minimal-bezel wall frame and adapts for MacBook Pro 14" lid:
// - Original frame geometry preserved (proven TRMNL fit)
// - Magnet pockets in top/bottom rails (thick enough for 8mm magnets)
// - Side rails get small 5mm magnets (fits in 2.75mm wall width)
// - No back plate — MacBook lid IS the back
// - Open front — screen faces outward toward people
//
// Frame: 175.7 x 13.0 x 116.7mm, ~2.75mm side bezels, ~1.5mm top/bottom
// =============================================================================

// --- MAGNET PARAMETERS -------------------------------------------------------

// Large magnets for top/bottom rails (rails are 13mm deep, plenty of room)
mag_lg_dia   = 8.2;      // mm diameter
mag_lg_depth = 3.2;      // mm pocket depth

// Small magnets for side rails (rails are only ~2.75mm wide)
// Using 4mm x 2mm disc magnets — fit within the side wall
mag_sm_dia   = 4.2;      // mm diameter  
mag_sm_depth = 2.2;      // mm pocket depth

// --- FRAME GEOMETRY (from STL analysis) --------------------------------------
// X: -87.85 to 87.85 (width 175.7mm)  
// Y: -6.50 to 6.50   (depth 13.0mm)   ← Y is depth (back to front)
// Z: -58.35 to 58.35  (height 116.7mm)
// Back face at Y = -6.50 (sits against laptop lid)

back_y = -6.50;

// Side rail centers (2.75mm walls)
left_x  = -87.85 + 1.375;
right_x =  87.85 - 1.375;

// Side rail magnet Z positions (upper/lower third)
side_z_hi =  35.0;
side_z_lo = -35.0;

// Top/bottom rail magnet positions
// Top rail is thicker in the original design (~13mm wide strip at top)
// Place 2 magnets spread across top, 2 across bottom
top_z = 58.35 - 0.75;    // center of top rail thickness
bot_z = -58.35 + 0.75;   // center of bottom rail thickness

top_x_left  = -50.0;     // spread magnets for better grip
top_x_right =  50.0;

// --- BUILD -------------------------------------------------------------------

module mag_pocket_large() {
    cylinder(d=mag_lg_dia, h=mag_lg_depth + 0.1, $fn=48);
}

module mag_pocket_small() {
    cylinder(d=mag_sm_dia, h=mag_sm_depth + 0.1, $fn=48);
}

difference() {
    // Original thin wall frame
    import("/Users/ryu/Developer/mounts/designs/laptop_back_mount/reference/thin_frame.stl");
    
    // === TOP RAIL magnets (2x large, from back face) ===
    translate([top_x_left, back_y - 0.05, top_z])
        rotate([-90, 0, 0])
            mag_pocket_large();
    
    translate([top_x_right, back_y - 0.05, top_z])
        rotate([-90, 0, 0])
            mag_pocket_large();
    
    // === BOTTOM RAIL magnets (2x large, from back face) ===
    translate([top_x_left, back_y - 0.05, bot_z])
        rotate([-90, 0, 0])
            mag_pocket_large();
    
    translate([top_x_right, back_y - 0.05, bot_z])
        rotate([-90, 0, 0])
            mag_pocket_large();
    
    // === LEFT RAIL magnets (2x small, from back face) ===
    translate([left_x, back_y - 0.05, side_z_hi])
        rotate([-90, 0, 0])
            mag_pocket_small();
    
    translate([left_x, back_y - 0.05, side_z_lo])
        rotate([-90, 0, 0])
            mag_pocket_small();
    
    // === RIGHT RAIL magnets (2x small, from back face) ===
    translate([right_x, back_y - 0.05, side_z_hi])
        rotate([-90, 0, 0])
            mag_pocket_small();
    
    translate([right_x, back_y - 0.05, side_z_lo])
        rotate([-90, 0, 0])
            mag_pocket_small();
}

echo("=== Breadcrumbs V3 - Laptop Mount ===");
echo(str("Base: thin wall frame 175.7 x 13.0 x 116.7mm"));
echo(str("Top/Bottom: 4x ⌀", mag_lg_dia, " x ", mag_lg_depth, "mm magnets"));
echo(str("Sides: 4x ⌀", mag_sm_dia, " x ", mag_sm_depth, "mm magnets"));
echo(str("Total: 8 magnets"));
echo(str("Added laptop thickness: 13mm"));

// =============================================================================
// Breadcrumbs Mount V2 — Open-back Magnetic Frame for TRMNL OG on MacBook Pro
// Based on TRMNL official fridge_mount design, adapted for laptop lid mounting
//
// CONCEPT: Same as fridge mount — open-back frame, magnets hold it to surface.
// The MacBook lid IS the back plate. TRMNL slides in, screen faces outward.
// No back plate = flush against lid, minimal added thickness.
//
// CHANGES FROM FRIDGE MOUNT:
// - Thinner walls (laptop aesthetic vs fridge utility)
// - Smaller magnets (8mm disc vs 5/8" disc — laptop lid is thin aluminum)
// - Added front lip to prevent TRMNL sliding out when lid tilts
// - Bottom shelf optional (magnets + lip may be enough)
// =============================================================================

// --- PARAMETERS --------------------------------------------------------------

// TRMNL OG enclosure (from Gadgeteer review + Waveshare EPD spec)
trmnl_w = 171.0;         // mm - width
trmnl_h = 116.0;         // mm - height
trmnl_d = 10.0;          // mm - thickness

// Fit clearance
tol = 0.3;               // mm per side (tight fit, laptop won't be slammed)

// Frame walls
wall = 3.5;              // mm - side rail thickness (must be > mag_depth)
rail_depth = trmnl_d + tol; // mm - how deep the rails are (matches device thickness)

// Front lip (prevents device sliding out when lid is tilted)
lip = 1.2;               // mm - lip overlap on screen side
lip_height = rail_depth;  // full depth lip

// Bottom shelf
shelf = true;             // bottom connecting rail
shelf_width = 6.0;        // mm - shelf depth (narrow, just structural)

// Top rail  
top_rail = true;          // top connecting rail (with lip)
top_rail_width = 6.0;     // mm

// Magnets (8mm × 3mm neodymium discs, recessed into back of rails)
mag_dia = 8.2;            // mm (slightly oversized for press-fit)
mag_depth = 3.2;          // mm
// Magnet positions: 2 per side rail + 1 on bottom shelf = 5 total
// (can add more if grip is insufficient)

// Corner radius
corner_r = 2.0;           // mm

// --- DERIVED -----------------------------------------------------------------

inner_w = trmnl_w + 2 * tol;
inner_h = trmnl_h + 2 * tol;
outer_w = inner_w + 2 * wall;
outer_h = inner_h + (shelf ? wall : 0) + (top_rail ? wall : 0);

// --- MODULES -----------------------------------------------------------------

module magnet_recess() {
    // Cut from the back face (Z=0 side, against laptop lid)
    cylinder(d=mag_dia, h=mag_depth + 0.1, $fn=48);
}

module side_rail(h) {
    // A single vertical rail
    cube([wall, h, rail_depth]);
}

// --- MAIN MODEL --------------------------------------------------------------

module breadcrumbs_v2() {
    difference() {
        union() {
            // === LEFT RAIL ===
            translate([0, shelf ? wall : 0, 0])
                cube([wall, inner_h, rail_depth]);
            
            // === RIGHT RAIL ===
            translate([wall + inner_w, shelf ? wall : 0, 0])
                cube([wall, inner_h, rail_depth]);
            
            // === BOTTOM SHELF ===
            if (shelf) {
                cube([outer_w, wall, rail_depth]);
                // Extended shelf floor (thin ledge inside for TRMNL to rest on)
                translate([wall, 0, 0])
                    cube([inner_w, shelf_width, wall]);  // thin floor
            }
            
            // === TOP RAIL ===
            if (top_rail) {
                translate([0, (shelf ? wall : 0) + inner_h, 0])
                    cube([outer_w, wall, rail_depth]);
            }
            
            // === FRONT LIPS (screen side, Z = rail_depth) ===
            // Left lip
            translate([wall - lip, shelf ? wall : 0, rail_depth - lip])
                cube([lip, inner_h, lip]);
            
            // Right lip
            translate([wall + inner_w, shelf ? wall : 0, rail_depth - lip])
                cube([lip, inner_h, lip]);
            
            // Top lip
            if (top_rail) {
                translate([wall, (shelf ? wall : 0) + inner_h - lip, rail_depth - lip])
                    cube([inner_w, lip + wall, lip]);
            }
            
            // Bottom lip
            if (shelf) {
                translate([wall, 0, rail_depth - lip])
                    cube([inner_w, lip, lip]);
            }
        }
        
        // === MAGNET RECESSES ===
        // Left rail: 2 magnets
        translate([wall/2, (shelf ? wall : 0) + inner_h * 0.25, -0.05])
            magnet_recess();
        translate([wall/2, (shelf ? wall : 0) + inner_h * 0.75, -0.05])
            magnet_recess();
        
        // Right rail: 2 magnets
        translate([wall + inner_w + wall/2, (shelf ? wall : 0) + inner_h * 0.25, -0.05])
            magnet_recess();
        translate([wall + inner_w + wall/2, (shelf ? wall : 0) + inner_h * 0.75, -0.05])
            magnet_recess();
        
        // Bottom shelf: 1 magnet center
        if (shelf) {
            translate([outer_w/2, wall/2, -0.05])
                magnet_recess();
        }
        
        // Top rail: 1 magnet center  
        if (top_rail) {
            translate([outer_w/2, (shelf ? wall : 0) + inner_h + wall/2, -0.05])
                magnet_recess();
        }
    }
}

// --- INFO --------------------------------------------------------------------

echo(str("=== Breadcrumbs V2 (Open-back Frame) ==="));
echo(str("Outer: ", outer_w, " × ", outer_h, " mm"));
echo(str("Inner pocket: ", inner_w, " × ", inner_h, " mm"));
echo(str("Rail depth: ", rail_depth, " mm (= device thickness)"));
echo(str("Added thickness to laptop: ", rail_depth, " mm"));
echo(str("Wall: ", wall, " mm, Lip: ", lip, " mm"));
num_magnets = 4 + (shelf ? 1 : 0) + (top_rail ? 1 : 0);
echo(str("Magnets: ", num_magnets, "× ⌀", mag_dia, "×", mag_depth, "mm"));

// --- RENDER ------------------------------------------------------------------

breadcrumbs_v2();

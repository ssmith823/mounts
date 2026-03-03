// =============================================================================
// Breadcrumbs Mount V1 — Magnetic Tray for TRMNL OG on MacBook Pro 14"
// Parametric OpenSCAD design
// 
// Thesis project: reducing activation energy for conversations in public spaces
// by mounting a TRMNL e-ink display on the back of a laptop lid.
//
// ORIENTATION: The TRMNL sits in a tray with the e-ink screen facing OUTWARD
// (toward other people). The solid back plate sits against the MacBook lid,
// held on by magnets. The front is open so the screen is fully visible.
//
// Instructions:
//   1. Open in OpenSCAD, adjust parameters in Customizer (right panel)
//   2. Preview (F5), Render (F6), Export STL (F7)
//   3. Print: 0.16mm layers, 15-20% infill, 3 walls, matte black PLA/PETG
// =============================================================================

// --- PARAMETERS (adjust these) -----------------------------------------------

// TRMNL OG device dimensions
// Sources: Gadgeteer review (171×116×10mm), Waveshare 7.5" EPD spec, official STLs
trmnl_width  = 171.0;    // mm - enclosure width
trmnl_height = 116.0;    // mm - enclosure height  
trmnl_depth  = 10.0;     // mm - enclosure thickness (Gadgeteer: 0.4" / 10mm)

// Frame construction
wall       = 2.5;        // mm - side wall thickness
lip        = 1.5;        // mm - front lip that holds TRMNL in (overlaps screen bezel)
back_thick = 1.5;        // mm - back plate thickness (against laptop lid)
tolerance  = 0.4;        // mm - clearance per side for easy fit
corner_r   = 3.0;        // mm - outer corner radius

// Magnets (neodymium disc, press-fit into back plate face)
mag_dia    = 8.0;        // mm - magnet diameter
mag_depth  = 3.2;        // mm - recess depth (slightly > magnet for flush)
mag_margin = 15.0;       // mm - magnet center distance from outer edge
mag_cols   = 3;          // magnets per row (top & bottom rows = 6 total)

// Slide-in opening (one short edge open for inserting TRMNL)
slide_in = true;

// --- DERIVED DIMENSIONS (don't edit) -----------------------------------------

// Inner pocket (TRMNL + clearance)
pocket_w = trmnl_width + 2 * tolerance;
pocket_h = trmnl_height + 2 * tolerance;
pocket_d = trmnl_depth + tolerance;  // depth clearance too

// Outer frame
frame_w = pocket_w + 2 * wall;
frame_h = pocket_h + 2 * wall;
frame_d = back_thick + pocket_d;     // back plate + device pocket

// Front lip inset (how far the lip covers the screen bezel edge)
lip_inset = lip;

// --- MODULES -----------------------------------------------------------------

module rounded_box(w, h, d, r) {
    // Rounded rectangle, centered XY, bottom at Z=0
    translate([0, 0, d/2])
        minkowski() {
            cube([w - 2*r, h - 2*r, d - 0.01], center=true);
            cylinder(r=r, h=0.01, $fn=48);
        }
}

module magnet_hole() {
    cylinder(d=mag_dia, h=mag_depth + 0.1, $fn=48);
}

// --- MAIN MODEL --------------------------------------------------------------

module breadcrumbs_mount_v1() {
    difference() {
        // === Outer body ===
        rounded_box(frame_w, frame_h, frame_d, corner_r);
        
        // === Device pocket ===
        // Cut from top (screen side), leaving back plate solid
        // The TRMNL drops in from the front, screen facing out
        translate([0, 0, back_thick + pocket_d/2 + 0.5])
            cube([pocket_w, pocket_h, pocket_d + 1], center=true);
        
        // === Front opening (screen visible) ===
        // Cut away the top face, but leave a lip around the edge
        // The lip holds the TRMNL in place (grips the bezel edges)
        translate([0, 0, back_thick + pocket_d/2 + 0.5])
            cube([pocket_w - 2*lip_inset, pocket_h - 2*lip_inset, pocket_d + 2], center=true);
        
        // === Magnet recesses (in back face, the laptop-lid side) ===
        for (col = [0 : mag_cols - 1]) {
            x = -frame_w/2 + mag_margin + col * (frame_w - 2*mag_margin) / max(mag_cols - 1, 1);
            
            // Top row
            translate([x, frame_h/2 - mag_margin, -0.05])
                magnet_hole();
            
            // Bottom row
            translate([x, -(frame_h/2 - mag_margin), -0.05])
                magnet_hole();
        }
        
        // === Slide-in slot (remove bottom short wall for insertion) ===
        if (slide_in) {
            translate([0, -(frame_h/2 + 0.5), back_thick + pocket_d/2 + 0.5])
                cube([pocket_w, wall + 1, pocket_d + 1], center=true);
        }
    }
}

// --- INFO --------------------------------------------------------------------

echo(str("=== Breadcrumbs Mount V1 ==="));
echo(str("Frame outer: ", frame_w, " × ", frame_h, " × ", frame_d, " mm"));
echo(str("Pocket inner: ", pocket_w, " × ", pocket_h, " × ", pocket_d, " mm"));
echo(str("Back plate: ", back_thick, " mm"));
echo(str("Front lip: ", lip_inset, " mm overlap"));
echo(str("Magnets: ", mag_cols * 2, "× ⌀", mag_dia, " × ", mag_depth, "mm"));
echo(str("Slide-in: ", slide_in ? "bottom edge open" : "fully enclosed"));

// --- RENDER ------------------------------------------------------------------

breadcrumbs_mount_v1();

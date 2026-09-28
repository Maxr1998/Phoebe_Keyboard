// TUNABLES
// Design choices
case_wall_thickness = 10;
case_corner_outer_radius = 4;
case_tub_side_wall_thickness = 5;
case_floor_thickness = 3;
case_floor_chamfer = 0.6; // Included in floor thickness
case_seam_radius = 4;
case_top_chamfer = 0.8;
case_top_cap_distance = 0.8;

udb_port_wall_thickness = 2.0; // The case's wall thickness where the UDB sits
udb_pit_height = 1.0; // PCB is 1.6 mm thick
udb_pin_washer_height = 1.4; // Extend the PCB to allow using starlock washers or glue

gasket_compression = 0.3;

screw_length = 14;
screw_engagement = 3.0; // How far the screw threads into the top cover

foot_pocket_height = 1.0;

reset_button_hole_width = 7.0;
reset_button_corner_radius = 1.0;

weight_width = 200;
weight_depth = 50;
weight_thickness = 2;

detail_stroke_width = 0.8;
detail_engraving_depth = 0.3;

groove_count = 6;
groove_band_min_margin = detail_stroke_width;

// Fits & clearances
process_tolerance = 0.15; // Per-side, material-dependent: resin ≈ 0.15, CNC ≈ 0
min_wall_thickness = 0.2 + 2 * process_tolerance;

case_top_skirt_clearance = 0.15 + process_tolerance;
case_pcb_clearance = 0.74; // X/Y, accounts for production tolerances and allows the PCB to move freely within the case
case_socket_clearance = 0.7;
udb_usb_connector_clearance = 0.25;
gasket_tolerance = 0.3;
weight_tolerance = 0.1 + process_tolerance;
weight_bond_thickness = 0.09;
foot_tolerance = 0.05 + process_tolerance;

// COMPONENTS
eps = 0.01;
cmp_eps = 1e-9; // Comparison tolerance to protect from floating-point errors
function le(a, b) = a <= b + cmp_eps;
function ge(a, b) = a + cmp_eps >= b;
function approx_eq(a, b) = abs(a - b) < cmp_eps;

// PCB
pcb_thickness = 1.6;
pcb_width = 229.87;
pcb_depth = 96.52;
pcb_corner_radius = 3.81;

socket_height = 1.8;
pcb_edge_to_switch_distance = 10.16;
switch_to_switch_distance = 19.05;

pcb_reset_button_center = [29.135, 16.8];
reset_button_clearance_height = 4.0; // TODO: validate on button once delivered
reset_button_hole_height = reset_button_clearance_height + case_floor_thickness; // poke through the floor
reset_button_plunger_diameter = 3.4;
reset_button_hole_radius = reset_button_plunger_diameter / 2 + case_pcb_clearance;

// Unified Daughterboard specs
udb_width = 40.0 + 2 * process_tolerance;
udb_depth = 9.0 + 2 * process_tolerance;
udb_corner_radius = 3;
assert(le(udb_corner_radius, udb_depth / 2 - process_tolerance), "UDB radius too large");
udb_pcb_height = 1.6;
udb_usb_connector_width = 8.94 + 2 * (udb_usb_connector_clearance + process_tolerance);
udb_usb_connector_height = 3.26 + 2 * (udb_usb_connector_clearance + process_tolerance);
udb_usb_connector_overhang = 1.3;
udb_hole_distance = 33.0;
udb_hole_to_usb_center_distance = 8.9;

// UDB slot dimensions
udb_slot_depth = case_wall_thickness; // Should be long enough to "open" the wall

udb_pin_height = udb_pcb_height + udb_pin_washer_height;
udb_pin_radius = 1.5 - process_tolerance; // Corresponds to the M3 screws used by the UDB
udb_usb_port_radius = udb_usb_connector_height / 3; // Approximated, supposed to be small
udb_usb_port_offset = (udb_width - udb_hole_distance) / 2 + udb_hole_distance - udb_hole_to_usb_center_distance;
udb_usb_flare = udb_port_wall_thickness - udb_usb_connector_overhang;
udb_usb_mouth_width = udb_usb_connector_width + 2 * udb_usb_flare;
assert(udb_usb_flare <= 1.5, "port recess too deep: cable boots may not seat");

// Cherry MX spec sheet values
mx_base_height = 5.0;
mx_pcb_to_stem_base = 11.6;
mx_stem_height = 3.6;

// XDA keycap specs (measured)
xda_keycap_width = 18.0;
xda_keycap_height = 8.7;
xda_keycap_corner_radius = 0.54;

// Plate
plate_thickness = 1.5;

// Plate tab center X positions relative to the assembly (PCB/plate)
top_tabs_center_x = [62, 167.8];
bottom_tabs_center_x = [38, 114.935, 192];
assert(bottom_tabs_center_x[1] == pcb_width / 2);

// Case dimensions
function keycap_span(num_keys) = (num_keys - 1) * switch_to_switch_distance + xda_keycap_width;

case_top_skirt_thickness = case_wall_thickness - case_top_skirt_clearance - case_tub_side_wall_thickness;
case_tub_side_offset = case_wall_thickness - case_tub_side_wall_thickness;
case_tub_inner_width = pcb_width + case_pcb_clearance * 2;
case_tub_inner_depth = pcb_depth + case_pcb_clearance * 2;
case_width = case_tub_inner_width + case_wall_thickness * 2;
case_depth = case_tub_inner_depth + case_wall_thickness * 2;
case_tub_width = case_tub_inner_width + case_tub_side_wall_thickness * 2;
case_tub_depth = case_depth;
case_top_inner_width = keycap_span(12) + 2 * case_top_cap_distance;
case_top_inner_depth = keycap_span(5) + 2 * case_top_cap_distance;
case_top_inner_radius = case_top_cap_distance + xda_keycap_corner_radius;
assert(approx_eq((case_width - case_top_inner_width) / 2, (case_depth - case_top_inner_depth) / 2), "wall mismatch");
case_top_wall_thickness = (case_width - case_top_inner_width) / 2;
case_tub_inner_radius = pcb_corner_radius + case_pcb_clearance;

assert(le(case_seam_radius, case_tub_side_wall_thickness), "seam radius exceeds tub wall thickness");
assert(ge(case_top_skirt_thickness, case_corner_outer_radius), "corners don't fit top skirt");
assert(ge(case_top_wall_thickness - assembly_y, 0.3), "top cover exposes gaskets");
assert(ge(case_tub_inner_width, weight_width), "weight too wide");
assert(ge(case_tub_inner_depth, weight_depth), "weight too deep");

// Gasket sock dimensions
gasket_height = 5;
gasket_width = 36.5;
gasket_depth = 4;

// Gasket pocket
pocket_height = gasket_height - gasket_compression;

pocket_width = gasket_width + gasket_tolerance;
pocket_depth = gasket_depth + gasket_tolerance;
pocket_radius = 2;
assert(le(pocket_radius, pocket_depth), "pocket radius too large");

silicone_height_compressed = (pocket_height - plate_thickness) / 2; // Per side

// Screws
screw_head_height = 1.55; // From datasheet

screw_hole_diameter = 2.4 + 2 * process_tolerance; // ISO 273, medium
screw_counterbore_diameter = 4.3 + 2 * process_tolerance; // DIN 974-1

screw_tap_runout = 1.0;
screw_tap_hole_length = screw_engagement + screw_tap_runout;
screw_tap_drill_diameter = 1.6; // ISO 2306 / DIN 336

screw_length_inset = case_tub_side_offset + case_seam_radius + screw_hole_diameter / 2 + min_wall_thickness;
screw_depth_inset = case_wall_thickness / 2;

// Rubber feet
foot_width = 41.8;
foot_depth = 5.8;
foot_pocket_width = foot_width + 2 * foot_tolerance;
foot_pocket_depth = foot_depth + 2 * foot_tolerance;
foot_pocket_radius = foot_pocket_depth / 2;

foot_depth_inset = case_wall_thickness / 2 - foot_pocket_depth / 2;
foot_length_inset = screw_length_inset + screw_counterbore_diameter / 2 + foot_depth_inset;

assert(ge(foot_depth_inset, case_floor_chamfer + min_wall_thickness), "foot collides with chamfer");

// Weight
weight_pocket_width = weight_width + 2 * weight_tolerance;
weight_pocket_depth = weight_depth + 2 * weight_tolerance;
weight_recess_depth = weight_thickness + weight_bond_thickness;
assert(ge(case_floor_thickness - weight_recess_depth, 0.9), "weight window too thin");

weight_x = (case_tub_inner_width - weight_pocket_width) / 2;
weight_y = (case_tub_inner_depth - weight_pocket_depth) / 2;

// Logo
logo_ascent = 8;
logo_height = detail_stroke_width * logo_ascent;
logo_groove_count = groove_count - 2;

// Grooves
groove_pitch = (logo_height - detail_stroke_width) / (logo_groove_count - 1);
groove_gap = groove_pitch - detail_stroke_width;
groove_band_height = (groove_count - 1) * groove_pitch + detail_stroke_width;

// Assembly Z-stack (relative to case floor)
pcb_bot_z = case_socket_clearance + socket_height;
pcb_top_z = pcb_bot_z + pcb_thickness;
plate_top_z = pcb_top_z + mx_base_height;
plate_bot_z = plate_top_z - plate_thickness;
pocket_bot_z = plate_bot_z - silicone_height_compressed;
pocket_top_z = plate_top_z + silicone_height_compressed;
assert(approx_eq(pocket_bot_z + pocket_height, pocket_top_z), "Z-stack drifted");

// Assembly Z-stack-derived heights/values
case_tub_height = case_floor_thickness + pocket_top_z;
case_top_height = mx_pcb_to_stem_base - (pocket_top_z - pcb_top_z);
case_height = case_tub_height + case_top_height;
assert(ge(case_top_height - screw_tap_hole_length, 0.8), "screw tip too close to cover top");

screw_counterbore_depth = case_tub_height + screw_engagement - screw_length;
assert(ge(screw_counterbore_depth, screw_head_height + 2 * process_tolerance), "counterbore shallower than screw head");

// Case Z-stack
case_bot_z = 0;
detail_face_bot_z = case_floor_chamfer;
detail_face_top_z = case_tub_height;
case_top_z = case_height;

// Case Z-stack-derived heights/values
detail_face_height = detail_face_top_z - detail_face_bot_z;
groove_band_margin = (detail_face_height - groove_band_height) / 2;

assert(ge(groove_band_margin, groove_band_min_margin), "groove band margin too small");

// Parts assembly offsets - transforms part coordinates into case coordinate system
assembly_x = case_wall_thickness + case_pcb_clearance;
assembly_y = case_wall_thickness + case_pcb_clearance;
assembly_z = case_floor_thickness;
include <spec.scad>;
include <udb.scad>;
use <logo.scad>;
use <rounded_rect.scad>;

module case_tub() {
  color("white") {
    difference() {
      case_tub_outer();

      // Main cavity
      translate([case_wall_thickness, case_wall_thickness, case_floor_thickness]) {
        rounded_rect_prism([case_tub_inner_width, case_tub_inner_depth, case_tub_height], r = case_tub_inner_radius);
      }
      // Gasket pockets
      translate([assembly_x, 0, case_tub_height - pocket_height]) {
        translate([0, case_depth - assembly_y]) {
          for (i = top_tabs_center_x) {
            translate([i, 0]) {
              pocket();
            }
          }
        }
        translate([0, assembly_y]) {
          for (i = bottom_tabs_center_x) {
            translate([i, 0]) {
              pocket();
            }
          }
        }
      }
      // Reset button
      reset_button_x = assembly_x + pcb_reset_button_center[0];
      reset_button_y = assembly_y + pcb_reset_button_center[1];
      reset_button_z = assembly_z + pcb_bot_z;
      translate([reset_button_x, reset_button_y, reset_button_z]) {
        reset_button_pocket();
      }
      // UDB + USB port
      translate([case_width / 2, case_depth - udb_port_wall_thickness, case_floor_thickness]) {
        udb();
      }
      // Screw holes
      for (screw_x = [screw_length_inset, case_width - screw_length_inset]) {
        for (screw_y = [screw_depth_inset, case_depth - screw_depth_inset]) {
          translate([screw_x, screw_y, -eps]) {
            screw_hole();
          }
        }
      }
      // Feet
      for (foot_x = [foot_length_inset, case_width - foot_length_inset - foot_pocket_width]) {
        for (foot_y = [foot_depth_inset, case_depth - foot_depth_inset - foot_pocket_depth]) {
          translate([foot_x, foot_y, -eps]) {
            # foot_pocket();
          }
        }
      }
      // Weight cavity
      weight_pocket_x = case_wall_thickness + weight_x;
      weight_pocket_y = case_wall_thickness + weight_y;
      weight_pocket_z = case_floor_thickness - weight_recess_depth;
      translate([weight_pocket_x, weight_pocket_y, weight_pocket_z]) {
        cube([weight_pocket_width, weight_pocket_depth, weight_recess_depth + eps]);
      }

      // Details
      detail_x = assembly_x + (pcb_edge_to_switch_distance - xda_keycap_width / 2);
      detail_gap = detail_x - case_tub_side_offset;

      // Logo
      logo_x = case_width - detail_x;
      logo_z = detail_face_bot_z + (detail_face_height - logo_height) / 2;
      translate([logo_x, case_depth + eps, logo_z]) {
        rotate([90, 0, 0]) {
          mirror([1, 0, 0]) {
            # linear_extrude(height = detail_engraving_depth + eps) {
              logo(height = logo_height, ascent = logo_ascent);
            }
          }
        }
      }
      // Face grooves
      groove_band_z = detail_face_bot_z + groove_band_margin;
      groove_length_front = case_width - 2 * detail_x;
      // Front
      for (i = [0 : groove_count - 1]) {
        groove_z = groove_band_z + i * groove_pitch;
        translate([detail_x, -eps, groove_z]) {
          # groove(length = groove_length_front);
        }
      }
      // Back
      logo_width = logo_width(height = logo_height, ascent = logo_ascent);
      groove_length_back = (case_width - udb_usb_mouth_width) / 2 - detail_x - detail_gap;
      for (i = [0 : groove_count - 1]) {
        groove_z = groove_band_z + i * groove_pitch;
        translate([detail_x, case_depth + eps, groove_z]) {
          # groove(length = groove_length_back, front = false);
        }
        translate([(case_width + udb_usb_mouth_width) / 2 + detail_gap, case_depth + eps, groove_z]) {
          groove_logo_inset = i > 0 && i < groove_count - 1
            ? logo_width + groove_gap
            : 0;
          # groove(length = groove_length_back - groove_logo_inset, front = false);
        }
      }
    }
  }
}

/**
 * The case bottom tubs outer hull with chamfered edges at the front/back bottom.
 */
module case_tub_outer() {
  intersection() {
    translate([case_tub_side_offset, -eps, 0]) {
      rotate([90, 0, 0]) {
        mirror([0, 0, 1]) {
          half_rounded_rect_prism(
            size = [case_tub_width, case_tub_height, case_tub_depth + 2 * eps],
            r = case_seam_radius
          );
        }
      }
    }
    translate([case_tub_side_offset - eps, 0, 0]) {
      rotate([90, 0, 90]) {
        linear_extrude(height = case_tub_width + 2 * eps) {
          // Bottom tub profile the from side with chamfer
          polygon([
              [case_floor_chamfer, 0],
              [case_tub_depth - case_floor_chamfer, 0],
              [case_tub_depth, case_floor_chamfer],
              [case_tub_depth, case_tub_height],
              [0, case_tub_height],
              [0, case_floor_chamfer]
            ]);
        }
      }
    }
  }
}

/**
 * Cutout for a plate-mount gasket pocket, centered on the tab position.
 *
 * Extends pocket_depth to BOTH sides of the wall's inner face, so the same module serves the front and back walls.
 * The half that reaches into the cavity cuts empty space and is harmless.
 */
module pocket() {
  translate([-pocket_width / 2, -pocket_depth]) {
    rounded_rect_prism([pocket_width, pocket_depth * 2, pocket_height + eps], r = pocket_radius);
  }
}

module screw_hole() {
  union() {
    cylinder(h = screw_counterbore_depth + eps, r = screw_counterbore_diameter / 2);
    cylinder(h = screw_counterbore_depth + eps + screw_length, r = screw_hole_diameter / 2);
  }
}

module foot_pocket() {
  rounded_rect_prism([foot_pocket_width, foot_pocket_depth, foot_pocket_height + eps], r = foot_pocket_radius);
}

module reset_button_pocket() {
  union() {
    translate([-reset_button_hole_width / 2, -reset_button_hole_width / 2, -reset_button_clearance_height]) {
      // No eps as it's positioned from pcb_bot_z
      rounded_rect_prism(
        size = [reset_button_hole_width, reset_button_hole_width, reset_button_clearance_height],
        r = reset_button_corner_radius
      );
    }
    translate([0, 0, -reset_button_hole_height]) {
      cylinder(h = reset_button_hole_height, r = reset_button_hole_radius);
    }
  }
}

module groove(length, front = true) {
  mirror([0, front ? 1 : 0, 0]) {
    rotate([90, 0, 0]) {
      rounded_rect_prism([length, detail_stroke_width, detail_engraving_depth + eps], r = detail_stroke_width / 2);
    }
  }
}

// Unused, but potentially useful for later
function face_edge_inset(z) = let(
  fillet_start_z = detail_face_top_z - case_seam_radius,
  rise = min(max(0, z - fillet_start_z), case_seam_radius)
) case_seam_radius - sqrt(case_seam_radius^2 - rise^2);

case_tub();
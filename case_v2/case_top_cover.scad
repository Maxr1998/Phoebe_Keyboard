include <spec.scad>;
use <rounded_rect.scad>;

module case_top_cover() {
  color("yellow") {
    difference() {
      case_top_cover_outer();

      // Bottom tub
      bottom_tub_cutout();
      // Frame insides
      translate([case_top_wall_thickness, case_top_wall_thickness, case_tub_height - eps]) {
        rounded_rect_prism(
          size = [case_top_inner_width, case_top_inner_depth, case_top_height + 2 * eps],
          r = case_top_inner_radius
        );
      }
      // Screw holes
      for (screw_x = [screw_length_inset, case_width - screw_length_inset]) {
        for (screw_y = [screw_depth_inset, case_depth - screw_depth_inset]) {
          translate([screw_x, screw_y, case_tub_height - eps]) {
            screw_tap_hole();
          }
        }
      }
    }
  }
}

module case_top_cover_outer() {
  hull() {
    r = case_corner_outer_radius;
    for (x = [r, case_width - r], y = [r, case_depth - r]) {
      translate([x, y, 0]) {
        cylinder(h = case_floor_chamfer, r1 = r - case_floor_chamfer, r2 = r);
        translate([0, 0, case_floor_chamfer])
          cylinder(h = case_height - case_floor_chamfer - case_top_chamfer, r = r);
        translate([0, 0, case_height - case_top_chamfer])
          cylinder(h = case_top_chamfer, r1 = r, r2 = r - case_top_chamfer);
      }
    }
  }
}

module bottom_tub_cutout() {
  translate([case_top_skirt_thickness, -eps, -eps]) {
    rotate([90, 0, 0]) {
      mirror([0, 0, 1]) {
        half_rounded_rect_prism(
          size = [case_width - 2 * case_top_skirt_thickness, case_tub_height + eps, case_depth + 2 * eps],
          r = case_seam_radius
        );
      }
    }
  }
}

module screw_tap_hole() {
  cylinder(h = screw_tap_hole_length + eps, r = screw_tap_drill_diameter / 2);
}

case_top_cover();
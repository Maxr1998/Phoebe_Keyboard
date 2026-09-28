include <spec.scad>;
use <rounded_rect.scad>;

module pcb() {
  color("darkgray") {
    rounded_rect_prism([pcb_width, pcb_depth, pcb_thickness], r = pcb_corner_radius);
  }
}
include <spec.scad>;
include <cherrymx.scad>;
use <rounded_rect.scad>;

assert(mx_base_height == base_height, "cherrymx.scad disagrees with MX datasheet");
assert(mx_pcb_to_stem_base == switch_body_height, "cherrymx.scad disagrees with MX datasheet");
assert(mx_stem_height == stem_height, "cherrymx.scad disagrees with MX datasheet");

mx_switch_height = mx_pcb_to_stem_base + mx_stem_height;

module switch() {
  // Align with PCB
  translate([0, 0, mx_switch_height]) {
    CherryMX();
  }
}

module keycap() {
  color("white") {
    rounded_rect_prism([xda_keycap_width, xda_keycap_width, xda_keycap_height], r = 0.2);
  }
}

module key() {
  switch();

  translate([-xda_keycap_width / 2, -xda_keycap_width / 2, mx_pcb_to_stem_base]) {
    keycap();
  }
}

module keys() {
  translate([pcb_edge_to_switch_distance, pcb_edge_to_switch_distance]) {
    for (i = [0:11], j = [0:4]) {
      translate([i * switch_to_switch_distance, j * switch_to_switch_distance]) {
        key();
      }
    }
  }
}
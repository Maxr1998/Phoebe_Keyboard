use <case_tub.scad>;
use <case_top_cover.scad>;

include <spec.scad>;
include <plate.scad>;
include <pcb.scad>;
include <keys.scad>;

preview_assembly = false;

color("white") {
  render()
    case_tub();
}

color("yellow") {
  render()
    case_top_cover();
}

if (preview_assembly) {
  translate([assembly_x, assembly_y, assembly_z]) {
    translate([0, 0, pcb_bot_z]) pcb();
    translate([0, 0, plate_bot_z]) plate();
    translate([0, 0, pcb_top_z]) keys();
  }
}
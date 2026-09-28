include <spec.scad>;

module plate() {
  color("silver") {
    linear_extrude(height = plate_thickness) {
      import("plate.dxf");
    }
  }
}
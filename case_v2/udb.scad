include <spec.scad>;
use <rounded_rect.scad>;

module udb() {
  // Center X on USB port, align Y with front edge, set Z to slot base
  translate([-udb_usb_port_offset, -udb_depth, -udb_pit_height]) {
    difference() {
      union() {
        udb_pit();
        udb_slot();
        translate([udb_usb_port_offset, 0, udb_pcb_height + udb_usb_connector_height / 2]) {
          usb_connector();
          translate([0, udb_depth + udb_usb_connector_overhang]) {
            usb_chamfer(
              inner = [udb_usb_connector_width, udb_usb_connector_height],
              depth = udb_usb_flare,
              flare = udb_usb_flare,
              r = udb_usb_port_radius
            );
          }
        }
      }
      translate([(udb_width - udb_hole_distance) / 2, udb_depth / 2]) {
        cylinder(h = udb_pin_height, r = udb_pin_radius);
        translate([udb_hole_distance, 0]) {
          cylinder(h = udb_pin_height, r = udb_pin_radius);
        }
      }
    }
  }
}

/**
 * The pit where the UDB PCB sits in.
 */
module udb_pit() {
  rounded_rect_prism(size = [udb_width, udb_depth, udb_pit_height + eps], r = udb_corner_radius);
}

/**
 * A slot above the UDB pit where the module can be inserted from.
 */
module udb_slot() {
  translate([0, udb_depth - udb_slot_depth, udb_pit_height]) {
    half_rounded_rect_prism(
      size = [udb_width, udb_slot_depth, pocket_top_z + eps],
      r = udb_corner_radius
    );
  }
}

/**
 * The USB connector itself
 */
module usb_connector() {
  rounded_tunnel(
    size = [udb_usb_connector_width, udb_usb_connector_height, udb_depth + udb_usb_connector_overhang + eps],
    r = udb_usb_port_radius
  );
}

/**
 * A chamfer between the USB connector and the case.
 */
module usb_chamfer(inner = [10, 4], depth = 0.7, flare = 0.7, r = 1) {
  hull() {
    for (x = [-1, 1], z = [-1, 1]) {
      translate([x * (inner[0] / 2 - r), 0, z * (inner[1] / 2 - r)])
        rotate([-90, 0, 0])
          cylinder(h = depth + eps, r1 = r, r2 = r + flare * (depth + eps) / depth);
    }
  }
}

/**
 * A cutout for a USB connector or cable.
 */
module rounded_tunnel(size, r) {
  rotate([-90, 0, 0]) {
    translate([-size[0] / 2, -size[1] / 2]) {
      rounded_rect_prism(size, r);
    }
  }
}
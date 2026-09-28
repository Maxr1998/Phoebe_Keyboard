module rounded_rect(size, r) {
  r = min(size[0] / 2, size[1] / 2, r);

  w = size[0] - 2 * r;
  h = size[1] - 2 * r;
  tol = 1e-6;
  if (w > tol && h > tol) {
    offset(r = r)
      translate([r, r])
        square([w, h]);
  } else if (w > tol || h > tol) {
    hull() {
      translate([r, r]) circle(r = r);
      translate([r + max(w, 0), r + max(h, 0)]) circle(r = r);
    }
  } else {
    translate([r, r]) circle(r = r);
  }
}

module rounded_rect_prism(size, r, convexity = 10) {
  linear_extrude(height = size[2], convexity = convexity) {
    rounded_rect([size[0], size[1]], r);
  }
}

module half_rounded_rect(size, r) {
  intersection() {
    offset(r = r)
      translate([r, -r])
        square([size[0] - 2 * r, size[1]]);
    square(size);
  }
}

module half_rounded_rect_prism(size, r, convexity = 10) {
  linear_extrude(height = size[2], convexity = convexity) {
    half_rounded_rect([size[0], size[1]], r);
  }
}
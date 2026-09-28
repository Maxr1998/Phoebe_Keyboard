/**
 * Segments of the logo in grid units.
 */
function logo_segments(ascent) = let(
  B = 0.5, // baseline stroke center
  X = 4.5, // x-height stroke center (o top bar, P lower bar, h shoulder)
  M = 2.5, // e middle bar stroke center
  T = ascent - 0.5, // ascender stroke center
  // e appears twice
  e = function (x) [
      [[x + 0.5, B], [x + 0.5, X]], [[x + 0.5, B], [x + 4.5, B]], [[x + 0.5, X], [x + 4.5, X]],
      [[x + 4.5, X], [x + 4.5, M]], [[x + 0.5, M], [x + 4.5, M]]
    ]
) concat(
    [[[0.5, B], [0.5, T]], [[0.5, T], [4.5, T]], [[4.5, T], [4.5, X]], [[0.5, X], [4.5, X]]], // P (x 0..5)
    [[[6.5, B], [6.5, T]], [[6.5, X], [10.5, X]], [[10.5, X], [10.5, B]]], // h (x 6..11)
    [[[12.5, B], [16.5, B]], [[16.5, B], [16.5, X]], [[16.5, X], [12.5, X]], [[12.5, X], [12.5, B]]], // o (x 12..17)
  e(18), // e (x 18..23)
    [[[24.5, B], [24.5, T]], [[24.5, B], [28.5, B]], [[28.5, B], [28.5, X]], [[24.5, X], [28.5, X]]], // b (x 24..29)
  e(30) // e (x 30..35)
);

logo_width_units = 35; // 6 letters x 5 units + 5 gaps x 1 unit

module pen_stroke(a, b, u) {
  hull() {
    translate(a * u) circle(d = u);
    translate(b * u) circle(d = u);
  }
}

/**
 * 2D "Phoebe" logo with its origin at the bottom-left corner.
 *
 * `height` - total letter height in mm
 * `ascent` - how many units letters with ascent take up in total.

 * The stroke width follows as height / ascent.
 */
module logo(height, ascent = 8) {
  assert(ascent >= 6, "ascent must be larger than base-grid");
  u = height / ascent;
  for (s = logo_segments(ascent)) {
    pen_stroke(s[0], s[1], u);
  }
}

/**
 * The width of the logo.
 */
function logo_width(height, ascent = 8) = logo_width_units * height / ascent;
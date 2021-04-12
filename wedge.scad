// From https://www.thingiverse.com/thing:40245
// Code by Alex English

module wedge_180(h, r, d)
{
  rotate(d)
    difference() {
    rotate(180-d)
      difference() {
        cylinder(h = h, r = r);
        translate([-(r+1), 0, -1]) {
          cube([r*2+2, r+1, h+2]);
        }
      }
      translate([-(r+1), 0, -1]) {
        cube([r*2+2, r+1, h+2]);
      }
   }
}

module wedge(h, r, d)
{
  if(d <= 180) {
    wedge_180(h, r, d);
  } else {
    rotate(d) {
      difference() {
        cylinder(h = h, r = r);
	translate([0, 0, -1]) {
	  wedge_180(h+2, r+1, 360-d);
        }
      }
    }
  }
}

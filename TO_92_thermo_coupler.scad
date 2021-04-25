// Thermo coupler for a transistor in a TO-92 package.

{ // Dimensions
  //
  //  +--------+ ----  4.19/3.05
  //  |________| ____
  //  \	       /       2.66/2.13
  //   `______'	 ____
  //

  radius = 5/2;
  total_width_y = 3.7;
  length_x = 2*radius;
  width_y = total_width_y - radius;
  thickness = 0.5;
  height_z = 4.5;

  $fn = 100;
}

module half_cylinder(r, h) {
  difference() {
    cylinder(r=r, h=h);
    translate([-r, -r, 0]) {
      cube([2*r, r, h]);
    }
  }
}

module half() {
  x = length_x + 2*thickness;
  y = total_width_y + thickness;
  z = thickness + height_z;
  difference() {
    cube([x, y, z]);
    translate([thickness, 0, thickness]) {
      cube([length_x, width_y, height_z]);
    }
    translate([thickness + radius, width_y - 0.1, thickness]) {
      half_cylinder(radius, height_z);
    }
  }
}

module part() {
  half();
  translate([length_x + 2*thickness, 0, 0]) {
    rotate([0, 0, 180]) {
      half();
    }
  }
}

part();

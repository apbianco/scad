{ // Part dimension
  length = 51;
  height = 38;
  width = 4;
  thickness = 4;
  leg_hole_diameter = 4;
  leg_size = 15;

  $fn = 200;
}

module leg() {
  difference() {
    cube([leg_size, leg_size, thickness]);
    translate([leg_size/2, leg_size/2, 0]) {
      cylinder(d=leg_hole_diameter, h=thickness);
    }
  }
}

module bracket_no_leg() { 
  cube([thickness, width, height]);
  translate([-length - thickness, 0, height]) {
    cube([length + 2*thickness, width, thickness]);
  }
  translate([-length - 2*thickness, 0, 0]) {
    cube([thickness, width, height + thickness]);
  }
}

module part() {
  // leg();
  bracket_no_leg();
  translate([0, -leg_size + width, 0]) {
    leg();
  }
  translate([-length-thickness - leg_size, -leg_size + width, 0]) {
    leg();
  }
}

translate([0, 0, width]) {
rotate([-90, 0, 0]) {
    part();
  }
}
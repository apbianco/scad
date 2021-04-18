{ // Part dimension
  width_x = 72;
  depth_y = 48;
  front_height_z = 15;
  back_height_z = 33;
  thickness = 2;
  hole_diameter = 4;

  $fn = 100;
}

module box() {
  cube([width_x, depth_y, thickness]);
  // walls
  translate([-thickness, 0, 0]) {
    cube([thickness, depth_y, front_height_z]);
  }
  translate([width_x, 0, 0]) {
    cube([thickness, depth_y, front_height_z]);
  }
  translate([-thickness, depth_y, 0]) {
    cube([width_x + 2*thickness, thickness, front_height_z]);
  }
  translate([-thickness, -thickness, 0]) {
    cube([width_x + 2*thickness, thickness, back_height_z]);
  }
}

module holes() {
  translate([width_x/4, 0, 3*back_height_z/4]) {
    rotate([90, 0, 0]) {
      cylinder(d=hole_diameter, h=thickness);
      cylinder(d=hole_diameter+2, h=1);
    }
  }
  translate([3*width_x/4, 0, 3*back_height_z/4]) {
    rotate([90, 0, 0]) {
      cylinder(d=hole_diameter, h=thickness);
      cylinder(d=hole_diameter+2, h=1);
    }
  }
}
module part() {
  difference() {
    box();
    holes();
  }
}

part();

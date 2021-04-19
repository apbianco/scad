{ // Part dimension
  connector_width = 2.5;
  connector_heigth = 5;
  connector_thickness = 1;
  front_pin_hole_diameter = 1.6;
  
  size_x = 9.25;
  size1_y = 10.5 + 0.25;  // 0.25 is an adjustment for retraction.
  size2_y = size1_y + connector_heigth;
  size1_z = 7.75;
  size2_z = connector_heigth;
  size3_z = 4;  // pin height

  thickness = 1;

  $fn = 100;
}

module base() {
  max_y = size2_y+2*thickness;
  max_x = size_x+2*thickness;
  difference() {
    cube([max_x, max_y, size3_z + size2_z]);
    // vertical groove for the back connector
    translate([max_x/2 - connector_width/2,
               max_y - thickness - connector_thickness - 0.5]) {
      cube([connector_width, connector_thickness, size3_z + size2_z]);
    }
  }
}

module top() {
  difference() {
    cube([size_x+2*thickness, size2_y+2*thickness, size1_z]);
    translate([thickness, thickness + connector_heigth, 0]) {
      cube([size_x, size1_y, size1_z]);
    }
  }
}

module main_volume() {
  base();
  translate([0, 0, size3_z + size2_z]) {
    top();
  }
}

module front_pin_hole() {
  // Insert a rod that starts at the middle of the top module and
  // deviates right in such a what that at the bottom it exits at
  // 1/10th of an inch. We help get the right angle during print by
  // adding 0.2
  opposite = 2.54 + 0.2;
  adjacent = size1_z + size2_z + size3_z;
  echo(adjacent);
  angle = atan(opposite / adjacent);
  translate([opposite, 0, -0.2]) {
    rotate([0, -angle, 0]) {
      cylinder(d=front_pin_hole_diameter, h=adjacent+1);
    }
  }
}

difference() {
  main_volume();
  front_pin_hole_x = (size_x+2*thickness)/2;
  front_pin_hole_y = thickness + connector_width/3;
  translate([front_pin_hole_x, front_pin_hole_y, 0]) {
    front_pin_hole();	     
  }
  translate([front_pin_hole_x/2, 1, 1]) {
    rotate([90, 0, 0]) {
      linear_extrude(height=3, convexity=5) {
        text("G", size=5, halign="center", font="Impact");
      }
    }
  }
}

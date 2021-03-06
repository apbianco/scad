{ // Part parameters
  // - Overall dimensions
  length = 26;
  width = 14;
  height = 6;
  corner_diameter = 3;

  plate_increase = 2;
  plate_height = 1;

  $fn = 200;
}

module main_part() {
  corner_adjustment = corner_diameter/2;
  adjusted_length = length - corner_adjustment;
  adjusted_width = width - corner_adjustment;
  // Main shape
  translate([corner_adjustment, corner_adjustment]) {
    cube([adjusted_length, adjusted_width, height]);
  }

  // Four corners
  translate([corner_adjustment, corner_adjustment]) {
    cylinder(d=corner_diameter, h=height);
  }
  translate([corner_adjustment, adjusted_width + corner_adjustment]) {
    cylinder(d=corner_diameter, h=height);
  }
  translate([adjusted_length + corner_adjustment,
             adjusted_width + corner_adjustment]) {
    cylinder(d=corner_diameter, h=height);
  }
  translate([adjusted_length + corner_adjustment,
             corner_adjustment]) {
    cylinder(d=corner_diameter, h=height);
  }

  // Missing sides
  translate([corner_adjustment, 0]) {
    cube([adjusted_length, corner_adjustment, height]);
  }
  translate([corner_adjustment, corner_adjustment+adjusted_width]) {
    cube([adjusted_length, corner_adjustment, height]);
  }
  translate([0, corner_adjustment]) {
    cube([corner_adjustment, adjusted_width, height]);
  }
  translate([corner_adjustment + adjusted_length, corner_adjustment]) {
    cube([corner_adjustment, adjusted_width, height]);
  }

}

module hole() {
  // Screw hole
  hole_center_x = length/2;
  hole_center_y = width/2;
  hole_through_diameter = 3;
  hole_top_diameter = 6;
  hole_top_depth = 3;
  translate([hole_center_x, hole_center_y]) {
    cylinder(d=hole_through_diameter, h=height);
  }
  translate([hole_center_x, hole_center_y, height - hole_top_depth]) {
    cylinder(d=hole_top_diameter, hole_top_depth);
  }
}

module plate() {
  plate_length = length + 2.5*plate_increase;
  plate_width = width + 2.5*plate_increase;
  translate([-plate_increase, -plate_increase]) {
    cube([plate_length, plate_width, plate_height]);
  }
}

module part() {
  difference() {
    union() {
      main_part();
      plate();
    }
    hole();
  }
}

part();
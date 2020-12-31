// Protection plate for Racetime2. Prevents one from accidentally turning
// the device off - the on/off switch is inaccessible.

{ // Part parameter
  // - Overall dimentions of the plate
  plate_length = 84;
  plate_width = 20;
  plate_thickness = 3;
  
  // Walls
  wall_thickness = 2;
  wall_height = 5;
  
  // Screw hole dimentions
  screw_hole_diameter = 4;
  screw_hole_height = 5;
  screw_hole_x_offset = 7.5;
  screw_hole_y_offset = (plate_width / 2);
  screw_hole_guide_diameter = screw_hole_diameter + 2;

  // Antenna hole dimentions
  antenna_hole_x_offset = screw_hole_x_offset + 25 + 40;
  antenna_hole_diameter = 9;
  
  $fn = 200;
}

difference () {
  // Main plate
  union() {
    translate([wall_thickness/2, wall_thickness/2, 0]) {
      cube([plate_length - wall_thickness,
            plate_width - wall_thickness, plate_thickness]);
    }
    translate([screw_hole_x_offset, screw_hole_y_offset, 0]) {
      cylinder(d=screw_hole_guide_diameter, h=screw_hole_height);
    }
    translate([screw_hole_x_offset+25, screw_hole_y_offset, 0]) {
      cylinder(d=screw_hole_guide_diameter, h=screw_hole_height);
    }
  }
  // First screw hole
  translate([screw_hole_x_offset, screw_hole_y_offset, -1]) {
    cylinder(d=screw_hole_diameter, h=screw_hole_height+1);
  }
  // Second screw hole
  translate([screw_hole_x_offset + 25, screw_hole_y_offset, -1]) {
    cylinder(d=screw_hole_diameter, h=screw_hole_height+1);
  }
  // Antenna hole
  translate([antenna_hole_x_offset, screw_hole_y_offset, -1]) {
    cylinder(d=antenna_hole_diameter, h=wall_height+1);
  }
  // Logo
  translate([50, screw_hole_y_offset+5, 2]) {
    rotate([180, 0, 0]) {
      linear_extrude(2) {
        text("SCA", size=10, halign="center", font="impact");
      }
    }
  }
}

union() {
  translate([wall_thickness/2, 0, 0]) {
    cube([plate_length - wall_thickness, wall_thickness, 
          wall_height+plate_thickness]);
  }
  translate([wall_thickness/2, wall_thickness/2, 0]) {
    cylinder(d=wall_thickness, h=wall_height+plate_thickness);
  }  
  translate([wall_thickness/2, plate_width - wall_thickness, 0]) {
    cube([plate_length - wall_thickness, wall_thickness,
          wall_height+plate_thickness]);
  }
  translate([wall_thickness/2, plate_width - wall_thickness/2, 0]) {
    cylinder(d=wall_thickness, h=wall_height+plate_thickness);
  }  
  translate([0, wall_thickness/2, 0]) {
    cube([wall_thickness, plate_width - wall_thickness,
          wall_height+plate_thickness]);
  }
  translate([plate_length - wall_thickness, wall_thickness/2, 0]) {
    cube([wall_thickness, plate_width - wall_thickness,
          wall_height+plate_thickness]);
  }
  translate([plate_length - wall_thickness/2, wall_thickness/2, 0]) {
    cylinder(d=wall_thickness, h=wall_height+plate_thickness);
  }
  translate([plate_length - wall_thickness/2, plate_width - wall_thickness/2, 0]) {
   cylinder(d=wall_thickness, h=wall_height+plate_thickness);
  }  
}
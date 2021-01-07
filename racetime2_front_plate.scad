// Protection plate for Racetime2. Prevents one from accidentally turning
// the device off - the on/off switch is inaccessible.

{ // Part parameter

  // - Overall dimentions of the plate
  plate_length = 84 - 2.60 - 2.47;
  plate_width = 20;
  plate_thickness = 3;
  
  screw_holes = false;
  db9_enclosure = true;
  
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
  antenna_hole_x_offset = screw_hole_x_offset + 61.5;
  antenna_hole_diameter = 8;
  antenna_enclosure = true;
  
  // Project instead of rendering
  project = false;
  project_z = plate_thickness + 1;
  
  $fn = 200;
}

module db9enclosure(x, y) {
  module dsub(sc,sz,dp){
    cs=(sz/2)-2.6;
    cs2=(sz/2)-4.095;
    ns=(sz/2)+4.04;
    scale([sc,sc,sc]){
      hull(){
        translate([0,-cs,0]){
          cylinder(r=2.6,h=dp);
        }
        translate([0,cs,0]){
          cylinder(r=2.6,h=dp);
        }
        translate([3.28,-cs2,0]){
          cylinder(r=2.6,h=dp);
        }
        translate([3.28,cs2,0]){
          cylinder(r=2.6,h=dp);
        }
      }
    }
  }
  translate([x, y, 0]) {
    rotate([0,0,90]) { 
      difference() {
        dsub(1.25, 17.04, 9.5);
        translate([0.2, 0, -1]) {
          dsub(1.05, 17.04, 12.5);
        }
      }
    }
  }
}


module plate() {
  difference () {
    // Main plate
    union() {
      translate([wall_thickness/2, wall_thickness/2, 0]) {
        cube([plate_length - wall_thickness,
              plate_width - wall_thickness, plate_thickness]);
      }
      if (screw_holes) {
        translate([screw_hole_x_offset, screw_hole_y_offset, 0]) {
          cylinder(d=screw_hole_guide_diameter, h=screw_hole_height);
        }
        translate([screw_hole_x_offset+25, screw_hole_y_offset, 0]) {
          cylinder(d=screw_hole_guide_diameter, h=screw_hole_height);
        }
      }
    }
    if (screw_holes) {
      // First screw hole
      translate([screw_hole_x_offset, screw_hole_y_offset, -1]) {
        cylinder(d=screw_hole_diameter, h=screw_hole_height+1);
      }
      // Second screw hole
      translate([screw_hole_x_offset + 25, screw_hole_y_offset, -1]) {
        cylinder(d=screw_hole_diameter, h=screw_hole_height+1);
      }
    }
    // Antenna hole
    if (! antenna_enclosure) {
      translate([antenna_hole_x_offset, screw_hole_y_offset, -1]) {
	cylinder(d=antenna_hole_diameter, h=wall_height+1);
      }
    }
    // Logo
    translate([48, screw_hole_y_offset+6, 2]) {
      rotate([180, 0, 0]) {
        linear_extrude(height=3, convexity=5) {
          text("SCA", size=11, halign="center", font="Impact");
        }
      }
      // Remove the triangle in the A
      translate([6, -10, -2]) {
	cube([3, 7, 2]);
      }
    }
  }

  if (antenna_enclosure) {
    translate([antenna_hole_x_offset, screw_hole_y_offset, 0]) {
      difference() {
	cylinder(d=antenna_hole_diameter+3, h=10);
	cylinder(d=antenna_hole_diameter, h=10);
      }
    }
  }

  if (db9_enclosure) {
    db9enclosure(18, plate_width/2-(2.5-0.455));
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
    translate([plate_length - wall_thickness/2,
               plate_width - wall_thickness/2, 0]) {
     cylinder(d=wall_thickness, h=wall_height+plate_thickness);
    }  
  }
}

if (project) {
  projection(cut=true) {
    translate([0, 0, -project_z]) {
      plate();
    }
  }
} else {
  plate();
}

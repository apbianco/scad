// Socket for the 3.5mm jack, err, socket - RS part #106-874.
// Allows one to solder pins and then your board-mount socket is ready
// to be used on a breadboard.
//
// The side where the sleeve pin exits is labeled G (Gnd) and the side
// where the tip pin exits is labeled T (Tip).
//
// I print without support for the letters to appear nicely.

{ // Part dimensions
  connector_width = 2.5;
  connector_height = 5;
  connector_thickness = 1;
  pin_hole_diameter = 1.35;
  
  size_x = 9.25;
  // 0.25 is an adjustment that I've found necessary for the part to
  // slip in and enjoy a snug fit... Maybe it's just my printer.
  size1_y = 10.5 + 0.25;
  size2_y = size1_y + connector_height;
  size1_z = 7.75;
  size2_z = connector_height;
  size3_z = 4;  // pin height

  // Wall thickness
  thickness = 1;

  $fn = 100;
}

module base() {
  max_y = size2_y+2*thickness;
  max_x = size_x+2*thickness;
  difference() {
    cube([max_x, max_y, size3_z + size2_z]);
    // vertical well for the back connector, in two parts:
    //   - The first part is wider so that the connector and its
    //     soldered pin can be inserted
    //   - The second part is just a circular well for the wire to
    //     go through
    solder_blob = 2.25;
    translate([max_x/2 - connector_width/2,
               max_y - thickness - solder_blob, size2_z]) {
      cube([connector_width, solder_blob, size3_z]);
    }
    translate([max_x/2,
               max_y - thickness - pin_hole_diameter/2]) {
      cylinder(d=pin_hole_diameter, h=size3_z+1);	        
    }
  }
}

module top() {
  difference() {
    cube([size_x+2*thickness, size2_y+2*thickness, size1_z]);
    translate([thickness, thickness + connector_height, 0]) {
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
      cylinder(d=pin_hole_diameter, h=adjacent+1);
    }
  }
}

module part() {
  front_pin_hole_x = (size_x+2*thickness)/2;
  front_pin_hole_y = thickness + connector_width/3;
  difference() {
    main_volume();
    translate([front_pin_hole_x, front_pin_hole_y, 0]) {
      front_pin_hole();	     
    }
    translate([front_pin_hole_x/2, 1, 1]) {
      rotate([90, 0, 0]) {
        linear_extrude(height=3, convexity=5) {
          text("S", size=5, halign="center", font="Impact");
        }
      }
    }
    translate([size_x-thickness, size2_y+4, 1]) {
      rotate([90, 0, 0]) {
        linear_extrude(height=3, convexity=5) {
          text("T", size=5, halign="center", font="Impact");
        }
      }
    }
  }
}

part();

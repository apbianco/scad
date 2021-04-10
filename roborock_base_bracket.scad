{
  thickness = 4;
  // Part dimensions
  width_y = 49;
  length_x = 130;
  screw_plate_size = 15;
  screw_diameter = 3;
  back_gap = 5;

  plug_width_y = 8 - thickness;
  plug_height_z = 15;

  $fn = 200;
}

radius = width_y/2;
inner_length_x = length_x - 2*radius;

module round_plate(length, width, thickness) {
  translate([-length/2, -width/2, 0]) {
    cube([length, width, thickness]);
  }
  translate([-length/2, 0, 0]) {
    cylinder(d=width, h=thickness);
  }
  translate([length/2, 0, 0]) {
    cylinder(d=width, h=thickness);
  }
}

module hollow_round_plate(length, width, thickness) {
  difference() {
    round_plate(inner_length_x+thickness, width_y+thickness, thickness);
    round_plate(inner_length_x, width_y, thickness);
 }
}

module back_fastening_plate(x, y) {
  difference() {
    // left back plate
    translate([x, y, 0]) {
      cube([screw_plate_size, thickness, screw_plate_size]);
    }
    // Screw hole
    translate([x + (screw_plate_size/2),
               y + back_gap, screw_plate_size/2]) {
      rotate([90, 0, 0]) {
        cylinder(d=screw_diameter, h=thickness+back_gap);
      }
    }
  }
}

module bracket(length, width, thickness) {
  difference() {
    hollow_round_plate(length_x, width_y, thickness);
    translate([-length/2 -width/2, -width/2 - thickness, 0]) {
      cube([length+width, width/2 + thickness, thickness]);
    }
  }
  left_return_width_y = width/2 + thickness + back_gap;
  translate([length/2, -left_return_width_y, 0]) {
    cube([thickness, left_return_width_y, thickness]);
  }

  // left
  back_fastening_plate(length/2, -left_return_width_y);

  // right
  right_return_x = length/2 + 3.5;
  right_return_y = left_return_width_y + plug_width_y;
  translate([-right_return_x, plug_width_y, 0]) {
    cube([thickness, thickness, plug_height_z]);
  }
  translate([-right_return_x, plug_width_y - right_return_y, plug_height_z]) {
    cube([thickness, right_return_y+thickness, thickness]);
  }

  translate([0,0, screw_plate_size]) {
    back_fastening_plate(-length/2 + 1 - screw_plate_size,
                         -left_return_width_y);
  }
}

right_return_x = length_x/2;
difference() {
  bracket(length_x, width_y, thickness);
  translate([-right_return_x-thickness, 0, 0]) {
    cube([thickness+1, plug_width_y, thickness]);
  }
}

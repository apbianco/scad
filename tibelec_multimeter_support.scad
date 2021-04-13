use <wedge.scad>
{
  back_plate_length = 130;
  back_plate_width = 72;
  back_plate_thickness = 3;
  top_return_height = 21;
  top_return_length = 15;

  bottom_return_length = 25;
  $fn = 100;
}


module back_plate()
{
  translate([back_plate_thickness, 0, 0]) {
    cube([back_plate_length, back_plate_width, back_plate_thickness]);
    translate([back_plate_length, 0, 0]) {
      cube([back_plate_thickness, back_plate_width,
            top_return_height + back_plate_thickness]);
    }
    translate([back_plate_length - top_return_length, 0,
               top_return_height + back_plate_thickness]) {
      cube([top_return_length + back_plate_thickness, back_plate_width,
            back_plate_thickness]);
    }
  }
}

module bottom_return()
{
  thickness = 3;
  height = 12;
  cube([bottom_return_length, back_plate_width, thickness]);
  translate([0, 10 - thickness, thickness]) {
    cube([bottom_return_length, thickness, height]);
  }
  translate([0, 24, thickness]) {
    cube([bottom_return_length, thickness, height]);
  }
  translate([0, 40, thickness]) {
    cube([bottom_return_length, thickness, height]);
  }
  translate([0, 10 - thickness, height]) {
    cube([thickness, 39-thickness, thickness]);
  }
  translate([0, 40, height]) {
    cube([bottom_return_length, back_plate_width-40, thickness]);
  }
  translate([0, 0, height]) {
    cube([bottom_return_length, 10, thickness]);
  }
}

module front_part(angle) {
  rotate([0,angle,0]) {
    back_plate();
  }
  rotate([0, 90-angle, 0]) {
    translate([-25, 0, 0]) {
      bottom_return();
    }
  }
}

module back_part() {
  back_part_length = back_plate_length - 2*back_plate_thickness;
  translate([2*back_plate_thickness, 0, 0]) {
    cube([back_part_length, back_plate_width, back_plate_thickness]);
  }
  translate([3*back_plate_thickness, 0, 0]) {
    cube([back_part_length, back_plate_thickness, 2*back_plate_thickness]);
  }
  translate([3*back_plate_thickness,
             back_plate_width - back_plate_thickness, 0]) {
    cube([back_part_length, back_plate_thickness, 2*back_plate_thickness]);
  }
  translate([back_plate_length, 0, 0]) {
    cube([back_plate_thickness, back_plate_width, 2*back_plate_thickness]);
  }
  translate([back_plate_thickness, back_plate_width, 0]) {
    rotate([90, 0, 0]) {
      wedge(back_plate_width, 18, 55);
    }
  }
  
}

module part() {
  // front_part(0);
  back_part();
}

rotate([0, 0, 0]) {
  part();
}

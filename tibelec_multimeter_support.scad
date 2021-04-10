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
}

module wedge_180(h, r, d)
{
  rotate(d)
    difference() {
    rotate(180-d)
      difference() {
        cylinder(h = h, r = r);
        translate([-(r+1), 0, -1])
          cube([r*2+2, r+1, h+2]);
      }
      translate([-(r+1), 0, -1])
        cube([r*2+2, r+1, h+2]);
   }
}

module wedge(h, r, d)
{
  if(d <= 180) {
    wedge_180(h, r, d);
  } else
    rotate(d)
      difference() {
        cylinder(h = h, r = r);
	translate([0, 0, -1])
	  wedge_180(h+2, r+1, 360-d);
      }
}

module part() {
  rotate([0,-55,0]) {
    back_plate();
  }
  rotate([0, 90-55, 0]) {
    translate([-25, 0, 0]) {
      bottom_return();
    }
  }
  cube([back_plate_length, back_plate_width, back_plate_thickness]);

  translate([0, back_plate_width, 0]) {
    rotate([90, 0, 0]) {
      wedge(back_plate_width, 15, 55);
    }
  }
}

rotate([90, 0, 0]) {
  part();
}
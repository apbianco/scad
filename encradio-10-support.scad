{ // Part parameters
  // - Overall dimensions
  height_z = 100;
  width_x = 51;
  depth_y = 42;
  // The part extends on the back (width_x x depth_y is the base of the
  // device)
  depth_negative_offset_y = 2;

  bottom_plate_height_z = 1;
  side_plate_width = 3;

  // This is the width of the from wall
  return_wall_width_x = 5.25;

  banana_diameter = 10.75;
  red_banana_x = 11.25 + (banana_diameter/2);
  red_banana_y = 20.50 + (banana_diameter/2);
  green_banana_x = width_x - red_banana_x;
  green_banana_y = 20.50 + (banana_diameter/2);
  black_banana_x = width_x/2;
  black_banana_y = 27.5 + (banana_diameter/2);

  $fn = 200;
}

module bottom_plate() {
  difference() {
    translate([0, 0, -bottom_plate_height_z]) {
      cube([width_x, depth_y, bottom_plate_height_z]);
    }
    translate([red_banana_x, red_banana_y, -bottom_plate_height_z]) {
      cylinder(d=banana_diameter, h=bottom_plate_height_z);
    }
    translate([green_banana_x, green_banana_y, -bottom_plate_height_z]) {
      cylinder(d=banana_diameter, h=bottom_plate_height_z);
    }
    translate([black_banana_x, black_banana_y, -bottom_plate_height_z]) {
      cylinder(d=banana_diameter, h=bottom_plate_height_z);
    }
  }
}

module side_plate_grooved() {
  side_plate_width_x = side_plate_width;
  side_plate_depth_y = side_plate_width + depth_y + side_plate_width;
  side_plate_height_z = height_z + bottom_plate_height_z;

  groove_width = banana_diameter + 0.5;

  // Groove to remove: width along the x and y.
  groove_size_x = side_plate_width_x;
  groove_size_y = groove_width;

  // Groove to remove: y and z position - where to start to remove.
  groove_y = 10.5;
  
  //  |  |  ..........................| 
  //  \__/  ..| <- groove_width/2     | ^
  //          | <- 10                 | | groove_z
  // ______ ..|.......................| v
  
  groove_z = 10 + groove_width/2;
  
  groove_y_center = groove_y + (groove_width/2);
  groove_height_z = side_plate_height_z - groove_z;

  difference() {
    translate([-side_plate_width, -side_plate_width, -bottom_plate_height_z]) {
      cube([side_plate_width_x, side_plate_depth_y, side_plate_height_z]);
    }
    translate([-side_plate_width, groove_y, groove_z]) {
      cube([groove_size_x, groove_size_y, groove_height_z]);
    }
    translate([-side_plate_width, groove_y_center, groove_z]) {
      rotate([00, 90, 0]) {
        cylinder(d=groove_width, h=side_plate_width);
      }
    }
  }
}

module side_plate_not_grooved() {
  side_plate_width_x = side_plate_width;
  side_plate_depth_y = side_plate_width + depth_y + side_plate_width;
  side_plate_height_z = height_z + bottom_plate_height_z;
  translate([width_x, -side_plate_width, -bottom_plate_height_z]) {
    cube([side_plate_width_x, side_plate_depth_y, side_plate_height_z]);
  }
}

module front_plate() {
  fp_height_z = 15;
  fp_y = depth_y;
  fp_x = 0;
  fp_z = -bottom_plate_height_z;
  translate([fp_x, fp_y, fp_z]) {
    cube([width_x, side_plate_width, fp_height_z]);
  }
}

module side_wall(x, y) {
  fsw_x = x;
  fsw_y = y;
  fsw_z = 0;
  translate([fsw_x, fsw_y, fsw_z]) {
    cube([return_wall_width_x, side_plate_width, height_z]);
  }
}

module back_wall() {
  // We extend things back by depth_negative_offset_y.
  translate([0, -depth_negative_offset_y, -bottom_plate_height_z]) {
    cube([width_x, depth_negative_offset_y, bottom_plate_height_z]);
  }
  translate([-side_plate_width, -depth_negative_offset_y - side_plate_width,
             -bottom_plate_height_z]) {
    cube([width_x + 2*side_plate_width, side_plate_width,
          height_z + bottom_plate_height_z]);	     
  }
}

module main_piece() {
  bottom_plate();
  side_plate_grooved();
  front_plate();
  side_plate_not_grooved();
  side_wall(0, depth_y);
  side_wall(width_x - return_wall_width_x, depth_y);
  back_wall();
}

module part() {
  difference() {
    main_piece();
    // Four grooves for straps to be passed through.
    translate([-side_plate_width, -depth_negative_offset_y, 15]) {
      cube([side_plate_width, depth_negative_offset_y, 22]);
    }
    translate([-side_plate_width, -depth_negative_offset_y, 55]) {
      cube([side_plate_width, depth_negative_offset_y, 22]);
    }
    translate([width_x, -depth_negative_offset_y, 15]) {
      cube([side_plate_width, depth_negative_offset_y, 22]);
    }
    translate([width_x, -depth_negative_offset_y, 55]) {
      cube([side_plate_width, depth_negative_offset_y, 22]);
    }
  }
}

part();


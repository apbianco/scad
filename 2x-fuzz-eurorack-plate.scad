// Eurorack plate that supports 2 fuzz effect described here:
// https://www.youtube.com/watch?v=CSTPOI6bUzI
//
// Measurements are straight out of data sheets (listed when available)
// and adjusted using caliper measurments made by hand.

{ // Controling variables for the eurorack plate:
  // - The thicknet of the panel: 2 or above
  panel_thickness = 2;
  // - Panel width in HP
  panel_width_in_hp = 5;
  // - Number of holes to generate
  number_of_holes = 2;
  // To add to the overall heigh to take into acount plastic retraction.
  height_fudge_value = 1;
  // - Set to true to create walls to improve rigidity
  walls = true;
  wall_size = 5;
}

{ // Derived constants and defined constants
  hole_width_ = 5.08;
  // Heights:
  // - Total height is 3U height
  panel_height_ = 133.35 + height_fudge_value;     // 3U height
  // - Panel height to right before the holes
  panel_outer_height_ = 128.5 + height_fudge_value;
  // - Panel height taking into account rail clearance
  panel_inner_height_ = 110 + height_fudge_value;
  // - Rail height computed as a function of panel height an inner height.
  rail_height_ = (panel_height_-panel_outer_height_)/2;
  mount_surface_height_ = (panel_outer_height_ - 
                           panel_inner_height_ - rail_height_*2)/2;
  
  kHP_ = 5.08;
  panel_width_ = panel_width_in_hp * kHP_;

  mount_hole_diameter_ = 3.2;
  mount_hole_rad_ = mount_hole_diameter_/2;
  hole_width_cube_width = hole_width_-mount_hole_diameter_;

  offset_to_mount_hole_center_x_ = kHP_; // 1hp margin on each side
  offset_to_mount_hole_center_y_ = mount_surface_height_/2;

  $fn=200;
}

module eurorackPanel(panel_width_in_hp,
                     mountHoles=2,
                     hw = hole_width_,
                     ignoreMountHoles=false) {
  difference() {
    cube([panel_width_, panel_outer_height_, panel_thickness]);
    if(!ignoreMountHoles) {
      eurorackMountHoles(panel_width_in_hp, mountHoles, hole_width_);
    }
  }
}

module eurorackMountHoles(php, holes, hw) {
 holes = holes-holes%2;
  eurorackMountHolesTopRow(php, hw, holes/2);
  eurorackMountHolesBottomRow(php, hw, holes/2);
}

module eurorackMountHolesTopRow(php, hw, holes) {
  translate([offset_to_mount_hole_center_x_,
             panel_outer_height_ - offset_to_mount_hole_center_y_,
             0]) {
    eurorackMountHole(hw);
  }
  if(holes > 1) {
    translate([(kHP_*php) - hole_width_cube_width - kHP_,
              panel_outer_height_ - offset_to_mount_hole_center_y_,
              0]) {
      eurorackMountHole(hw);
    }
  }
  if(holes > 2) {
    holeDivs = php*kHP_/(holes-1);
    for (i = [1:holes-2]) {
      translate([holeDivs*i,
                 panel_outer_height_ - offset_to_mount_hole_center_y_,
                 0]) {
        eurorackMountHole(hw);
      }
    }
  }
}

module eurorackMountHolesBottomRow(php, hw, holes) {
  // bottomRight
  translate([(kHP_*php)-hole_width_cube_width-kHP_,
              offset_to_mount_hole_center_y_,
              0]) {
    eurorackMountHole(hw);
  }
  if(holes>1) {
    translate([offset_to_mount_hole_center_x_,
               offset_to_mount_hole_center_y_,
               0]) {
     eurorackMountHole(hw);
    }
  }
  if(holes>2) {
    holeDivs = php*kHP_/(holes-1);
    for (i = [1:holes-2]) {
      translate([holeDivs*i,
                 offset_to_mount_hole_center_y_,
		             0]) {
        eurorackMountHole(hw);
      }
    }
  }
}

module eurorackMountHole(hw) {
  // because diffs need to be larger than the object they are being
  // diffed from for ideal BSP operations
  mountHoleDepth = panel_thickness+2;
    
  if(hole_width_cube_width<0) {
    hole_width_cube_width=0;
  }
  translate([0,0,-1]) {
    union() {
      cylinder(r=mount_hole_rad_, h=mountHoleDepth);
      translate([0,-mount_hole_rad_,0]){
        cube([hole_width_cube_width, mount_hole_diameter_, mountHoleDepth]);
      }
      translate([hole_width_cube_width,0,0]) {
        cylinder(r=mount_hole_rad_, h=mountHoleDepth);
      }
    }
  }
}

module 3dot5mm_plug(x, y, drawVolume) {
  // From https://docs.rs-online.com/8a00/0900766b8158190a.pdf
  hole_diameter = 7;
  nut_diameter = 9;
  translate([x, y, -1]) {
    cylinder(d=hole_diameter, h=panel_thickness+1.5);
  }
  if (drawVolume) {
    translate([x, y, -0.3]) {
      color([0.4,0.5,0.5]) {
        cylinder(d=nut_diameter, h=0.5);
      }
    }
  }
}

module 3dot5mm_box(x, y) {
  // https://docs.rs-online.com/8a00/0900766b8158190a.pdf
  translate([x - 5, y - 5.6, 2]) {
    color([0.3, 0.1, 0.1], 0.5) {
      cube([9, 10.5, 9]);
    }
  }
  translate([x - 3.8, y - 4.4, 11]) {
    color([0.3, 0.3, 0.1], 0.5) {
      cube([3.8+0.9*2, 3.7+4.4, 5]);
    }
  }
}


module potentiometer(x, y, drawVolume) {
  // https://docs.rs-online.com/1db0/0900766b813604b9.pdf
  hole_diameter = 7;
  nut_diameter = 14;
  translate([x, y, -1]) {
    cylinder(d=hole_diameter, h=panel_thickness+1.5);
  }
  if (drawVolume) {
    translate([x, y, -0.3]) {
      color([0.4,0.5,0.5]) {
        cylinder(d=nut_diameter, h=0.5);
      }
    }
  }  
}


module potentiometer_box(x, y) {
  // https://docs.rs-online.com/1db0/0900766b813604b9.pdf
  width = 20;
  length = 25.2 + 4;
  depth = 10.7;
  button_diameter = 15.9;
  button_height = 12;
  translate([x - width/2, y - width/2, panel_thickness]) {
     color([0.3, 0.1, 0.1], 0.5) {
       cube([width, length, depth]);
     }   
  }
  translate([x, y, -0.5 - button_height]) {
    color([0.3, 0.1, 0.1], 0.5) {   
      cylinder(d=button_diameter, h=button_height);
    }
  }
}


module fuzz(y, draw_text, draw_volume) {
  potentiometer_x = panel_width_/2;
  potentiometer_y = y;
  
  first_plug_x = panel_width_/3-1;
  first_plug_y = potentiometer_y + 30;
  
  second_plug_x = 2*panel_width_/3+2;
  second_plug_y = first_plug_y;
  engraving_depth = 0.5;
  
  3dot5mm_plug(first_plug_x, first_plug_y, draw_volume);
  3dot5mm_plug(second_plug_x, second_plug_y, draw_volume);
  potentiometer(potentiometer_x, potentiometer_y, draw_volume);
  if (draw_text) {
    translate([first_plug_x, first_plug_y-7, engraving_depth]) {
      rotate([180, 0, 0]) {
        linear_extrude(engraving_depth) {
          text("in", size=5, halign="center", font="roboto condensed bold");
        }
      }
    }
    translate([second_plug_x, second_plug_y+10, engraving_depth]) {
      rotate([180, 0, 0]) {
        linear_extrude(engraving_depth) {
          text("out", size=5, halign="center", font="roboto condensed bold");
        }
      }
    }
  }
}

module fuzz_volume(y) {  
  potentiometer_x = panel_width_/2;
  potentiometer_y = y;
  
  first_plug_x = panel_width_/3-1;
  first_plug_y = potentiometer_y + 30;
  
  second_plug_x = 2*panel_width_/3+2;
  second_plug_y = first_plug_y;
  
  3dot5mm_box(first_plug_x, first_plug_y);
  3dot5mm_box(second_plug_x, second_plug_y);
  potentiometer_box(potentiometer_x, potentiometer_y);
}


{ // Controling variables for this design
  
  // - Draw volumes
  draw_volume = true;
  draw_text = false;
  wall_width = 2;
  divider_groove = 1;
}


{ // Design
  middle = panel_height_/2 - 3*wall_width/2;
  difference() {
    eurorackPanel(panel_width_in_hp, number_of_holes, hole_width_);
    fuzz(20, draw_text, draw_volume);
    
    translate([1, middle, 0]) {
      cube([panel_width_-2, divider_groove, divider_groove]);
    }
    fuzz(10+(panel_height_/2), draw_text, draw_volume);
  }
  if (draw_volume) {
    fuzz_volume(20);
    fuzz_volume(10+(panel_height_/2));
  }
  
  if (walls) {
    size = [wall_width,panel_outer_height_-20,wall_size];
    translate([0,10,1]){
      cube(size);
    }
    translate([panel_width_ - wall_width,10,1]) {
      cube(size);
    }
    translate([0, middle, 1]) {
      cube([panel_width_, wall_width, wall_size+15]);
    }
  }
}

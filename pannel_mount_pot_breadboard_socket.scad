// Socket for the 6mm board-mount pot - RS part #106-874.
// Allows one to solder pins and then your board-mount socket is ready
// to be used on a breadboard.
//
// I use a gyroid fill for that one - the top brack remains fragile.

{ // Part dimensions
  body_diameter = 20.5;
  body_height_z = 6;
  body_epoxy_height_z = 7.5;
  axis_protrusion_z = 2.5;
  axis_diameter = 6.75;  // Real diameter is 6, allow for some play

  epoxy_deck_height_z = 1.25;
  epoxy_deck_width_x = 19;
  epoxy_deck_length_y = 23;

  epoxy_deck_connector_length_y = 30;
  connector_length_y = 6;
  
  pin_hole_diameter = 1.25;
  thickness = 1;

  epoxy_thread_offset_z = 3;
  thread_diameter = 12;
  thread_bracket_length_y = 16;

  $fn=200;

  // Set to true to visualize the pot axis and the retention bolt
  // thread.
  draw_pot_axis = false;
}

function pot_axis_coordinates() = [
  (body_diameter + 3*thickness)/2 - thickness,
  epoxy_deck_connector_length_y + thickness - body_diameter/2];

module base() {
  w = body_diameter + 3*thickness;
  l = epoxy_deck_connector_length_y + 2*thickness;
  h = body_epoxy_height_z + axis_protrusion_z;
  pot_axis_x = pot_axis_coordinates()[0];
  pot_axis_y = pot_axis_coordinates()[1];
  difference() {
    cube([w, l, h]);
    // Now we carve out the location for the main body to fit in. Take
    // the epoxy thickness into account.
    translate([pot_axis_x, pot_axis_y, thickness + axis_protrusion_z]) {
      cylinder(d=body_diameter, body_epoxy_height_z);
    }
    // Now we carve out some space for the tip of the axis to be able
    // to rotate.
    translate([pot_axis_x, pot_axis_y, thickness]) {
      cylinder(d=axis_diameter, axis_protrusion_z);
    }
    // Now we carve out some space for front part of the epoxy
    // board to rest
    translate([(w - epoxy_deck_width_x)/2 - thickness,
               thickness, h - epoxy_deck_height_z]) {
      cube([epoxy_deck_width_x, 20, epoxy_deck_height_z]);
    }
  }
  if (draw_pot_axis) {
    translate([pot_axis_x, pot_axis_y, thickness]) {
      color("red", 0.5) {
        cylinder(d=axis_diameter, 30);
      }
    }
    translate([pot_axis_x, pot_axis_y, h+1.5]) {
      color("red", 0.5) {
        cylinder(d=thread_diameter, 5);
      }
    }
  }
}

module bracket() {
  z_start = body_epoxy_height_z + axis_protrusion_z;
  z_start_thread = z_start+epoxy_thread_offset_z;
  bracket_width_x = 19;
  b_thickness = 2*thickness;
  pot_axis_x = pot_axis_coordinates()[0];
  pot_axis_y = pot_axis_coordinates()[1];
  lh = ((epoxy_deck_connector_length_y + b_thickness) -
        thickness - body_diameter/2) - thread_bracket_length_y/2;
  difference() {
    // The while bracket
    union() {
      // First a raiser to attach the brack to the rest of the part
      translate([body_diameter + thickness/2, lh, z_start]) { 
        cube([2.5*thickness, thread_bracket_length_y, epoxy_thread_offset_z]);
      }
      translate([body_diameter + 3*thickness - bracket_width_x, lh,
                 z_start + epoxy_thread_offset_z]) {
        cube([bracket_width_x, thread_bracket_length_y, b_thickness]);
      }
    }
    // And now we take out the space for the threads part of the pot
    // to fit in.
    w_x = body_diameter + 3*thickness - bracket_width_x;
    l_y_h = (epoxy_deck_connector_length_y + thickness - body_diameter/2 -
             thread_diameter/2);
    translate([w_x, l_y_h, z_start + epoxy_thread_offset_z]) {
      cube([6, thread_bracket_length_y, b_thickness]);
    }
    translate([pot_axis_x, pot_axis_y, z_start + epoxy_thread_offset_z]) {
      cylinder(d=thread_diameter, h=b_thickness);
    }
    translate([body_diameter + 3*thickness - bracket_width_x, lh,
               z_start_thread]) {
      cube([3, thread_bracket_length_y, b_thickness]);
    }
  }
  rounded_return_diameter = (body_diameter - thread_bracket_length_y)/2;
  translate([pot_axis_x+0.2,
             pot_axis_y + body_diameter/2 - 1.5*rounded_return_diameter + 0.05,
	     z_start_thread]) {
    scale([1.5, 1, 1]) {	     
      cylinder(d=rounded_return_diameter, h=b_thickness);
    }      
  }
  translate([body_diameter + 3*thickness - bracket_width_x + 3,
             lh + rounded_return_diameter/2 - 0.05,
             z_start_thread]) {
    scale([1.5, 1, 1]) {	     
      cylinder(d=rounded_return_diameter, h=b_thickness);
   }
  }
}

module pin_holes() {
  difference() {
  }
}

module part() {
  first_pin_offset_w = pot_axis_coordinates()[0];
  height = body_epoxy_height_z + axis_protrusion_z;
  length = epoxy_deck_connector_length_y + thickness;

  difference() {
    union() {
      base();
      bracket();
      translate([0, -1.5*thickness, 0]) {
        cube([body_diameter + 3*thickness, 1.5*thickness, height]);
      }
    }
    translate([first_pin_offset_w, 0, 0]) {
      cylinder(d=pin_hole_diameter, h=height);
      // Groves to let the pin reach the pot connector.
      translate([-0.2-pin_hole_diameter/2, -thickness, height - 0.5]) {
        cube([pin_hole_diameter+0.4, 2*thickness, 0.5]);      
      }
    }
    translate([first_pin_offset_w - 2*2.54, 0, 0]) {
      cylinder(d=pin_hole_diameter, h=height);
      // Groves to let the pin reach the pot connector.
      translate([-0.2-pin_hole_diameter/2, -thickness, height - 0.5]) {
        cube([pin_hole_diameter+0.4, 2*thickness, 0.5]);      
      }
      translate([-2.54, length-thickness, 0]) {
        cylinder(d=pin_hole_diameter, h=90*height/100);
      }
    }
    translate([first_pin_offset_w + 2*2.54, 0, 0]) {
      cylinder(d=pin_hole_diameter, h=height);
      // Groves to let the pin reach the pot connector.
      translate([-0.2-pin_hole_diameter/2, -thickness, height - 0.5]) {
        cube([pin_hole_diameter+0.4, 2*thickness, 0.5]);      
      }
      translate([2.54, length-thickness, 0]) {
        cylinder(d=pin_hole_diameter, h=75*height/100);
      }
    }
  }    
}

part();

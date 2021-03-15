// Feet for radiator support rods

{
  base_width_x = 40;
  base_width_y = 30;
  base_width_z = 4;

  internal_diameter = 20;
  external_diameter = 25;
  
  center_x = base_width_x/2;
  center_y = base_width_y/2;
  center_z = base_width_z;

  tube_support_z = 10;

  $fn = 200;
}

cube([base_width_x, base_width_y, base_width_z]);
difference() {
  translate([center_x, center_y, center_z]) {
    cylinder(d=external_diameter, h=tube_support_z);
  }
  translate([center_x, center_y, center_z]) {
    cylinder(d=internal_diameter, h=tube_support_z+0.2);
  }
}

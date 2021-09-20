{
  thickness = 1;
  inner_diameter = 6.5;
  outer_diameter = 9.5;
  $fn = 200;
}

difference() {
  cylinder(d=outer_diameter, h=thickness);
  cylinder(d=inner_diameter, h=thickness);
}



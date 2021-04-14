{ // Dimensions
  diameter1 = 9.75;
  diameter2 = 2.5;
  depth1 = 4.25;
  depth2 = 5.75 - depth1;

  $fn = 200;
}

cylinder(d=diameter1, h=depth1);
translate([0, 0, depth1]) {
  cylinder(d=diameter2, h=depth2);
}
// Print logs:
//
// - 1/7:  Eryone black, 215C Z offset -1.86 or so.
// - 1/8:  Eryone black, 210C Z offset -1.86 or so. Really stuck to the plate,
//         Needs a bit of a positive X offset (1 or 2 mm.)
// - 1/16: Eryone black, 210C (after fixing the thermistor - 210 might be too
//         high - severe warping but otherwise good. Lower support requires
//         using a small-size screw, top bracket need to recess maybe 1mm.
//         These adjustments haven't been do to this version.

panelThickness = 2;
panelHp = 10;
holeCount = 4;
holeWidth = 5.08;

walls = true;
wall_size = 5;

heightFudgeFactor = 1;
threeUHeight = 133.35 + heightFudgeFactor;     // 3U height
panelOuterHeight = 128.5 + heightFudgeFactor;
panelInnerHeight = 110;    // Rail clearance = ~11.675mm, top and bottom
railHeight = (threeUHeight-panelOuterHeight)/2;
mountSurfaceHeight = (panelOuterHeight-panelInnerHeight-railHeight*2)/2;

hp = 5.08;
panelWidth = panelHp * hp;
mountHoleDiameter = 3.2;
mountHoleRad = mountHoleDiameter/2;
hwCubeWidth = holeWidth-mountHoleDiameter;

offsetToMountHoleCenterY = mountSurfaceHeight/2;
offsetToMountHoleCenterX = hp; // 1hp margin on each side

echo(offsetToMountHoleCenterY);
echo(offsetToMountHoleCenterX);
echo("Pannel width: ", panelWidth);

$fn=200;

module eurorackPanel(panelHp,
                     mountHoles=2,
                     hw = holeWidth,
                     ignoreMountHoles=false) {
  difference() {
    cube([panelWidth,panelOuterHeight,panelThickness]);
    if(!ignoreMountHoles) {
      eurorackMountHoles(panelHp, mountHoles, holeWidth);
    }
  }
}

module eurorackMountHoles(php, holes, hw) {
 holes = holes-holes%2;
  eurorackMountHolesTopRow(php, hw, holes/2);
  eurorackMountHolesBottomRow(php, hw, holes/2);
}

module eurorackMountHolesTopRow(php, hw, holes) {
  translate([offsetToMountHoleCenterX,
             panelOuterHeight - offsetToMountHoleCenterY,
             0]) {
    eurorackMountHole(hw);
  }
  if(holes > 1) {
    translate([(hp*php) - hwCubeWidth - hp,
              panelOuterHeight - offsetToMountHoleCenterY,
              0]) {
      eurorackMountHole(hw);
    }
  }
  if(holes > 2) {
    holeDivs = php*hp/(holes-1);
    for (i = [1:holes-2]) {
      translate([holeDivs*i,
                 panelOuterHeight - offsetToMountHoleCenterY,
                 0]) {
        eurorackMountHole(hw);
      }
    }
  }
}

module eurorackMountHolesBottomRow(php, hw, holes) {
  // bottomRight
  translate([(hp*php)-hwCubeWidth-hp,
              offsetToMountHoleCenterY,
              0]) {
    eurorackMountHole(hw);
  }
  if(holes>1) {
    translate([offsetToMountHoleCenterX,
               offsetToMountHoleCenterY,
               0]) {
     eurorackMountHole(hw);
    }
  }
  if(holes>2) {
    holeDivs = php*hp/(holes-1);
    for (i = [1:holes-2]) {
      translate([holeDivs*i,
                 offsetToMountHoleCenterY,
		             0]) {
        eurorackMountHole(hw);
      }
    }
  }
}

module eurorackMountHole(hw) {
  // because diffs need to be larger than the object they are being
  // diffed from for ideal BSP operations
  mountHoleDepth = panelThickness+2;
    
  if(hwCubeWidth<0) {
    hwCubeWidth=0;
  }
  translate([0,0,-1]) {
    union() {
      cylinder(r=mountHoleRad, h=mountHoleDepth);
      translate([0,-mountHoleRad,0]){
        cube([hwCubeWidth, mountHoleDiameter, mountHoleDepth]);
      }
      translate([hwCubeWidth,0,0]) {
        cylinder(r=mountHoleRad, h=mountHoleDepth);
      }
    }
  }
}

module Board(x, y, tol=0.5, drawVolume=false) {
  // DIN specs:
  // eu.mouser.com/datasheet/2/46/Belden_06112018_MAB_5_SH-1370803.pdf
  translate([x, y, -1]) {
    // DIN #1  
    // From the top of the board to the middle of the
    // first DIN, there's ~23mm
    translate([0, -23, 0]) {
      cylinder(d=14, h=panelThickness+3);
    }
    // DIN #2
    translate([0, -44.2 - tol, 0]) {
      cylinder(d=14, h=panelThickness+3);
    }
    // Operating LED
    translate([0, -65.7 - tol, 0]) {
      cylinder(d=3, h=panelThickness+3);
    }
  }
  // Contour
  if (drawVolume) {
    translate([x-12.5, y-77.5, -0.3]) {
      color([0.3, 0.1, 0.1]) {
	cube([24, 77.5, 0.5]);
      }
    }
  }
}

module Board2(x, y, drawVolume=false) {
  if (drawVolume) {
    translate([x+10.28, y-77.5, 2]) {
      color([0.3, 0.1, 0.1], 0.25) {
        cube([1.66, 77.5, 67]);
      }
    }
  }
}

module MountingBracket(x, y) {
  x_offset = 13.44
  // Hole #1: support to be drilled with a hole
  translate([x+x_offset, y-77.5, panelThickness]) {
    cube([11.96, 6.5, 10]);
  }
  translate([x+x_offset-6.67, y-77.5, 2]) {
    cube([5, 6.5, 10]);
  }
  // Support for the hole #2
  translate([x+x_offset+1, y-20, panelThickness]) {
    cube([10.96, 20, 30]);
  }
  // Botton guide for second support
  translate([x+x_offset-0.4, y-10, panelThickness]) {
    cube([10, 10, 4]);
  }
}

module 3dot5mm_plug(x, y, drawVolume=false) {
  translate([x, y, -1]) {
    cylinder(d=7, h=panelThickness+3);
  }
  if (drawVolume) {
    translate([x, y, -0.3]) {
      color([0.4,0.5,0.5]) {
        cylinder(d=9, h=0.5);
      }
    }
  }
}

module 3dot5mm_box(x, y) {
  translate([x - 5, y - 5.6, 2]) {
    color([0.3, 0.1, 0.1], 0.5) {
      cube([9, 10.5, 9]);
    }
  }
  translate([x - 3.8, y - 4.4, 11]) {
    color([0.3, 0.3, 0.1], 0.5) {
      cube([5.6, 8.1, 5]);
    }
  }
}

{ // Part paramaters
  // Draw the volumes - set to false to print.
  drawVolume = false;

  // Set to true to view a projection.
  project = false;
  project_z = 4;
  
  // 3.5mm jack spacings
  3dot5mm_spacing_x = 11.5;
  3dot5mm_spacing_y = 15;
  // 3.5mm main row, first jack location
  3dot5mm_row_x_offset = 7.75;
  3dot5mm_row_y_offset = 20;

  // 3.5mm second row, first jack location
  3dot5mm_row2_x_offset = 3dot5mm_row_x_offset;
  3dot5mm_row2_y_offset = 47.5;

  // Location of the two DIN connectors
  din_x_offset = 25.4;
  din_y_offset = 121;
}

module MTV16_Board() {
  difference () {
    eurorackPanel(panelHp, holeCount, holeWidth);
    Board(din_x_offset, din_y_offset, drawVolume=drawVolume);
    for(j = [0:1]) {
      for(i = [0:3]) {
	3dot5mm_plug(3dot5mm_row_x_offset + i*3dot5mm_spacing_x,
		     3dot5mm_row_y_offset + j*3dot5mm_spacing_y,
		     drawVolume);
      }
    }
    translate([din_x_offset+13, din_y_offset - 26, 1]) {
      rotate([0, 180, 0]) {
        linear_extrude(height=1, convexity=5) {
          text("►", size=6, halign="center", font="Impact");
	}
      }
    }
    translate([din_x_offset-13, din_y_offset - 47.2, 1]) {
      rotate([0, 180, 0]) {
        linear_extrude(height=1, convexity=5) {
          text("►", size=6, halign="center", font="Impact");
	}
      }
    }
    translate([panelWidth-3, panelInnerHeight+5, 1]) {
      rotate([0, 180, 0]) {
	linear_extrude(height=1, convexity=5) {
	  text("MTV-16", size=6, halign="left", font="Impact");
	}
      }
    }
  }

  Board2(din_x_offset, din_y_offset, drawVolume=drawVolume);
  MountingBracket(din_x_offset, din_y_offset);

  // Volume occupied by the 3.5mm jack mounts
  if (drawVolume) {
    for(j = [0:1]) {
      for(i = [0:3]) {
	3dot5mm_box(3dot5mm_row_x_offset + i*3dot5mm_spacing_x,
		    3dot5mm_row_y_offset + j*3dot5mm_spacing_y);
      }
    }
  }

  if (walls) {
    size = [2,panelOuterHeight-20,wall_size];
    translate([0,10,1]){
      cube(size);
    }
    translate([panelWidth-2,10,1]) {
      cube(size);
    }
  }
}

if (project) {
  projection(cut=true) {
    translate([0, 0, -project_z]) {
      MTV16_Board();
    }
  }
} else {
  MTV16_Board();
}

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

/*
Triangles.scad
 Author: Tim Koopman
 https://github.com/tkoopman/Delta-Diamond/blob/master/OpenSCAD/Triangles.scad

         angleCA
           /|\
        a / H \ c
         /  |  \
 angleAB ------- angleBC
            b

Standard Parameters
	center: true/false
		If true same as centerXYZ = [true, true, true]

	centerXYZ: Vector of 3 true/false values [CenterX, CenterY, CenterZ]
		center must be left undef

	height: The 3D height of the Triangle. Ignored if heights defined

	heights: Vector of 3 height values heights @ [angleAB, angleBC, angleCA]
		If CenterZ is true each height will be centered individually, this means
		the shape will be different depending on CenterZ. Most times you will want
		CenterZ to be true to get the shape most people want.
*/

/* 
Triangle
	a: Length of side a
	b: Length of side b
	angle: angle at point angleAB
*/
module Triangle(
			a, b, angle, height=1, heights=undef,
			center=undef, centerXYZ=[false,false,false])
{
	// Calculate Heights at each point
	heightAB = ((heights==undef) ? height : heights[0])/2;
	heightBC = ((heights==undef) ? height : heights[1])/2;
	heightCA = ((heights==undef) ? height : heights[2])/2;
	centerZ = (center || (center==undef && centerXYZ[2]))?0:max(heightAB,heightBC,heightCA);

	// Calculate Offsets for centering
	offsetX = (center || (center==undef && centerXYZ[0]))?((cos(angle)*a)+b)/3:0;
	offsetY = (center || (center==undef && centerXYZ[1]))?(sin(angle)*a)/3:0;
	
	pointAB1 = [-offsetX,-offsetY, centerZ-heightAB];
	pointAB2 = [-offsetX,-offsetY, centerZ+heightAB];
	pointBC1 = [b-offsetX,-offsetY, centerZ-heightBC];
	pointBC2 = [b-offsetX,-offsetY, centerZ+heightBC];
	pointCA1 = [(cos(angle)*a)-offsetX,(sin(angle)*a)-offsetY, centerZ-heightCA];
	pointCA2 = [(cos(angle)*a)-offsetX,(sin(angle)*a)-offsetY, centerZ+heightCA];

	polyhedron(
		points=[	pointAB1, pointBC1, pointCA1,
					pointAB2, pointBC2, pointCA2 ],
		triangles=[	
			[0, 1, 2],
			[3, 5, 4],
			[0, 3, 1],
			[1, 3, 4],
			[1, 4, 2],
			[2, 4, 5],
			[2, 5, 0],
			[0, 5, 3] ] );
}

module Right_Angled_Triangle(
			a, b, height=1, heights=undef,
			center=undef, centerXYZ=[false, false, false])
{
	Triangle(a=a, b=b, angle=90, height=height, heights=heights,
				   center=center, centerXYZ=centerXYZ);
}


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
  // DIN #1
  translate([x, y, -1]) {
    cylinder(d=14, h=panelThickness+3);
  }
  // DIN #2
  translate([x, y - 21.2 + tol, -1]) {
    cylinder(d=14, h=panelThickness+3);
  }
  // Operating LED
  translate([x, y - 21.2 - tol - 15, -1]) {
    cylinder(d=3, h=panelThickness+3);
  }

  // Contour
  if (drawVolume) {
    translate([x-14, y-47, -0.3]) {
      color([0.3, 0.1, 0.1]) {
       cube([24, 58, 0.5]);
      }
    }
  }
}

module fuzzBoard(x, y, drawVolume=false) {
  translate([x, y, -1]) {
    cylinder(d=7, h=panelThickness+3);
  }
  3dot5mm_plug(x+6, y-21.2, drawVolume);
  3dot5mm_plug(x+6-1.5*3dot5mm_row_x_offset, y-21.2, drawVolume);
}

module Board2(x, y, drawVolume=false) {
  if (drawVolume) {
    translate([x+9, y-47, 2]) {
      color([0.3, 0.1, 0.1], 0.25) {
        cube([1, 58, 67]);
      }
    }
  }
}

module MountingBracket(x, y) {
 difference() {
    // L shaped bracket
    translate([x+10, y-47, 0]) {
      cube([2, 18, 40]);
    }
    translate([x+9, y-40, 5]) {
      cube([4, 20, 50]);
    } 
    // First mounting hole
    translate([x+9, y-45, 4]) {
      rotate([0,90,0]) {
        cylinder(d=2, h=4);
      }
    }
    // Second mounting hole
    translate([x+9, y-45, 10.5]) {
      rotate([0,90,0]) {
        cylinder(d=2, h=4);
      }
    }   
    // Third mounting hole
    translate([x+9, y-45, 18]) {
      rotate([0,90,0]) {
        cylinder(d=2, h=4);
      }
    }      
  }
  // Support leg
  translate([x+12, y-40.5, 2]) {
    rotate([90,0,0]) {
      Right_Angled_Triangle(a=30, b=10, height=2);
    }
  }  
}

module 3dot5mm_plug(x, y, drawVolume=false) {
  translate([x, y, -1]) {
    cylinder(d=6, h=panelThickness+3);
  }
  if (drawVolume) {
    translate([x, y, -0.3]) {
      color([0.4,0.5,0.5]) {
        cylinder(d=8, h=0.5);
      }
    }
  }
}

module 3to5mm_box(x, y) {
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

drawVolume = false;  // Draw the volumes
fitFuzz = false;      // Fit a fuzz
3dot5mm_spacing_x = 11.5;
3dot5mm_spacing_y = 11.5;
3dot5mm_row_x_offset = 7.75;
3dot5mm_row_y_offset = 15;

// Where the first MIDI din will appear. This change if the fuzz
// is added to the plate

fuzz_offset = 10;

din_x_offset = 25.4; // - fuzz_offset;
din_y_offset = 110;

fuzz_x_offset = din_x_offset + 22;
fuzz_y_offset = din_y_offset;

difference () {
  eurorackPanel(panelHp, holeCount, holeWidth);
  Board(din_x_offset, din_y_offset, drawVolume=drawVolume);
  for(j = [0:3]) {
    for(i = [0:3]) {
      3dot5mm_plug(3dot5mm_row_x_offset + i*3dot5mm_spacing_x,
                   3dot5mm_row_y_offset + j*3dot5mm_spacing_y,
                   drawVolume);
    }
  }
  if (fitFuzz) {
    fuzzBoard(fuzz_x_offset, fuzz_y_offset, drawVolume=drawVolume);
  }
}

Board2(din_x_offset, din_y_offset, drawVolume=drawVolume);
MountingBracket(din_x_offset, din_y_offset);

// Volume occupied by the 3.5mm jack mounts
if (drawVolume) {
  for(j = [0:3]) {
    for(i = [0:3]) {
      if (drawVolume) {
        3to5mm_box(3dot5mm_row_x_offset + i*3dot5mm_spacing_x,
                  3dot5mm_row_y_offset + j*3dot5mm_spacing_y);
      }
    }
  }
  if (fitFuzz) {
    3to5mm_box(fuzz_x_offset + 6, fuzz_y_offset-21.2);
    3to5mm_box(fuzz_x_offset + 6 - 1.5*3dot5mm_row_x_offset,
               fuzz_y_offset-21.2);
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
  translate([0, 56, 1]) {
    cube([panelWidth, 2, wall_size]);
  }
}



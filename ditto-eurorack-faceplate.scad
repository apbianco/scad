
panelThickness = 2;
panelHp=10;
holeCount=4;
holeWidth = 5.08; //If you want wider holes for easier mounting. Otherwise set to any number lower than mountHoleDiameter. Can be passed in as parameter to eurorackPanel()


heightFudgeFactor = 1;
threeUHeight = 133.35 + heightFudgeFactor;     // 3U height
panelOuterHeight = 128.5 + heightFudgeFactor;
panelInnerHeight = 110; //rail clearance = ~11.675mm, top and bottom
railHeight = (threeUHeight-panelOuterHeight)/2;
mountSurfaceHeight = (panelOuterHeight-panelInnerHeight-railHeight*2)/2;

echo("mountSurfaceHeight",mountSurfaceHeight);

hp=5.08;
mountHoleDiameter = 3.2;
mountHoleRad =mountHoleDiameter/2;
hwCubeWidth = holeWidth-mountHoleDiameter;

offsetToMountHoleCenterY=mountSurfaceHeight/2;
offsetToMountHoleCenterX = hp - hwCubeWidth/2; // 1 hp from side to center of hole

echo(offsetToMountHoleCenterY);
echo(offsetToMountHoleCenterX);

module eurorackPanel(panelHp,  mountHoles=2, hw = holeWidth, ignoreMountHoles=false)
{
    //mountHoles ought to be even. Odd values are -=1
    difference()
    {
        cube([hp*panelHp,panelOuterHeight,panelThickness]);
        
        if(!ignoreMountHoles)
        {
            eurorackMountHoles(panelHp, mountHoles, holeWidth);
        }
    }
}

module eurorackMountHoles(php, holes, hw)
{
    holes = holes-holes%2;//mountHoles ought to be even for the sake of code complexity. Odd values are -=1
    eurorackMountHolesTopRow(php, hw, holes/2);
    eurorackMountHolesBottomRow(php, hw, holes/2);
}

module eurorackMountHolesTopRow(php, hw, holes)
{
    
    //topleft
    translate([offsetToMountHoleCenterX,panelOuterHeight-offsetToMountHoleCenterY,0])
    {
        eurorackMountHole(hw);
    }
    if(holes>1)
    {
        translate([(hp*php)-hwCubeWidth-hp,panelOuterHeight-offsetToMountHoleCenterY,0])
    {
        eurorackMountHole(hw);
    }
    }
    if(holes>2)
    {
        holeDivs = php*hp/(holes-1);
        for (i =[1:holes-2])
        {
            translate([holeDivs*i,panelOuterHeight-offsetToMountHoleCenterY,0]){
                eurorackMountHole(hw);
            }
        }
    }
}

module eurorackMountHolesBottomRow(php, hw, holes)
{
    
    //bottomRight
    translate([(hp*php)-hwCubeWidth-hp,offsetToMountHoleCenterY,0])
    {
        eurorackMountHole(hw);
    }
    if(holes>1)
    {
        translate([offsetToMountHoleCenterX,offsetToMountHoleCenterY,0])
    {
        eurorackMountHole(hw);
    }
    }
    if(holes>2)
    {
        holeDivs = php*hp/(holes-1);
        for (i =[1:holes-2])
        {
            translate([holeDivs*i,offsetToMountHoleCenterY,0]){
                eurorackMountHole(hw);
            }
        }
    }
}

module eurorackMountHole(hw)
{
    
    mountHoleDepth = panelThickness+2; //because diffs need to be larger than the object they are being diffed from for ideal BSP operations
    
    if(hwCubeWidth<0)
    {
        hwCubeWidth=0;
    }
    translate([0,0,-1]){
    union()
    {
        cylinder(r=mountHoleRad, h=mountHoleDepth, $fn=20);
        translate([0,-mountHoleRad,0]){
        cube([hwCubeWidth, mountHoleDiameter, mountHoleDepth]);
        }
        translate([hwCubeWidth,0,0]){
            cylinder(r=mountHoleRad, h=mountHoleDepth, $fn=20);
            }
    }
}
}

module alex_rack() {
    
    led_d = 4;
    nob1_d = 6;
    fp_button1_d = 8;
    3dot5mm_plug1_d = 6;  // M6 thread
    3dot5mm_y = 20;
    6dot35mm_plug1_d = 9.525;  // 3/8 inich
    6dot35mm_y = 35;
    
    group() {
        difference() {
            group() {
                eurorackPanel(panelHp, holeCount,holeWidth);
            }
            
            // LED hole
            translate([25,80,0]) cylinder(d=led_d,h=10);
            
            // nob 1
            translate([25,110,0]) cylinder(d=nob1_d, h=10);
            
            // foot pedel button 1
            translate([25,55,0]) cylinder(d=fp_button1_d, h=10);
            
            // 1/4" input 
            translate([12.5,6dot35mm_y,0]) cylinder(d=6dot35mm_plug1_d, h=10);
            translate([12.5+25,6dot35mm_y,0]) cylinder(d=6dot35mm_plug1_d, h=10);
            //input/output plug
            translate([12.5,3dot5mm_y,0]) cylinder(d=3dot5mm_plug1_d, h=10);
            translate([12.5+25,3dot5mm_y,0]) cylinder(d=3dot5mm_plug1_d, h=10);
        }
    }
}

module slot(d,l,t=4) {
    translate([0,-l/2,0]) cylinder(d=d,h=t);
    translate([0, l/2,0]) cylinder(d=d,h=t);
    translate([-d/2, -l/2,0]) cube([d,l,t]);
}


module alex_rack2() {
  fp_button1_d = 11.5; //8;
  fp_button1_slot_l = 5;
  fp_y = 50;   // controls board "y"
  led_d = 4;
  led_slot_l = 0;
  led_slot_y = fp_y+25.25;
  nob1_d = 7;
  nob1_slot_l = 5;
  nob1_y = fp_y+58.9;
    
  // plug spec
  plug_y_offset = 15;
  3dot5mm_plug1_d = 6.5;  // M6 thread
  3dot5mm_y = 12.25;
  6dot35mm_plug1_d = 11.5; // 9.525;  // 3/8 inich
  6dot35mm_y = 3dot5mm_y + plug_y_offset;
    
  // re-enforcement structure
  re_d = 3;
  re_l = 110;
  re_y_offset= 10;
  re_x_offset= 2;
  cover_w = 50.8;
    
  t = 3;
  face_t = 3;
  group() {
    translate([re_x_offset,re_y_offset,2]) {
      cube([2, 110, 3]);
    }
    translate([cover_w-re_x_offset-2,re_y_offset,2]) {
      cube([2, 110, 3]);
    }
    difference() {
      group() {
        eurorackPanel(panelHp, holeCount,holeWidth);
        translate([re_x_offset,fp_y-5,0]) {
          cube([50-re_x_offset*2,10,t]);
        }
        group() {
          // LED hole
          // foot pedel button 1
          translate([25,fp_y,0]) {
            slot(fp_button1_d+t*2, fp_button1_slot_l, t=t);
            // 1/4" input
	  }
        }
      }
      // board thruhulls
      group() {
        // LED hole
        translate([25,led_slot_y,0]) {
	  slot(led_d,led_slot_l);
        }      
        // nob 1
        translate([25,nob1_y,0]) {
	  slot(nob1_d, nob1_slot_l);
        }
        // foot pedel button 1
        translate([25,fp_y,0]) {
	  slot(fp_button1_d, fp_button1_slot_l);
        }
      }            
      // 1/4" input 
      translate([12.5,6dot35mm_y,0]) {
        cylinder(d=6dot35mm_plug1_d, h=10);
      }
      translate([12.5+25,6dot35mm_y,0]) {
        cylinder(d=6dot35mm_plug1_d, h=10);
      }
      //input/output plug
      translate([12.5,3dot5mm_y,0]) {
        cylinder(d=3dot5mm_plug1_d, h=10);
      }
      translate([12.5+25,3dot5mm_y,0]) {
        cylinder(d=3dot5mm_plug1_d, h=10);
      }
    }
  }
}

$fn=60;
alex_rack2();

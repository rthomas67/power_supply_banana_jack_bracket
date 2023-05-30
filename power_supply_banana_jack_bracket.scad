/*
 * 12v Power Supply Banana Jack Bracket
 * Screws on the terminal block end of a power supply to cover the terminals,
 * strain relief the A/C cord, and mount a typical +/- banana jack set.
 */
//include <round_anything/minkowskiround.scad>
include <../$rrt_openscad_library/rrt_openscad_hull_shapes.scad>

bracketBodyWallThickness=5;

bracketBodyInnerWidth=114;
bracketBodyInnerHeight=50;
bracketBodyInnerDepth=40;  // enough to reach the side screws

sideScrewDepth=32;  // from end of power supply. doesn't count wire cavity depth
sideScrew1Height=11;
sideScrew2Height=36;
sideScrewHoleDia=4.5;  // allows a little room for threads to slide through.

terminalFaceInsetDepth=18;
terminalWireCavityDepth=20;  // room for the terminal ends to stick out, and wire to bend around inside

terminalBlockClosedHeight=24;


bananaJackPairHoleCenterToCenter=18.5;
bananaJackHoleDia=3.5;
bananaJackBasePlateWidth=35;
bananaJackBasePlateHeight=16;

overlap=0.01;
$fn=50;

// TODO:
// outer bracket
// mount screw holes
// banana jack mount plate
// a/c cord strain relief

difference() {
    union() {
        bracketBody();
    }
    // cutaways
    translate([bracketBodyWallThickness,bracketBodyWallThickness,bracketBodyWallThickness])
        mainCutout();
    // side of bracket box near y-axis    
    translate([0,bracketBodyWallThickness,bracketBodyWallThickness+terminalWireCavityDepth+sideScrewDepth])
        rotate([0,90,0])
            sideScrewHoles();    
    // side of bracket box in positive x-direction        
    translate([bracketBodyWallThickness+bracketBodyInnerWidth,bracketBodyWallThickness,bracketBodyWallThickness+terminalWireCavityDepth+sideScrewDepth])
        rotate([0,90,0])
            sideScrewHoles();    
}

module bracketBody() {
    outerWidth=bracketBodyInnerWidth+bracketBodyWallThickness*2;
    outerHeight=bracketBodyInnerHeight+bracketBodyWallThickness*2;
    outerDepth=bracketBodyInnerDepth+terminalWireCavityDepth+bracketBodyWallThickness;
    //boundingEnvelope=[outerWidth,outerHeight,outerDepth];
    //minkowskiRound(0.7,1.5,1,boundingEnvelope) {
        // cube([outerWidth,outerHeight,outerDepth]);
        hullCubeFromSphereCorners([outerWidth,outerHeight,outerDepth], 5, 20);
    //}
}

module mainCutout() {
    cube([bracketBodyInnerWidth,bracketBodyInnerHeight,bracketBodyInnerDepth+terminalWireCavityDepth+overlap]);
}

/*
 * constructed vertically centered on the y-axis, spaced in the y (height) direction
 */
module sideScrewHoles() {
    translate([0,sideScrew1Height,-overlap])
        cylinder(d=sideScrewHoleDia, h=bracketBodyWallThickness+overlap*2);
    translate([0,sideScrew2Height,-overlap])
        cylinder(d=sideScrewHoleDia, h=bracketBodyWallThickness+overlap*2);
}

/*
 * 12v Power Supply Banana Jack Bracket
 * Screws on the terminal block end of a power supply to cover the terminals,
 * strain relief the A/C cord, and mount a typical +/- banana jack set.
 */
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
bananaJackInternalDepth=25;

cornerRoundDia=5;

bracketOuterWidth=bracketBodyInnerWidth+bracketBodyWallThickness*2;
bracketOuterHeight=bracketBodyInnerHeight+bracketBodyWallThickness*2;
bracketOuterDepth=bracketBodyInnerDepth+terminalWireCavityDepth+bracketBodyWallThickness;

bananaJackHousingOuterWidth=bananaJackBasePlateWidth+bracketBodyWallThickness*2;
bananaJackHousingOuterHeight=bananaJackBasePlateHeight+bracketBodyWallThickness*2;
bananaJackHousingOuterDepth=bananaJackInternalDepth+bracketBodyWallThickness*2;

// strain relief product option - search: "spiral cable gland pg11 or pg9"
acCordPassthruDia=18;  // threaded part of strain-relief
acCordPassthruTolerance=0.75;
acCordXInset=22;
acCordYInset=18;

overlap=0.01;
$fn=50;

// TODO:
// a/c cord strain relief

difference() {
    union() {
        bracketBody();
        translate([bracketOuterWidth/2-bananaJackHousingOuterWidth/2,
                bracketOuterHeight-bracketBodyWallThickness+overlap,0])
            bananaJackHousing();
    }
    // cutaways
    translate([bracketBodyWallThickness,bracketBodyWallThickness,bracketBodyWallThickness])
        mainCutout();

    // Reminder: depth dimension of box is also on z-axis (holes go against x/y plane)
    translate([bracketOuterWidth/2-bananaJackHousingOuterWidth/2+bracketBodyWallThickness,
            bracketOuterHeight-bracketBodyWallThickness-overlap,
            bracketBodyWallThickness])
        bananaJackHousingCutout();
    // side of bracket box near y-axis    
    translate([0,bracketBodyWallThickness,bracketBodyWallThickness+terminalWireCavityDepth+sideScrewDepth])
        rotate([0,90,0])
            sideScrewHoles();    
    // side of bracket box in positive x-direction        
    translate([bracketBodyWallThickness+bracketBodyInnerWidth,bracketBodyWallThickness,bracketBodyWallThickness+terminalWireCavityDepth+sideScrewDepth])
        rotate([0,90,0])
            sideScrewHoles();    
    translate([bracketBodyWallThickness+acCordXInset,bracketBodyWallThickness+acCordYInset,-overlap])
        acCordPassThru();        
}

module bracketBody() {
    //boundingEnvelope=[outerWidth,outerHeight,outerDepth];
    //minkowskiRound(0.7,1.5,1,boundingEnvelope) {
        // cube([outerWidth,outerHeight,outerDepth]);
        hullCubeFromSphereCorners([bracketOuterWidth,bracketOuterHeight,bracketOuterDepth], cornerRoundDia);
    //}
}

module acCordPassThru() {
    cylinder(d=acCordPassthruDia+acCordPassthruTolerance*2, h=bracketBodyWallThickness+overlap*2);
    // strain relief mount screws
    // TODO: Decide whether to use strain relief insert from hydrophone project instead
}

module mainCutout() {
    cube([bracketBodyInnerWidth,bracketBodyInnerHeight,bracketBodyInnerDepth+terminalWireCavityDepth+overlap]);
}

module bananaJackHousing() {
    hull() {
        hullCubeFromSphereCorners([bananaJackHousingOuterWidth,
            bananaJackHousingOuterHeight-overlap*2,
            bananaJackHousingOuterDepth], cornerRoundDia);
        translate([bananaJackHousingOuterWidth/4,0,bracketOuterDepth])
            cube([bananaJackHousingOuterWidth/2,overlap,overlap]);
    }
} 

// Reminder, this is centered within the outer shell AFTER it is constructed.
// Positioning is relative to an object aligned with the origin
module bananaJackHousingCutout() {
    union() {
        hull() {
            cube([bananaJackBasePlateWidth,bananaJackBasePlateHeight+bracketBodyWallThickness+overlap,bananaJackInternalDepth]);
            translate([bananaJackBasePlateWidth/4+bracketBodyWallThickness,0,bracketBodyInnerDepth+bracketBodyWallThickness*2])
                cube([bananaJackBasePlateWidth/2-bracketBodyWallThickness*2,overlap,overlap]);
        }
        // banana jack thru holes (poke down in -z direction before translation)
        translate([bananaJackBasePlateWidth/2-bananaJackPairHoleCenterToCenter/2,
                bracketBodyWallThickness+bananaJackBasePlateHeight/2,-bracketBodyWallThickness-overlap])  // left hole
            cylinder(d=bananaJackHoleDia, h=bracketBodyWallThickness+overlap*2);
        translate([bananaJackBasePlateWidth/2+bananaJackPairHoleCenterToCenter/2,
                bracketBodyWallThickness+bananaJackBasePlateHeight/2,-bracketBodyWallThickness-overlap]) // right hole
            cylinder(d=bananaJackHoleDia, h=bracketBodyWallThickness+overlap*2);
    }
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

/*
 * Creates a cube using spheres at the corners.
 * cubeDimensions arg is an array of numbers in [x,y,z] order
 */ 
module hullCubeFromSphereCorners(cubeDimensions, cornerDia, fn=20) {
    reducedX=cubeDimensions[0]-cornerDia;
    reducedY=cubeDimensions[1]-cornerDia;
    reducedZ=cubeDimensions[2]-cornerDia;
    // Move everything fully into +x, +y, +z AFTER construction at the correct size
    translate([cornerDia/2,cornerDia/2,cornerDia/2]) {
        hull() {
            // Bottom of box

            // at origin
            sphere(d=cornerDia, $fn=fn);
            // +x
            translate([reducedX,0,0])
                sphere(d=cornerDia, $fn=fn);
            // +y
            translate([0,reducedY,0])
                sphere(d=cornerDia, $fn=fn);
            // +x +y
            translate([reducedX,reducedY,0])
                sphere(d=cornerDia, $fn=fn);

            // Top of box
            // at origin +z
            translate([0,0,reducedZ])
                sphere(d=cornerDia, $fn=fn);
            // +x +z
            translate([reducedX,0,reducedZ])
                sphere(d=cornerDia, $fn=fn);
            // +y +z
            translate([0,reducedY,reducedZ])
                sphere(d=cornerDia, $fn=fn);
            // +x +y +z
            translate([reducedX,reducedY,reducedZ])
                sphere(d=cornerDia, $fn=fn);

        }
    }
}
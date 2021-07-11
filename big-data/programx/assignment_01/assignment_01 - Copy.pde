/**
 * Author: Johannes Foulds
 * Project: Assignment 1
 */
 
// canvas setup
size(800, 330);
//size(1600, 660);
background(254, 147, 29);

float margins = height * 0.03;
  
/* TEXT */

// biohazard block
float blockTop = margins;
float blockLeft = margins;
float blockWidth = width * 0.57;
float blockHeight = height * 0.32;
float blockRadius = width * 0.02;

fill(0);
rect(blockLeft, blockTop, blockWidth, blockHeight, blockRadius);

// biohazard text
float textSize = height * 0.21;
float textTopAdjustment = textSize * -0.10;
float biohazardTextTop = blockTop + blockHeight / 2;
float biohazardTextLeft = blockLeft + blockWidth / 2;

fill(254, 147, 29);
textAlign(CENTER, CENTER);
textSize(textSize);
text("BIOHAZARD", biohazardTextLeft, biohazardTextTop + textTopAdjustment);

// authorized text
fill(0);
textAlign(CENTER, TOP);

float authorizedTextTop = blockTop + blockHeight;
text("AUTHORIZED", biohazardTextLeft, authorizedTextTop);

// personnel text
float personnelTextTop = authorizedTextTop + textSize;
text("PERSONNEL", biohazardTextLeft, personnelTextTop);

// only text
float onlyTextTop = personnelTextTop + textSize;
text("- ONLY -", biohazardTextLeft, onlyTextTop);

/* LOGO */

// determine logo center point
float logoTop = height / 2;
float logoLeft = width * 0.80; 

// small middle circle
float smallMiddleDiameter = width * 0.04;


// large black outer circle size
float largeOuterBlackDiameter = width * 0.22;

float largeOuterTopX = logoLeft;
float largeOuterTopY = logoTop - largeOuterBlackDiameter/2 + smallMiddleDiameter/2;

float largeOuterLeftX = largeOuterTopX * cos(60) - largeOuterTopY * sin(60);
float largeOuterLeftY = largeOuterTopX * sin(60) + largeOuterTopY * cos(60);

fill(40);
noStroke();
ellipse(largeOuterTopX, largeOuterTopY, largeOuterBlackDiameter, largeOuterBlackDiameter);
fill(80);
//ellipse(largeOuterLeftX, largeOuterLeftY, largeOuterBlackDiameter, largeOuterBlackDiameter);
fill(160);
//ellipse(largeOuterRight, largeOuterBottom, largeOuterBlackDiameter, largeOuterBlackDiameter);

/*
// outer inner circles
float outerInnerDiameter = width * 0.154;
float outerInnerrTop = (logoTop - outerInnerDiameter/2 - smallMiddleDiameter*0.8);
float outerInnerBottom = (logoTop + outerInnerDiameter/2);
float outerInnerLeft = (logoLeft - outerInnerDiameter/2 - smallMiddleDiameter*0.2);
float outerInnerRight = (logoLeft + outerInnerDiameter/2 + smallMiddleDiameter*0.2);

fill(0, 255, 0);
noStroke();
ellipse(logoLeft, outerInnerrTop, outerInnerDiameter, outerInnerDiameter);
ellipse(outerInnerLeft, outerInnerBottom, outerInnerDiameter, outerInnerDiameter);
ellipse(outerInnerRight, outerInnerBottom, outerInnerDiameter, outerInnerDiameter);
*/



// small middle circle
//translate(logoLeft, logoTop);
noStroke();
fill(254, 147, 29);
ellipse(logoLeft, logoTop, smallMiddleDiameter, smallMiddleDiameter);
/*
// middle black circle
float middleBlackDiameter = width * 0.17;

stroke(255,0,0);
noFill();
strokeWeight(width*0.025);
ellipse(logoLeft, logoTop, middleBlackDiameter, middleBlackDiameter);
*/

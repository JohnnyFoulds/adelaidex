/**
 * Author: Johannes Foulds
 * Project: Assignment 1
 */

// canvas setup
//size(800, 330);
//size(1600, 660);
size(400, 165);
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
translate(logoLeft, logoTop);

// small middle circle
float smallMiddleDiameter = width * 0.04;

// large black outer circle size
float largeOuterBlackDiameter = width * 0.22;

float largeOuterTopX = 0;
float largeOuterTopY = 0 - largeOuterBlackDiameter/2 + smallMiddleDiameter;
float largeOuterR = largeOuterBlackDiameter/2 - smallMiddleDiameter;

float largeOuterLeftX = largeOuterR * cos(radians(240-90));
float largeOuterLeftY = largeOuterR * sin(radians(240-90));

float largeOuterRightX = largeOuterR * cos(radians(120-90));
float largeOuterRightY = largeOuterR * sin(radians(120-90));


fill(0);
noStroke();
ellipse(largeOuterTopX, largeOuterTopY, largeOuterBlackDiameter, largeOuterBlackDiameter);
ellipse(largeOuterLeftX, largeOuterLeftY, largeOuterBlackDiameter, largeOuterBlackDiameter);
ellipse(largeOuterRightX, largeOuterRightY, largeOuterBlackDiameter, largeOuterBlackDiameter);

// outer inner circles
float outerInnerDiameter = width * 0.154;

float outerInnerrTopX = 0;
float outerInnerrTopY = largeOuterTopY - (largeOuterBlackDiameter-outerInnerDiameter)*0.55;
float outerInnerrR = largeOuterR + (largeOuterBlackDiameter-outerInnerDiameter)*0.55;

float outerInnerrLeftX = outerInnerrR * cos(radians(240-90));
float outerInnerrLeftY = outerInnerrR * sin(radians(240-90));

float outerInnerrRightX = outerInnerrR * cos(radians(120-90));
float outerInnerrRightY = outerInnerrR * sin(radians(120-90));

fill(254, 147, 29);
noStroke();
ellipse(outerInnerrTopX, outerInnerrTopY, outerInnerDiameter, outerInnerDiameter);
ellipse(outerInnerrLeftX, outerInnerrLeftY, outerInnerDiameter, outerInnerDiameter);
ellipse(outerInnerrRightX, outerInnerrRightY, outerInnerDiameter, outerInnerDiameter);

stroke(254, 147, 29);
strokeWeight(width*0.01);
line(0,0, outerInnerrTopX, outerInnerrTopY);
line(0,0, outerInnerrLeftX, outerInnerrLeftY);
line(0,0, outerInnerrRightX, outerInnerrRightY);

// small middle circle
noStroke();
fill(254, 147, 29);
ellipse(0, 0, smallMiddleDiameter, smallMiddleDiameter);

// middle black circle
float middleBlackDiameter = width * 0.17;

stroke(0);
noFill();
strokeWeight(width*0.025);
ellipse(0, 0, middleBlackDiameter, middleBlackDiameter);

// inner circle rings
noFill();
stroke(254, 147, 29);
strokeWeight(width*0.005);
ellipse(outerInnerrTopX, outerInnerrTopY, outerInnerDiameter, outerInnerDiameter);
ellipse(outerInnerrLeftX, outerInnerrLeftY, outerInnerDiameter, outerInnerDiameter);
ellipse(outerInnerrRightX, outerInnerrRightY, outerInnerDiameter, outerInnerDiameter);

/* SAVE */
save("assignment_01.png");

/**
 * Author: Johannes Foulds
 * Project: Assignment 04-03
 */
 
 final int CHARACTER_COUNT = 20;
 final int RANDOM_SEED = 0;
 final String SERVER_PROMPT = "root@bio_svr01:~# ";
 
 void setup() {
   size(640, 400);
   background(0);

   // draw the background logo
   drawBackground(#000000, color(15));
   
   // get the list of random characters
   randomSeed(RANDOM_SEED);
   ArrayList<Character> data = populate(CHARACTER_COUNT);
   print(data);
   
   // display the characters
   int y = 20;
   y = displayData(data.toString(), "populate -n " + CHARACTER_COUNT + " -s " + RANDOM_SEED, y);
   
   // reverse and combine
   y = displayData(reverse(data).toString(), "populate -n " + CHARACTER_COUNT + " -s " + RANDOM_SEED + " | reverse", y);
   y = displayData(combine(reverse(data)), "populate -n " + CHARACTER_COUNT + " -s " + RANDOM_SEED + " | reverse | combine", y);
   
   // randomise
   y = displayData(randomise(data).toString(), "populate -n " + CHARACTER_COUNT + " -s " + RANDOM_SEED + " | randomise", y);
   
   // final prompt
   y = displayData("", "_", y);
   
   // save the output
   save("assignment_07.png");
 }
 
 /*
  * Get an array if random characters.
  */
 ArrayList<Character> populate(int n) {
   ArrayList<Character> list = new ArrayList<Character>();
   
   for (int i = 0; i < n; i++) {
     list.add(char(round(random(97, 122))));
   }
   
   return list;
 }
 
/*
 * Return the character array in reverse order.
 */
ArrayList<Character> reverse(ArrayList<Character> data) {
   ArrayList<Character> list = new ArrayList<Character>();
   
   for (int i = data.size()-1; i >= 0; i--) {
     list.add(data.get(i));
   }
   
   return list;
}

/*
 * Combine an array of characters into a single string.
 */
String combine(ArrayList<Character> data) {
 String result = "";
 
   for (int i = 0; i < data.size(); i++) {
     result += data.get(i);
   }
 
   return result;
}

/*
 * Create a randomised list of the character array. 
 */
ArrayList<Character> randomise(ArrayList<Character> data) {
   ArrayList<Character> list = new ArrayList<Character>();
   
   int n = data.size();
   for (int i = 0; i < n; i++) {
     int selected = round(random(0, data.size()-1));
     list.add(data.get(selected));
     data.remove(selected);
   }
   
   return list;
}
 
/*
 * Display the data in a Unix command prompt
 */
int displayData(String output, String command, int y) {
   strokeWeight(1);
   stroke(0, 170, 0);
   fill(0, 170, 0);
   textSize(15);

  text(SERVER_PROMPT + command, 10, y);
  y += 17;
  text(output, 10, y);
  y += 17 * 2;
  
  return y;
}
 
 /*
  * Draw the background logo
  */
 void drawBackground(color background, color foreground) {
    pushMatrix();

    // determine logo center point
    float logoTop = height / 2;
    float logoLeft = width / 2; 
    translate(logoLeft, logoTop);
    
    int imgeWidth = floor(height * 2.5);
    
    // small middle circle
    float smallMiddleDiameter = imgeWidth * 0.04;
    
    // large black outer circle size
    float largeOuterBlackDiameter = imgeWidth * 0.22;
    
    float largeOuterTopX = 0;
    float largeOuterTopY = 0 - largeOuterBlackDiameter/2 + smallMiddleDiameter;
    float largeOuterR = largeOuterBlackDiameter/2 - smallMiddleDiameter;
    
    float largeOuterLeftX = largeOuterR * cos(radians(240-90));
    float largeOuterLeftY = largeOuterR * sin(radians(240-90));
    
    float largeOuterRightX = largeOuterR * cos(radians(120-90));
    float largeOuterRightY = largeOuterR * sin(radians(120-90));
    
    
    fill(foreground);
    noStroke();
    ellipse(largeOuterTopX, largeOuterTopY, largeOuterBlackDiameter, largeOuterBlackDiameter);
    ellipse(largeOuterLeftX, largeOuterLeftY, largeOuterBlackDiameter, largeOuterBlackDiameter);
    ellipse(largeOuterRightX, largeOuterRightY, largeOuterBlackDiameter, largeOuterBlackDiameter);
    
    // outer inner circles
    float outerInnerDiameter = imgeWidth * 0.154;
    
    float outerInnerrTopX = 0;
    float outerInnerrTopY = largeOuterTopY - (largeOuterBlackDiameter-outerInnerDiameter)*0.55;
    float outerInnerrR = largeOuterR + (largeOuterBlackDiameter-outerInnerDiameter)*0.55;
    
    float outerInnerrLeftX = outerInnerrR * cos(radians(240-90));
    float outerInnerrLeftY = outerInnerrR * sin(radians(240-90));
    
    float outerInnerrRightX = outerInnerrR * cos(radians(120-90));
    float outerInnerrRightY = outerInnerrR * sin(radians(120-90));
    
    fill(background);
    noStroke();
    ellipse(outerInnerrTopX, outerInnerrTopY, outerInnerDiameter, outerInnerDiameter);
    ellipse(outerInnerrLeftX, outerInnerrLeftY, outerInnerDiameter, outerInnerDiameter);
    ellipse(outerInnerrRightX, outerInnerrRightY, outerInnerDiameter, outerInnerDiameter);
    
    stroke(background);
    strokeWeight(imgeWidth*0.01);
    line(0,0, outerInnerrTopX, outerInnerrTopY);
    line(0,0, outerInnerrLeftX, outerInnerrLeftY);
    line(0,0, outerInnerrRightX, outerInnerrRightY);
    
    // small middle circle
    noStroke();
    fill(background);
    ellipse(0, 0, smallMiddleDiameter, smallMiddleDiameter);
    
    // middle black circle
    float middleBlackDiameter = imgeWidth * 0.17;
    
    stroke(foreground);
    noFill();
    strokeWeight(imgeWidth*0.025);
    ellipse(0, 0, middleBlackDiameter, middleBlackDiameter);
    
    // inner circle rings
    noFill();
    stroke(background);
    strokeWeight(imgeWidth*0.005);
    ellipse(outerInnerrTopX, outerInnerrTopY, outerInnerDiameter, outerInnerDiameter);
    ellipse(outerInnerrLeftX, outerInnerrLeftY, outerInnerDiameter, outerInnerDiameter);
    ellipse(outerInnerrRightX, outerInnerrRightY, outerInnerDiameter, outerInnerDiameter);
    
    popMatrix();
 }

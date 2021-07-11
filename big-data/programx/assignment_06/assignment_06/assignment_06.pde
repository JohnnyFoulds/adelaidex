/**
 * Author: Johannes Foulds
 * Project: Assignment 06
 */
 
  void setup() {
    // configure the main display settings 
    size(320, 300);
    background(0);
    strokeWeight(1);
    stroke(0, 170, 0);
    fill(0, 170, 0);

    // set the random seed to simplify debugging
    randomSeed(0);

    // get the data to work with
    final int OBSERVATION_COUNT = 20;
    int dataAge[] = new int[OBSERVATION_COUNT];     // age in years
    int dataHeight[] = new int[OBSERVATION_COUNT];  // height in cm
   
    for (int index = 0; index < OBSERVATION_COUNT; index++) {
      dataAge[index] = round(random(17, 100));
      dataHeight[index] = round(random(150, 190));
    }
    
    // draw the table //<>//
    drawTable();
    
    // display the unsorted values
    drawData(dataAge, 13, 62);
    drawData(dataHeight, 53, 62);
    
    // sort the values
    for (int i = 0; i < dataAge.length; i++) {
      int minIndex = i;
      for (int j = i + 1; j < dataAge.length; j++) {
        if (dataAge[j] < dataAge[minIndex]) {
          minIndex = j;
        }
      }
      
      // swap the values
      int swapAge = dataAge[i];
      int swapHeight = dataHeight[i];
      
      dataAge[i] = dataAge[minIndex];
      dataHeight[i] = dataHeight[minIndex];

      dataAge[minIndex] = swapAge;
      dataHeight[minIndex] = swapHeight;      
    }
    
    // display the sorted values
    drawData(dataAge, 170, 62);
    drawData(dataHeight, 210, 62);
    
   // save the output
   save("assignment_06.png");    
  }
  
/*
 * Render Data Values
 */
 void drawData(int[] data, int x, int y) {
   for (int index = 0; index < data.length; index++) {
     text(data[index], x, y);
     y += 12;
   }
 }
 
 /*
  * Draw an ascii art table
  */
 void drawTable() {  
   // draw the main headings
   textAlign(CENTER, BOTTOM);
   text("ORIGINAL", 80, 22);
   text("SORTED",  240, 22);
   
   textAlign(LEFT, BOTTOM);
   text("Age", 13, 42);  
   text("Weight", 53, 42);  

   text("Age", 170, 42);  
   text("Weight", 210, 42);  
   
   // draw the borders
   noFill();
   rect(5, 5, 310, 290);
   rect(5, 5, 310, 20);
   
   // middle seperator
   rect(7, 7, 152, 16);
   rect(161, 7, 152, 16);
   rect(159, 25, 2, 270);
  
 }

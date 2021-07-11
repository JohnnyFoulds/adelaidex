/**
 * Author: Johannes Foulds
 * Project: Assignment 2
 */
 
 /*
  * setup
  */
 void setup() {
   size(500, 500);
   
   // get data points
   randomSeed(1);
   int point_01 = ceil(random(1, 10));  int point_02 = ceil(random(1, 10));  int point_03 = ceil(random(1, 10));   int point_04 = ceil(random(1, 10));  int point_05 = ceil(random(1, 10));  
   int point_06 = ceil(random(1, 10));  int point_07 = ceil(random(1, 10));  int point_08 = ceil(random(1, 10));   int point_09 = ceil(random(1, 10));  int point_10 = ceil(random(1, 10));
   
   // create an array for ease of use
   int[] data = { point_01, point_02, point_03, point_04, point_05, point_06, point_07, point_08, point_09, point_10 }; 
  
   // calculate the mean
   float mean = calculateMean(data);
  
   println(data);
   println(mean);

   // draw the chart
   drawChart(data, mean);   
 }
 
 /*
  * draw
  */
 void draw() {  
 }
 
 /*
  * Draw Chart
  */
 void drawChart(int[] data, float mean) {
   float margin = width * 0.05;
   float overhang = margin;
   float borderWeight = width * 0.005;
   drawAxis(margin, overhang, borderWeight);
   
   // calculate chat working area
   float chartHeight = height - 2*margin - 2*overhang;
   float chartWidth = width - 2*margin - 2*overhang;
   
   // draw the grid
   pushMatrix();
     translate(margin + overhang, margin + overhang);
     drawGrid(chartWidth, chartHeight);
   popMatrix();
   
   // draw the axis
   drawAxis(margin, overhang, borderWeight);
   
   // set the chart area
   pushMatrix();
   translate(margin + overhang, margin + overhang);
   
   // plot the data values
   drawBars(data, borderWeight, chartWidth, chartHeight);
   
   // plot the mean line
   drawMean(mean, borderWeight, chartWidth, chartHeight);
 }
 
 /*
  * Draw the x and y axis.
  */
 void drawAxis(float margin, float overhang, float borderWeight) {
   stroke(0);
   strokeWeight(borderWeight);
   
   // y-axis
   float x1 = margin + overhang;
   float x2 = -1;
   float y1 = margin;
   float y2 = height - margin;
   line(x1, y1, x1, y2);
   
   // x-axis
   x1 = margin;
   x2 = width - margin;
   y1 = height - margin - overhang;
   line(x1, y1, x2, y1);
 }
 
 /*
  * Draw the background grid.
  */
 void drawGrid(float chartWidth, float chartHeight) {
   noFill();
   strokeWeight(1);
   stroke(150);
   
   float blockWidth = chartWidth / 10;
   float blockHeight = chartHeight / 10;
   
   for (int row = 0; row < 10; row++) {
     for (int column = 0; column < 10; column++) {
       rect(column*blockWidth, row*blockHeight, blockWidth, blockHeight); 
     }
   }
 }
 
/*
 * Plot the mean line
 */
void drawMean(float mean, float borderWeight, float chartWidth, float chartHeight) {
   noFill();
   strokeWeight(borderWeight);
   stroke(255, 0, 0);
   
   float x = mean/10 * chartWidth; 
   line(x, 0, x, chartHeight);
}

/*
 * Plot the bars for the data points
 */
void drawBars(int[] data, float borderWeight, float chartWidth, float chartHeight) {
   strokeWeight(borderWeight);
   stroke(0);

   float blockHeight = chartHeight / 10;
   
   for (int index = 0; index < 10; index++) {
     fill(0, 0, 50+(index)*20);
     float blockWidth = data[index]/10.0 * chartWidth;
     float y = index * blockHeight;
     rect(0, y, blockWidth, blockHeight); 
   }
}

/*
 * Calculate the mean for the data points.
 */
float calculateMean(int[] data) {
  float total = 0;
  
  for (int i = 0; i < data.length; i++) {
    total += data[i];
  }
  
  return total / data.length;
}

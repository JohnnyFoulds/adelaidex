/**
 * Author: Johannes Foulds
 * Project: Worked Problem  01
 */
 
 void setup() {
   //size(1200, 900);
   //size(1000, 1000);
   noLoop();
   size(900, 350);
   background(255);
   // draw the background logo
   drawBackground(255, color(240));
   
   // load data
   JSONArray data = loadData();
   
   // asign sector colors
   assignColors(data);
   
   // get the budget total
   int total = sumArray(data);
   
   // calculate the ratios
   calculateRatio(data, total);
   
   // draw the pie chart
   float chart_size = (width - 510) - 80; 
   float chart_x = (width - 510) / 2 + 510;
   float chart_y = height / 2;
   
   drawPieChart(data, chart_x, chart_y, chart_size);

   // draw the cart legend
   pushMatrix();
   translate(10, (height - 350) / 2);
   drawLegend(data, total);
   popMatrix();   

   // print the data for debugging
   print(data);
   
   // save the output
   save("problem_01.png");   
 }
 
 /*
  * Load the goverment sector data
  */
JSONArray loadData() {
  // static arrays containing the data
  String[] sectorName = {
    "General public services", "Public order and safety", "Education", "Health", "Social security and welfare", 
    "Housing and community amenities", "Recreation and culture", "Fuel and energy", "Agriculture, forestry, fishing and hunting", 
    "Mining and mineral resources", "Transport and communications", "Other economic affairs", "Other purposes"
  };
    
  int[] sectorBudget = {408, 1752, 4364, 5618, 1437, 1275, 421, 74, 213, 73, 1219, 390, 766};
  
  // build the json array
  JSONArray data = new JSONArray();
  
  for (int i = 0; i < sectorName.length; i++) {
    JSONObject sector = new JSONObject();
    
    sector.setInt("id", i);
    sector.setString("sector", sectorName[i]);
    sector.setInt("budget", sectorBudget[i]);
    
    data.setJSONObject(i, sector);
  }

  return data;  
}

/*
 * Get the total budget from the data points.
 */
int sumArray(JSONArray data) {
  int total = 0;

  for (int i = 0; i < data.size(); i++) {
    JSONObject dataPoint = data.getJSONObject(i);
    
    total += dataPoint.getInt("budget");
  }
  
  return total;
}

/*
 * Calculate the budget ratios based on the total
 */
void calculateRatio(JSONArray data, int total) {
  for (int i = 0; i < data.size(); i++) {
    JSONObject dataPoint = data.getJSONObject(i);
    int budget = dataPoint.getInt("budget");
    
    dataPoint.setFloat("ratio", float(budget) / total);
  }
}

/*
 * Assign visualization colors to the data points
 */
void assignColors(JSONArray data) {
  color[] colors = {
    #FF0000, #E01E84, #C758D0, #9C46D0, #8E6CEF, #8399EB, #007ED6, #97D9FF, #5FB7D4,
    #7CDDDD, #26D7AE, #2DCB75, #1BAA2F, #52D726, #D5F30B, #FFEC00, #FFAF00, #FF7300
  };
  
  for (int i = 0; i < data.size(); i++) {
    data.getJSONObject(i).setInt("color", colors[i]);
  }
}

void drawPieChart(JSONArray data, float chart_x, float chart_y, float chart_size) {
  float lastAngle = 0;
  stroke(255);
  strokeWeight(1);
  
  for (int i = 0; i < data.size(); i++) {
    JSONObject dataPoint = data.getJSONObject(i);
    float dataRatio = dataPoint.getFloat("ratio");
    
    fill(dataPoint.getInt("color"));
    arc(chart_x, chart_y, chart_size, chart_size, lastAngle, lastAngle+radians(360 * dataRatio), PIE);
    lastAngle += radians(360 * dataRatio);
  }
}

/*
 * Draw the data and chart legend
 */
void drawLegend(JSONArray data, int total) {
  textSize(11);
  fill(0);
  
  int x = 20;
  int y = 30;
  
  // heading
  text("General Government Sector", x, y);
  text("Budget ($million)", x + 250, y);
  text("Percentage", x + 360, y);
  y += 30;
  
  // display data points
  for (int i = 0; i < data.size(); i++) {
    JSONObject dataPoint = data.getJSONObject(i);
    
    // sector
    fill(0);
    textAlign(LEFT, BOTTOM);
    text(dataPoint.getString("sector"), x, y);
    
    // budget
    textAlign(RIGHT, BOTTOM);
    text(nfc(dataPoint.getInt("budget"),0), x + 340, y);
    
    // percentage
    float percentage = round(dataPoint.getFloat("ratio") * 1000) / 10.0;
    text(percentage + "%", x + 418, y);
    
    // color
    fill(dataPoint.getInt("color"));
    stroke(0);
    strokeWeight(1);
    rect(x + 450, y - 15, 15, 15);
    
    y += 20;
  }
  
  // display the total
  y += 5;
  fill(0);
  textAlign(LEFT, BOTTOM);
  text("Total", x, y);
  textAlign(RIGHT, BOTTOM);
  text(nfc(total,0), x + 340, y);
  y += 20;
  
  // draw the borders
  noFill();
  rect (10, 10, 500, 295);
  rect (10, 10, 500, 30);
  rect (10, 305, 500, 25);
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
    
    int imgeWidth = floor(height * 2.8);
    
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

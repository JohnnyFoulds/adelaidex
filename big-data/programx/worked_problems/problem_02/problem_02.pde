/**
 * Author: Johannes Foulds
 * Project: Worked Problem  02
 */
 
final int RANDOM_SEED = 0;
final String SERVER_PROMPT = "root@bio_svr03:~# ";
final String SERVER_COMMAND = "describe -z 0 -f Daily_Rainfall_Adelaide_2016_Kent_Town_Station.csv";
final color CRT_COLOR = #FFBB2E;
final color LOGO_COLOR = #1A1100;

// the raw input data
final String RAW_DATA = "0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.2, 0, 0, 0, 0, 0, 0, 0, 0.4, 0.2, 8, 7.6, 0, 0, 0, 0, 0, 17.8, 18.6, 0, 0, 13.2, 4.8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.2, 21.6, 0, 0, 20, 2.4, 0, 0, 0, 0, 0, 0, 8, 0.4, 0, 0, 0, 0, 0, 1.2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4.6, 0.2, 0, 0, 0, 0.4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0, 0, 0, 0, 0, 0, 4, 0, 1.6, 0, 0.8, 5.2, 0, 0, 0, 0.4, 0.8, 16, 0.6, 4.6, 0.4, 0, 0, 0.6, 0.2, 0, 0, 0.2, 0, 0, 7.2, 0.4, 3.4, 24.2, 2.8, 17, 0, 1.2, 0.4, 0.2, 0.2, 18.4, 0, 0.2, 11.4, 1.6, 3.8, 5.2, 2.4, 1.8, 0, 0, 0, 0, 2.4, 4, 0, 0, 0.6, 3.8, 11.8, 2.6, 20, 0.6, 0, 2.6, 0, 0, 1.6, 2.6, 1.4, 0, 0.2, 37.6, 2.4, 1.6, 0, 0, 6.6, 1.4, 6, 7, 0.6, 0.2, 0, 0, 0, 0, 5, 0, 0.6, 4.2, 0, 11.4, 8.8, 10.4, 0.2, 0, 0, 3.8, 11, 1.8, 0, 0.4, 0, 0, 0, 0, 0.6, 3.6, 8.2, 0, 0, 0, 0, 0, 0.8, 0, 16.8, 7, 0.2, 0, 0, 0, 0, 0, 0, 0, 1.6, 5.8, 1, 0.2, 0.2, 0.4, 1, 0, 0, 0, 1.2, 30.4, 0.2, 0, 0, 6.2, 15.6, 16.6, 0, 0, 2.4, 0.4, 0.4, 1.6, 0, 0, 2.4, 2, 0, 0, 0, 37.8, 12.2, 4.2, 0, 27.6, 11.8, 0, 0, 0, 0, 0, 2, 0.4, 0.8, 0.6, 0, 0, 1.2, 14.2, 4.2, 3.8, 0, 9.4, 0.2, 0, 0, 0, 0, 0, 0, 0, 0, 0.6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14, 16.4, 1.8, 0, 0, 0, 0, 0, 0, 0, 0.8, 0.2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4.6, 0, 0, 8, 0.8, 0, 0, 0, 0, 0.4, 0, 0, 0.4, 0, 0, 2.2, 0, 0, 0, 0, 0, 0.2, 5.8, 61.2, 3, 0.2, 0";

// the data structure to hold the output data
JSONObject outputData = new JSONObject();

void setup() {
  //size(640, 400);
  size(800, 600);
  noLoop();
  
  // load the data
  float raw_data[] = loadData(RAW_DATA);
  
  // sanatise the data
  JSONArray sanatisedData = sanatiseData(raw_data);
  outputData.setJSONArray("data", sanatisedData);
  outputData.setInt("rawCount", raw_data.length);
  
  // set the output data values
  outputData.setFloat("mean", mean(sanatisedData));
  outputData.setJSONArray("median", median(sanatisedData));
  outputData.setJSONArray("mode", mode(sanatisedData));
  outputData.setFloat("standard_deviation", standardDeviation(sanatisedData));
  
  //println(outputData);
}

/*
 * Load the raw data and return a float array
 */
float[] loadData(String input) {
  String[] rawPoints = input.split(", ");
  float[] dataPoints = new float[rawPoints.length];
  
  for (int i = 0; i < rawPoints.length; i++) {
    dataPoints[i] = float(rawPoints[i]);
  }
  
  return dataPoints;
}

/*
 * Remove zero values from the data
 */
JSONArray sanatiseData(float[] data) {
  JSONArray sanatisedData = new JSONArray();
  
  for (int i = 0; i < data.length; i++) {
    if (data[i] > 0) {
      sanatisedData.append(data[i]);
    }
  }
  
  return sanatisedData;
}

/*
 * Calculate the mean for the data points.
 */
float mean(JSONArray data) {
  float total = 0;
  
  // calculate the sum of the data points
  for (int i = 0; i < data.size(); i++) {
    total += data.getFloat(i);
  }
  
  return total / data.size();
}

/*
 * Determine the data point median
 */
JSONArray median(JSONArray data) {
  JSONArray values = new JSONArray();

  // sort the data points  
  float[] dataArray = data.getFloatArray();
    
  dataArray = sort(dataArray);
  int middle = dataArray.length / 2;
  
  if (dataArray.length % 2 == 0) {
    values.setFloat(0, dataArray[middle - 1]);
    values.setFloat(1, dataArray[middle]);
  }
  else {
    values.setFloat(0, dataArray[middle]);
  }  
  
  return values;
}

/*
 * Calculate the standard deviation form the input data
 */
float standardDeviation(JSONArray data) {
  float[] dataArray = data.getFloatArray();

  float sum = 0;
  float mean = mean(data);

  for (int j = 0; j < dataArray.length; j++) {
    sum = sum + ((dataArray[j] - mean) * (dataArray[j] - mean)); 
  }
  
  float squaredDiffMean = (sum) / (dataArray.length); 
  float standardDev = (sqrt(squaredDiffMean)); 

  return standardDev;
}

/*
 * Determine the mode from the set of data points.
 */
JSONArray mode(JSONArray data) {
  JSONArray modes = new JSONArray();
  float[] dataArray = data.getFloatArray();
  //float[] dataArray = {1, 3, 2, 5, 2, 3};
  //float[] dataArray = {1, 2, 4, 2, 5};
  dataArray = sort(dataArray);
  
  float maxValue = -1;
  float maxCount = -1;

  for (int i = 0; i < dataArray.length; i++) {
    int count = 0;
    for (int j = 0; j < dataArray.length; j++) {
      if (dataArray[j] == dataArray[i]) count++; //<>//
    }
    if (count > maxCount) {
      maxCount = count;
      maxValue = dataArray[i];
      
      // remove previous modes from the list
      modes = new JSONArray();
      
      // add the new mode
      modes.append(maxValue);
    }
    else if (count == maxCount) {
      if (dataArray[i] > maxValue) {
        maxCount = count;
        maxValue = dataArray[i];
        modes.append(maxValue);
      }
    }
  }
  
  return modes;
}

void draw() {
  float y = 20;  
  float textSize = width * 0.02;
  float newLineSize = width * 0.027;

  // draw the background logo
  background(0); 
  drawBackground(#000000, color(LOGO_COLOR));
  
  strokeWeight(1);
  stroke(CRT_COLOR);
  fill(CRT_COLOR);
  textSize(textSize);
  
  // show the command
  text(SERVER_PROMPT + SERVER_COMMAND, 10, y);
  y += newLineSize;
  
  // show the output values
  text("Mean: " + nfc(outputData.getFloat("mean"), 2), 10, y);
  y += newLineSize;
  
  text("Median: " + getDisplayString(outputData.getJSONArray("median")), 10, y);
  y += newLineSize;
  text("Mode: " + getDisplayString(outputData.getJSONArray("mode")), 10, y); //<>//
  y += newLineSize;
  text("Standard Deviation: " + nfc(outputData.getFloat("standard_deviation"), 2), 10, y);
  y += newLineSize;
  y += newLineSize;
  text("(" + outputData.getJSONArray("data").size() + " of " + outputData.getInt("rawCount") + " records used)", 10, y);
  y += newLineSize;

  // show the ready prompt
  y += newLineSize;
  text(SERVER_PROMPT + "_", 10, y);
  
   // save the output
   save("problem_02.png"); 
}

/*
 * Get a display string of a JSONArray containing float values
 */
String getDisplayString(JSONArray values) {
  ArrayList<String> stringList = new ArrayList<String>();
  
  for (int i = 0; i < values.size(); i++) {
    stringList.add(nfc(values.getFloat(i), 2));
  }
  
  return stringList.toString();
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

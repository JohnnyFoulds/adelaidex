/** //<>// //<>//
 * Author: Johannes Foulds
 * Project: Worked Problem  03
 */

/*
 * Define constants
 */
final boolean DEBUG = false;
final color BACKGROUND_COLOR = 255;
final color STROKE_COLOR = 0;
final int AXIS_STROKE_WEIGHT = 1;
final float AXIS_INTEVALS = 10; 
final int TEXT_SIZE=11;

final int COLUMN_SIZE = 30;
final int SUMMARY_COLUMN_SIZE = 50;
final int NEWLINE_SIZE = 20;
final int OVERALL_ROW_HEIGHT = 25;
final int LEGEND_BOX_SIZE = 15;

final color[] CHART_COLORS_ORIG = {
  #FF0000, #E01E84, #C758D0, #9C46D0, #8E6CEF, #8399EB, #007ED6, #97D9FF, #5FB7D4, 
  #7CDDDD, #26D7AE, #2DCB75, #1BAA2F, #52D726, #D5F30B, #FFEC00, #FFAF00, #FF7300
};

final color[] CHART_COLORS = {
  #8E6CEF, #8399EB, #007ED6, #97D9FF, #5FB7D4, #7CDDDD, #26D7AE, #2DCB75, #1BAA2F, 
  #52D726, #D5F30B, #FFEC00, #FFAF00, #FF7300, #FF0000, #E01E84, #C758D0, #9C46D0, 
};

final float[][] RAW_DATA = {
  { 7.2, 7.5, 7.6, 7.5, 7.5, 7.4, 7.1, 7.0, 7.0, 6.9, 6.9, 7.1, 7.2, 7.3, 7.1, 7.1, 7.0, 7.2, 7.3, 7.3 }, 
  { 7.4, 7.4, 7.5, 7.3, 7.6, 7.5, 7.5, 7.4, 7.3, 7.3, 7.2, 7.4, 7.5, 7.5, 7.5, 7.4, 7.2, 7.3, 7.5, 7.6 }, 
  { 7.4, 7.5, 7.5, 7.6, 7.6, 7.5, 7.4, 7.5, 7.8, 7.5, 7.5, 7.6, 7.8, 7.8, 7.4, 7.8, 7.9, 7.4, 7.5, 7.5 }
};

/*
 * Process the data and render the output
 */
void setup() {
  //size(1000, 600);
  size(910, 600);
  noLoop();

  // data load
  float[][] data = loadData();

  // summarize the data
  float[][] dataSummary = summarize(data);

  // get the overall summary
  float[][] overallSummmary = overAllSummarize(data);

  // render the visualizations
  drawOutput(data, dataSummary, overallSummmary);
  
   // save the output
   save("problem_03.png");    
}

/*
 * Load the data for processing
 */
float[][] loadData() {
  float[][] rawData = RAW_DATA;

  // load test data for debugging
  if (DEBUG) {
    float[][] testData = {
      { 7.2, 7.5, 7.6, 7.5, 7.5, 7.4, 7.1, 7.0, 7.0, 6.9, 6.9, 7.1, 7.2, 7.3, 7.1, 7.1, 7.0, 7.2, 7.3, 7.3, 7.2, 7.5, 15.0 }, 
      { 7.4, 7.4, 7.5, 7.3, 7.6, 7.5, 7.5, 7.4, 3.3, 7.3, 7.2, 7.4, 7.5, 7.5, 7.5, 7.4, 7.2, 7.3, 7.5, 7.6, 7.2, 7.5, 7.6  }, 
      { 7.4, 7.5, 7.5, 7.6, 7.6, 7.5, 7.4, 7.5, 7.8, 7.5, 7.5, 7.6, 7.8, 7.8, 7.4, 7.8, 7.9, 7.4, 7.5, 7.5, 7.2, 7.5, 7.6  }, 
      { 7.4, 7.5, 7.5, 7.6, 7.6, 7.5, 7.4, 7.5, 7.8, 7.5, 7.5, 7.6, 7.8, 7.8, 7.4, 7.8, 7.9, 7.4, 7.5, 7.5, 7.2, 7.5, 7.6  }    
    };
    rawData = testData;
  }

  // for this project the data is in 5s intervals
  float[] timeSeries = new float[rawData[0].length];
  for (int i = 0; i < timeSeries.length; i++) {
    timeSeries[i] = i * 5;
  }

  // create the output dataset
  float[][] data = new float[rawData.length + 1][timeSeries.length];
  data[0] = timeSeries;

  for (int i = 0; i < rawData.length; i++) {
    data[i+1] = rawData[i];
  }

  return data;
}

/*
 * Determen the mean, max, and min from the data points.
 */
float[][] summarize(float[][] data) {
  float[][] summary = new float[data.length][3];

  for (int i = 1; i < data.length; i++) {
    summary[i][0] = getMin(data[i]);
    summary[i][1] = getMax(data[i]);
    summary[i][2] = getMean(data[i]);
  }

  return summary;
}

/*
 * Get the overall summary of the data
 */
float[][] overAllSummarize(float[][] data) {
  float[] allDataPoints = data[1];
  for (int i = 2; i < data.length; i++) {
    allDataPoints = concat(allDataPoints, data[i]);
  }

  float[][] allData = new float[2][allDataPoints.length];
  allData[1] = allDataPoints;

  return summarize(allData);
}

/*
 * Calculate the mean for the data points.
 */
float getMean(float data[]) {
  float total = 0;

  // calculate the sum of the data points
  for (int i = 0; i < data.length; i++) {
    total += data[i];
  }

  return total / data.length;
}

/*
 * Determine the max value from a set of data points.
 */
float getMax(float data[]) {
  float max = data[0];

  for (int i = 0; i < data.length; i++) {
    if (data[i] > max) {
      max = data[i];
    }
  }

  return max;
}

/*
 * Determine the max value from a set of data points.
 */
float getMin(float data[]) {
  float min = data[0];

  for (int i = 0; i < data.length; i++) {
    if (data[i] < min) {
      min = data[i];
    }
  }

  return min;
}

/*
 * Render the data and visualization.
 */
void drawOutput(float[][] data, float[][] dataSummary, float[][] overallSummmary) {
  background(BACKGROUND_COLOR);

  // draw the background logo
  drawBackground(255, color(240));

  stroke(STROKE_COLOR);
  strokeWeight(1);

  // draw the data table
  pushMatrix();
  float outerWidth = 120 + COLUMN_SIZE * data[0].length;
  float outerHeight = 10 + NEWLINE_SIZE * data.length + 10;
  float summaryWidth = SUMMARY_COLUMN_SIZE * 3;
  float tableWidth = outerWidth + summaryWidth + 20;
  float tableHeight = outerHeight + 20 + OVERALL_ROW_HEIGHT;

  float tableX = (width - tableWidth) / 2;
  float tableY = (height - tableHeight);
  translate(tableX, tableY);
  drawDataTable(data, dataSummary, overallSummmary);
  popMatrix();

  // render the chart title
  //fill(CHART_COLORS[6]);
  fill(STROKE_COLOR);
  textAlign(CENTER, TOP);
  textSize(32);
  float titleHeight = 45;
  text("pH Experiment", width / 2, 10);

  // render the chart
  float chartWidth = width - 40;
  float chartHeight = height - tableHeight - 20 - titleHeight;

  pushMatrix();
  translate(20, 10  + titleHeight);
  drawChart(data, dataSummary, overallSummmary, chartWidth, chartHeight);
  popMatrix();
}

/*
 * Render a table with the input data.
 */
void drawDataTable(float[][] data, float[][] dataSummary, float[][] overallSummmary) {
  textSize(TEXT_SIZE);
  fill(0);

  int x = 20;
  int y = 30;
  float dataOutputOffset = 120;

  // render the borders
  noFill();
  float outerWidth = dataOutputOffset + COLUMN_SIZE * data[0].length;
  float outerHeight = 10 + NEWLINE_SIZE * data.length + 10;

  rect(10, 10, outerWidth, outerHeight);
  rect(10, 10, outerWidth, 27);

  float summaryWidth = SUMMARY_COLUMN_SIZE * 3;
  rect(outerWidth + 10, 10, summaryWidth, outerHeight);
  rect(outerWidth +10, 10, summaryWidth, 27);

  rect(10, 10 + outerHeight, outerWidth, OVERALL_ROW_HEIGHT);
  rect(outerWidth +10, 10 + outerHeight, summaryWidth, OVERALL_ROW_HEIGHT);

  // render the time intervals
  ArrayList dataPoints = dataToString(data[0], 0);
  float current_x = drawDataPoints(x + dataOutputOffset, y, dataPoints, COLUMN_SIZE);

  // render the summary headings
  ArrayList headings = new ArrayList<String>();
  headings.add("Min");
  headings.add("Max");
  headings.add("Mean");
  drawDataPoints(current_x + 15, y, headings, SUMMARY_COLUMN_SIZE);

  y += NEWLINE_SIZE + 10;

  // render the experiments
  for (int i = 1; i < data.length; i++) {
    // render the experiment number
    textAlign(LEFT, BOTTOM);
    fill(STROKE_COLOR);
    text("Experiment " + i, x + LEGEND_BOX_SIZE + 10, y);

    // render the data points
    dataPoints = dataToString(data[i], 1);
    current_x = drawDataPoints(x + dataOutputOffset, y, dataPoints, COLUMN_SIZE);

    // render the summary
    ArrayList summary = dataToString(dataSummary[i], 1);
    drawDataPoints(current_x + 15, y, summary, SUMMARY_COLUMN_SIZE);

    // draw the legend color
    fill(CHART_COLORS[i-1]);
    stroke(STROKE_COLOR);
    strokeWeight(1);
    rect(x, y - LEGEND_BOX_SIZE, LEGEND_BOX_SIZE, LEGEND_BOX_SIZE);

    // go the the next line
    y += NEWLINE_SIZE;
  }

  // render the overall summary
  y += 10;
  textAlign(LEFT, BOTTOM);
  fill(STROKE_COLOR);
  text("Overall", current_x - 60, y);

  ArrayList summary = dataToString(overallSummmary[1], 1);
  drawDataPoints(current_x + 15, y, summary, SUMMARY_COLUMN_SIZE);
}

/*
 * Draw the clustered bar chart.
 */
void drawChart(float[][] data, float[][] dataSummary, float[][] overallSummmary, float chartWidth, float chartHeight) {
  noFill();
  strokeWeight(AXIS_STROKE_WEIGHT);
  stroke(STROKE_COLOR);

  // draw the axis
  float leftOffset = 30;
  float axisHeight = chartHeight - 20;
  line(leftOffset, 0, leftOffset, axisHeight);
  line(leftOffset, axisHeight, chartWidth, axisHeight);

  // set the text style of the axis labels
  fill(STROKE_COLOR);
  textAlign(CENTER, BOTTOM);
  textSize(TEXT_SIZE);

  // draw the horizontal labels
  float clusterMargin = 10;
  float clusterSize = (chartWidth-leftOffset - clusterMargin) / data[0].length;
  for (int i = 0; i < data[0].length; i++) {
    text(nfc(data[0][i], 0), i * clusterSize + leftOffset + + clusterMargin/2 + clusterSize/2, chartHeight-3);
  }

  //draw the vertical labels
  float bottomValue = (overallSummmary[1][0]);
  float topValue = (overallSummmary[1][1]);

  // caluclate the increments and set the new bottom value
  float increment = round( ((topValue - bottomValue) / (AXIS_INTEVALS - 2)) * 10.0 ) / 10.0;
  topValue = topValue + increment;
  bottomValue = bottomValue - increment;

  float actualIntervals = (topValue - bottomValue) / increment;
  println(increment);

  textAlign(RIGHT, BOTTOM);
  for (int i = 0; i <= actualIntervals; i++) {
    text(nfc(bottomValue + (i * increment), 1), leftOffset-5, (chartHeight-10) - (i * axisHeight/actualIntervals));
  }

  // calculate the bar dimensions
  float clusterWidth = clusterSize - 10;
  float barWidth = clusterWidth / (data.length-1);

  // render the bars
  float currentOffset = clusterMargin + leftOffset;
  for (int timeIndex = 0; timeIndex < data[0].length; timeIndex++) {
    for (int experimentIndex = 1; experimentIndex < data.length; experimentIndex++) {
      // calculate bar height
      float dataPoint = data[experimentIndex][timeIndex];
      float dataPointHeight = axisHeight * (dataPoint - bottomValue) / (topValue - bottomValue);
      
      fill(CHART_COLORS[experimentIndex]);
      rect(currentOffset, axisHeight - dataPointHeight, barWidth, dataPointHeight);

      currentOffset += barWidth;
    }
    currentOffset += clusterMargin;
  }
}

/*
 * Format an array of data points as strings.
 */
ArrayList<String> dataToString(float[] data, int decimals) {
  ArrayList<String> dataStrings = new ArrayList<String>();

  for (int i = 0; i < data.length; i++) {
    dataStrings.add(nfc(data[i], decimals));
  }

  return dataStrings;
}

/*
 * Render a row of data points.
 */
float drawDataPoints(float x, float y, ArrayList<String> data, float columnSize) {
  textAlign(CENTER, BOTTOM);
  fill(STROKE_COLOR);

  for (int i = 0; i < data.size(); i++) {
    text(data.get(i), x, y);
    x += columnSize;
  }

  return x;
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
  rotate(10);

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
  line(0, 0, outerInnerrTopX, outerInnerrTopY);
  line(0, 0, outerInnerrLeftX, outerInnerrLeftY);
  line(0, 0, outerInnerrRightX, outerInnerrRightY);

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

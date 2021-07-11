/** //<>// //<>// //<>//
 * Author: Johannes Foulds
 * Project: Major Assignment
 */

/*
 * Define constants
 */
final boolean DEBUG = true;
final color BACKGROUND_COLOR = 255;
final color STROKE_COLOR = 0;

final int AXIS_STROKE_WEIGHT = 1;
final float AXIS_INTEVALS = 10; 
final int TEXT_SIZE=11;

final int NEWLINE_SIZE = 20;
final int LEGEND_BOX_SIZE = 15;

final float LEGEND_OFFSET = 40;
final float TABLE_MARGIN = 15;
final float CHART_MARGIN = 30;
final float RESOURCE_SUMMARY_FIRST_COLUMN_WIDTH = 100;
final float RESOURCE_SUMMARY_COLUMN_WIDTH = 50;

final int AGE_BIN_SIZE = 20;

final color[] CHART_COLORS = {
  #26D7AE, 
  #2DCB75, #1BAA2F, #52D726, #D5F30B, #FFEC00, #FFAF00, #FF7300, 
  #FF0000, #E01E84, #C758D0, #9C46D0, #8E6CEF, #8399EB, #007ED6, #97D9FF, #5FB7D4, #7CDDDD, 
};

final color[] ALT_CHART_COLORS = {
  #67B7DC, #6794DC, #6771DC, #8067DC, #A367DC, #C767DC, #DC67CE, #DC67CE, #DC6788, 
  #FF0000, #E01E84, #C758D0, #9C46D0, #8E6CEF, #8399EB, #007ED6, #97D9FF, #5FB7D4, 
  #7CDDDD, #26D7AE, #2DCB75, #1BAA2F, #52D726, #D5F30B, #FFEC00, #FFAF00, #FF7300
};

final String DATA_PATH="https://pastebin.pl/view/raw/34f079e0";
final String[] RESOURCE_COLUMNS =      { "clothing", "documents", "firstaid", "food", "medication", "sanitation", "tools", "water" };
final String[] RESOURCE_EMPTY_VALUES = { "NA", "NA", "No first aid supplies", "No food", "No medication", "No sanitation", "No tools", "0" };

/*
 * Process the data and render the output
 */
void setup() {
  //size(1000, 600);
  size(800, 510);
  noLoop();

  // load the data for processing
  String dataPath = DEBUG ? "zombies.csv" : DATA_PATH;
  Table data = loadData(dataPath);

  // clean data
  cleanData(data);

  // get the resource summary, seperated between zombies and humans
  Table resourceSummary = getResourceSummary(data);

  // get the age bins
  Table ageBins = getAgeBins(data);

  // get the descriptive statistics for the age column
  Table ageSummary = getAgeSummary(data);

  // render the visualizations
  drawOutput(data, resourceSummary, ageBins, ageSummary);

  // save the output
  save("major_assignment.png");
}

/*
 * Load data from the specified URL or path
 */
Table loadData(String path) {
  return loadTable(path, "csv, header");
}

/*
 * Encode the resource columns with 1 for has resource, 0 otherwise.
 */
void cleanData(Table data) {
  String[] columns = RESOURCE_COLUMNS;
  String[] emptyValues = RESOURCE_EMPTY_VALUES;

  for (int i = 0; i < columns.length; i++) {
    for (TableRow row : data.rows()) {
      if (row.getString(columns[i]).equals(emptyValues[i])) {
        row.setInt(columns[i], 0);
      } else {
        row.setInt(columns[i], 1);
      }
    }
  }
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
 * Calculate the mean for the data points.
 */
float getMean(float[] data) {
  float total = 0;

  // calculate the sum of the data points
  for (int i = 0; i < data.length; i++) {
    total += data[i];
  }

  return total / data.length;
}

/*
 * Determine the data point median
 */
Float getMedian(float[] data) {
  data = sort(data);
  int middle = data.length / 2;

  if (data.length % 2 == 0) {
    return (data[middle - 1] + data[middle]) / 2.0;
  } else {
    return data[middle];
  }
}

/*
 * Calculate the standard deviation form the input data
 */
float getStandardDeviation(float[] data) {
  float sum = 0;
  float mean = getMean(data);

  for (int j = 0; j < data.length; j++) {
    sum = sum + ((data[j] - mean) * (data[j] - mean));
  }

  float squaredDiffMean = (sum) / (data.length); 
  float standardDev = (sqrt(squaredDiffMean)); 

  return standardDev;
}

/*
 * Get a summary of resources to use for vizulaization
 */
Table getResourceSummary(Table data) {
  // create the data table
  Table summary = new Table();
  summary.addColumn("Resource");
  summary.addColumn("Human");
  summary.addColumn("Zombie");

  // create the summary
  for (String column : RESOURCE_COLUMNS) {
    int humanCount = 0;
    int zombieCount = 0;

    // count the resources across all rows
    for (TableRow row : data.rows()) {
      if (row.getString("zombie").equals("Human")) {
        humanCount += row.getInt(column);
      } else {
        zombieCount += row.getInt(column);
      }
    }

    // add the new row
    TableRow row = summary.addRow();
    row.setString("Resource", column.substring(0, 1).toUpperCase() + column.substring(1));
    row.setInt("Human", humanCount);
    row.setInt("Zombie", zombieCount);
  }

  return summary;
}

/*
 * Summarize the age column into bins.
 */
Table getAgeBins(Table data) {
  // create the data table
  Table ageBins = new Table();
  ageBins.addColumn("Age Range");
  ageBins.addColumn("Human");
  ageBins.addColumn("Zombie");

  // create the rows for each bin
  TableRow[] bins = new TableRow[ceil(100.0 / AGE_BIN_SIZE)];
  for (int i = 0; i < bins.length; i++) {
    int start = i * AGE_BIN_SIZE + (1 * (i - i+1) );
    int end = (i+1) * AGE_BIN_SIZE;

    // add the new row
    bins[i] = ageBins.addRow();
    bins[i].setString("Age Range", start + " - " + end);
    bins[i].setInt("Human", 0);
    bins[i].setInt("Zombie", 0);
    //println(start, "-", end);
  }

  // populate the bins
  for (TableRow row : data.rows()) {
    for (int i = 0; i < bins.length; i++) {
      int start = i * AGE_BIN_SIZE + (1 * (i - i+1) );
      int end = (i+1) * AGE_BIN_SIZE;
      TableRow ageBin = bins[i];

      int humanTotal = ageBin.getInt("Human");
      int zombieTotal = ageBin.getInt("Zombie");

      int age = row.getInt("age");
      if ( (age >= start) && (age <= end) ) {
        if (row.getString("zombie").equals("Human")) {
          humanTotal++;
        } else {
          zombieTotal++;
        }

        // update the bin and do not check other bins
        ageBin.setInt("Human", humanTotal);
        ageBin.setInt("Zombie", zombieTotal);

        break;
      }
    }
  }

  return ageBins;
}

/*
 * Calculate the descriptive statistics for the age column split into zombies and humans.
 */
Table getAgeSummary(Table data) {
  // create the data table
  Table ageSummary = new Table();
  ageSummary.addColumn("Measurement");
  ageSummary.addColumn("Human");
  ageSummary.addColumn("Zombie");

  FloatList humanAges = new FloatList();
  FloatList zombieAges = new FloatList();

  // split the ages into human and zombies
  for (TableRow row : data.rows()) {
    if (row.getString("zombie").equals("Human")) {
      humanAges.append(row.getFloat("age"));
    } else {
      zombieAges.append(row.getFloat("age"));
    }
  }

  // calculate the summaries and add it to the output table
  TableRow countRow = ageSummary.addRow();
  countRow.setString("Measurement", "Count");
  countRow.setString("Human", nfc(humanAges.size(), 0));
  countRow.setString("Zombie", nfc(zombieAges.size(), 0));

  TableRow meanRow = ageSummary.addRow();
  meanRow.setString("Measurement", "Mean");
  meanRow.setString("Human", nfc(getMean(humanAges.array()), 1));
  meanRow.setString("Zombie", nfc(getMean(zombieAges.array()), 1));

  TableRow modeRow = ageSummary.addRow();
  modeRow.setString("Measurement", "Median");
  modeRow.setString("Human", nfc(getMedian(humanAges.array()), 1));
  modeRow.setString("Zombie", nfc(getMedian(zombieAges.array()), 1));  

  TableRow stdRow = ageSummary.addRow();
  stdRow.setString("Measurement", "Standard Deviation");
  stdRow.setString("Human", nfc(getStandardDeviation(humanAges.array()), 1));
  stdRow.setString("Zombie", nfc(getStandardDeviation(zombieAges.array()), 1));

  TableRow minRow = ageSummary.addRow();
  minRow.setString("Measurement", "Min");
  minRow.setString("Human", nfc(getMin(humanAges.array()), 0));
  minRow.setString("Zombie", nfc(getMin(zombieAges.array()), 0));

  TableRow maxRow = ageSummary.addRow();
  maxRow.setString("Measurement", "Max");
  maxRow.setString("Human", nfc(getMax(humanAges.array()), 0));
  maxRow.setString("Zombie", nfc(getMax(zombieAges.array()), 0));

  // return the age summary
  return ageSummary;
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
 * Get the overall summary of the data.
 * This is used for rendering the culstered bar chart. 
 */
float[][] overAllSummarize(Table data) {
  FloatList allDataPoints = new FloatList();
  for (TableRow row : data.rows()) {
    allDataPoints.append(row.getFloat("age"));
  }  

  float[][] allData = new float[2][allDataPoints.size()];
  allData[1] = allDataPoints.array();

  return summarize(allData);
}

/*
 * Render the data and visualization.
 */
void drawOutput(Table data, Table resourceSummary, Table ageBins, Table ageSummary) {
  background(BACKGROUND_COLOR);

  // draw the background logo
  drawBackground(255, color(240));

  stroke(STROKE_COLOR);
  strokeWeight(1);

  // draw the resource summary table
  float currentY = drawResourceSummaryTable(resourceSummary);
  currentY += TABLE_MARGIN;

  // draw the age bins table
  pushMatrix();
  translate(0, currentY); 
  currentY += drawAgeBinsTable(ageBins);
  popMatrix();

  // draw the age summary table
  pushMatrix();
  translate(0, currentY); 
  currentY += drawAgeSummaryTable(ageSummary);
  popMatrix();

  // draw the resource bar chart
  float tableWidth = 250;
  float chartWidth = width - tableWidth - CHART_MARGIN * 2;
  float chartHeight = (height / 2) - CHART_MARGIN;

  pushMatrix();
  translate(tableWidth + CHART_MARGIN, CHART_MARGIN); 
  float[][] overallSummmary = overAllSummarize(data);
  float clusterMargin = drawBarChart(resourceSummary, overallSummmary, chartWidth, chartHeight);
  popMatrix();
  
  // draw the age doughnut charts
  float doughnutWidth = (width - tableWidth - CHART_MARGIN * 2 - clusterMargin*2) / 2;
  float dougnutHeight = chartHeight;
  float leftOffset = tableWidth + clusterMargin/3 + 30;

  pushMatrix();
  translate(leftOffset + CHART_MARGIN, CHART_MARGIN * 1.2 + chartHeight); 
  //rect(0, 0, chartWidth , chartHeight);
  //fill(ALT_CHART_COLORS[3]);
  //rect(chartWidth/2 + clusterMargin/2, 0, 1, chartHeight);
  drawDoughnutChart(ageBins, "Human", doughnutWidth, dougnutHeight);
  popMatrix();
  
  pushMatrix();
  translate(leftOffset + doughnutWidth + CHART_MARGIN, chartHeight + CHART_MARGIN * 1.2); 
  drawDoughnutChart(ageBins, "Zombie", doughnutWidth, dougnutHeight);
  popMatrix();
  
}

/*
 * Draw the data and chart legend
 */
float drawResourceSummaryTable(Table resourceSummary) {
  return drawDataTable(resourceSummary, true, true, LEGEND_OFFSET, CHART_COLORS, RESOURCE_SUMMARY_FIRST_COLUMN_WIDTH, RESOURCE_SUMMARY_COLUMN_WIDTH, LEFT, CENTER);
}

/*
 * Draw the data table with the age bins.
 */
float drawAgeBinsTable(Table ageBins) {
  return drawDataTable(ageBins, true, true, LEGEND_OFFSET + 40, ALT_CHART_COLORS, 60, RESOURCE_SUMMARY_COLUMN_WIDTH, RIGHT, CENTER);
}

/*
 * Draw the data table with the age summary.
 */
float drawAgeSummaryTable(Table ageSummary) {
  return drawDataTable(ageSummary, false, false, 0, ALT_CHART_COLORS, 60 + LEGEND_OFFSET + 40, RESOURCE_SUMMARY_COLUMN_WIDTH, LEFT, CENTER);
}


/*
 * Render a data table
 */
float drawDataTable(Table data, boolean heading, boolean legend, float ledgendOffset, color[] chartColors, float firstColumnSize, float columnSize, int alignFirst, int align) {
  textSize(TEXT_SIZE);
  fill(STROKE_COLOR); 

  int x = 20;
  int y = 30;

  float current_x = x;
  // render the heading
  if (heading) {
    current_x = drawDataPoints(x + ledgendOffset, y, columnsToString(data), firstColumnSize, columnSize, alignFirst, align);
    y += NEWLINE_SIZE + 10;
  } else {
    y += 3;
  }

  // render the data points
  int currentRow = 0;
  for (TableRow row : data.rows()) {
    current_x = drawDataPoints(x + ledgendOffset, y, rowToString(row), firstColumnSize, columnSize, alignFirst, align);

    // draw the legend color
    if (legend) {
      fill(chartColors[currentRow]);
      stroke(STROKE_COLOR);
      strokeWeight(1);
      rect(x, y - LEGEND_BOX_SIZE, LEGEND_BOX_SIZE, LEGEND_BOX_SIZE);
    }

    y += NEWLINE_SIZE;
    currentRow++;
  }

  // render the borders
  noFill();
  float outerWidth = ledgendOffset + firstColumnSize + columnSize * (data.getColumnCount()-1);
  float headingHeight = heading ? NEWLINE_SIZE  + 10 : 0;
  float outerHeight = 10 + NEWLINE_SIZE * (data.getRowCount()) + headingHeight;

  rect(10, 10, outerWidth, outerHeight);
  if (heading) rect(10, 10, outerWidth, 27);  

  // return the table height
  return outerHeight;
}

/*
 * Render a row of data points.
 */
float drawDataPoints(float x, float y, ArrayList<String> data, float firstColumnSize, float columnSize, int alignFirst, int align) {
  textAlign(alignFirst, BOTTOM);
  fill(STROKE_COLOR);

  for (int i = 0; i < data.size(); i++) {
    text(data.get(i), x, y);
    x += i == 0 ? firstColumnSize : columnSize;
    textAlign(align, BOTTOM);
  }

  return x;
}

/*
 * Return the columns of a table as a string array
 */
ArrayList<String> columnsToString(Table table) {
  ArrayList<String> columnStrings = new ArrayList<String>();

  for (int i = 0; i < table.getColumnCount(); i++) {
    columnStrings.add(table.getColumnTitle(i));
  }

  return columnStrings;
}

/*
 * Return the values a table row as a string array
 */
ArrayList<String> rowToString(TableRow row) {
  ArrayList<String> rowStrings = new ArrayList<String>();

  for (int i = 0; i < row.getColumnCount(); i++) {
    rowStrings.add(row.getString(i));
  }

  return rowStrings;
}

/*
 * Draw the clustered bar chart.
 */
float drawBarChart(Table data, float[][] overallSummmary, float chartWidth, float chartHeight) {
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
  float clusterMargin = chartWidth * 0.05;
  float clusterSize = (chartWidth-leftOffset - clusterMargin*2) / (data.getColumnCount() - 1);
  for (int i = 0; i < data.getColumnCount() - 1; i++) {
    text(data.getColumnTitle(i+1), i * clusterSize + leftOffset + clusterMargin/2 + clusterSize/2 + i * clusterMargin/2, chartHeight-3);
  }

  //draw the vertical labels
  float bottomValue = (overallSummmary[1][0]);
  float topValue = (overallSummmary[1][1]);

  // caluclate the increments and set the new bottom value
  float increment = round( ((topValue - bottomValue) / (AXIS_INTEVALS - 2)));
  topValue = topValue + increment;
  bottomValue = bottomValue - increment;

  float actualIntervals = (topValue - bottomValue) / increment;
  //println(increment);

  textAlign(RIGHT, BOTTOM);
  for (int i = 0; i <= actualIntervals; i++) {
    text(nfc(bottomValue + (i * increment), 0), leftOffset-5, (chartHeight-10) - (i * axisHeight/actualIntervals));
  }

  // calculate the bar dimensions
  float clusterWidth = clusterSize - 10;
  float barWidth = clusterWidth / (data.getRowCount());

  // render the bars
  float currentOffset = clusterMargin + leftOffset;
  for (int columindex = 1; columindex < data.getColumnCount(); columindex++) {
    String columnName = data.getColumnTitle(columindex);
    println(columnName);

    for (int rowIndex = 0; rowIndex < data.getRowCount(); rowIndex++) {
      // calculate bar height
      float dataPoint = data.getFloat(rowIndex, columindex);
      float dataPointHeight = axisHeight * (dataPoint - bottomValue) / (topValue - bottomValue);

      fill(CHART_COLORS[rowIndex]);
      rect(currentOffset, axisHeight - dataPointHeight, barWidth, dataPointHeight);

      currentOffset += barWidth;
    }
    currentOffset += clusterMargin;
  }
  
  return clusterMargin;
}

/*
 * Draw a dougnut chart
 */
void drawDoughnutChart(Table data, String column, float doughnutWidth, float dougnutHeight) {
  float lastAngle = radians(-90);
  stroke(255);
  strokeWeight(1);
  
  //rect(0, 0, doughnutWidth, dougnutHeight);
  
  // calculate the chart size
  float chartSize = (doughnutWidth > dougnutHeight ? dougnutHeight : doughnutWidth) * 0.97;
  float chart_x = doughnutWidth / 2;
  float chart_y = dougnutHeight / 2;

  // calculate the column total
  float total = 0;
  for (TableRow row : data.rows()) {
    total += row.getFloat(column);
  }

  // draw the pie slices
  for (int rowIndex = 0; rowIndex < data.getRowCount(); rowIndex++) {
    Float dataValue = data.getFloat(rowIndex, column);
    float dataRatio = dataValue / total;

    fill(ALT_CHART_COLORS[rowIndex]);
    arc(chart_x, chart_y, chartSize, chartSize, lastAngle, lastAngle+radians(360 * dataRatio), PIE);
    lastAngle += radians(360 * dataRatio);
  }
  
  // draw the hole
  fill(255);
  circle(chart_x, chart_y, chartSize * 0.5);
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

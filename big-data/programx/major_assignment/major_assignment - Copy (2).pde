/** //<>// //<>//
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
final float RESOURCE_SUMMARY_FIRST_COLUMN_WIDTH = 100;
final float RESOURCE_SUMMARY_COLUMN_WIDTH = 50;

final int AGE_BIN_SIZE = 20;

final color[] CHART_COLORS = {
  #8E6CEF, #8399EB, #007ED6, #97D9FF, #5FB7D4, #7CDDDD, #26D7AE, #2DCB75, #1BAA2F, 
  #52D726, #D5F30B, #FFEC00, #FFAF00, #FF7300, #FF0000, #E01E84, #C758D0, #9C46D0, 
};

final color[] ALT_CHART_COLORS = {
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
  size(1000, 600);
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

  // Show the bins for debugging 
  if (DEBUG) {
    for (TableRow row : ageBins.rows()) {
      println(row.getString("Age Range"), row.getString("Human"), row.getString("Zombie"));
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
  
  // return the age summary
  return ageSummary;
}

/*
 * Render the data and visualization.
 */
void drawOutput(Table data, Table resourceSummary, Table ageBins, Table ageSummary) {
  background(BACKGROUND_COLOR);

  // draw the background logo
  //drawBackground(255, color(240));

  stroke(STROKE_COLOR);
  strokeWeight(1);

  // draw the resource summary table
  float currentY = drawResourceSummaryTable(resourceSummary);
  currentY += TABLE_MARGIN;

  // draw the age bins table
  pushMatrix();
  translate(0, currentY); 
  currentY += drawAgeBinsTable(ageBins);
  currentY += TABLE_MARGIN;
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
  }
  else {
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

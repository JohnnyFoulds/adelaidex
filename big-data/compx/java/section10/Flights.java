/**
 * Major Assignment 02 --- NYC Flights Analysis
 * @author                 Johannes Foulds
 */
package section10;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Scanner;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;

/**
 * TableRow --- A TableRow object represents a single row of data values, stored in columns, from a table.
 */
class TableRow {
    protected ArrayList<String> columns;
    protected String[]  values;

    /**
     * Create a new instance of a TableRow.
     * @param columns The columns of the row.
     */
    public TableRow(ArrayList<String> columns) {
        this.columns = columns;
        this.values = new String[this.columns.size()];
    }

    /**
     * Set the string value of the column at the specified index.
     * @param column The index of the column to update.
     * @param value The value to set the column to.
     */
    public void	setString(int column, String value) {
        this.values[column] = value;
    }

    /**
     * Set the string value of the column at the specified index.
     * @param columnName The title of the column to update.
     * @param value The value to set the column to.
     */
    public void	setString(String columnName, String value) {
        int column = this.columns.indexOf(columnName);
        this.setString(column, value);
    }

    /**
     * Get the string value from a row.
     * @param columnName The name of the column to get the value for.
     * @return Returns the value of the column.
     */
    public String getString(String columnName) {
        int column = this.columns.indexOf(columnName);
        return this.values[column];
    }

    /**
     * Get a double value from the specified column
     * @param columnName The name of the column to get the value for.
     * @return Returns the value of the column.
     */
    public double getDouble(String columnName) {
        int column = this.columns.indexOf(columnName);
        return Double.parseDouble(this.values[column]);
    }
}

/**
 * Table --- Table objects store data with multiple rows and columns.
 */
class Table {
    protected ArrayList<String> columns;
    protected ArrayList<TableRow> rows;

    /**
     * Create a default instance of the class.
     */
    public Table() {
        this.columns = new ArrayList<String>();
        this.rows = new ArrayList<TableRow>();
    }

    /**
     * Create a new table from an ArrayList of TableRows.
     * @param rows The rows to initialize the table with.
     */
    public Table(ArrayList<TableRow> rows) {
        this();
        if (rows.size() > 0) {
            this.columns = rows.get(0).columns;
            this.rows = rows;
        }
    }

    /**
     * Add a new table column.
     * @param title The column title.
     */
    public void addColumn(String title) {
        this.columns.add(title);
    }

    /**
     * Add a new table row.
     * @return Return the new table row.
     */
    public TableRow addRow() {
        TableRow row = new TableRow(this.columns);
        this.rows.add(row);

        return row;        
    }

    /**
     * Get the number of table tows.
     * @return Return the total number of rows in the table.
     */
    public int getRowCount() {
        return this.rows.size();
    }

    /**
     * Get a row at a specific index.
     * @param row The row index of the row to retrieve.
     * @return Return the row at the row index.
     */
    public TableRow getRow(int row) {
        return this.rows.get(row);
    }

    /**
     * 	Gets all rows from the table.
     * @return All the rows in the table.
     */
    public ArrayList<TableRow> rows() {
        return this.rows();
    }

    /**
     * 	Finds the rows in the Table that contain the value provided, and returns references to those rows.
     * @param value The value to match.
     * @param columnName Title of the column to search.
     * @return Returns an ArrayList of rows matching the criteria.
     */
    public ArrayList<TableRow> findRows(String value, String columnName) {
        ArrayList<TableRow> results = new ArrayList<TableRow>();

        for (TableRow row : this.rows) {
            if (row.getString(columnName).equals(value)) {
                results.add(row);
            }
        }

        return results;
    }

    /**
     * Get a column as a string array.
     * @param columnName The column to convert to an array.
     * @return Returns a String array with all values in the column.
     */
    public String[] toArray(String columnName) {
        String[] result = new String[this.getRowCount()];

        for (int i = 0; i < this.getRowCount(); i++) {
            result[i] = this.getRow(i).getString(columnName);
        }

        return result;
    }

    /**
     * Get a column as a double array.
     * @param columnName The column to convert to an array.
     * @return Returns a double array with all values in the column.
     */
    public double[] toDoubleArray(String columnName) {
        double[] result = new double[this.getRowCount()];

        for (int i = 0; i < this.getRowCount(); i++) {
            result[i] = this.getRow(i).getDouble(columnName);
        }
        
        return result;
    }

    /**
     * Get the unqiue values a column contains.
     * @param columnName The name to retrieve the list of unique values for.
     * @return A String array containing unique values.
     */
    String[] getUnique(String columnName) {
        // get the array of values for the column
        String[] values = this.toArray(columnName);
        List<String> valuesList = Arrays.asList(values);

        // use a hash set to get the unique values
        HashSet<String> valueSet = new HashSet<String>();
        valueSet.addAll(valuesList);

        return valueSet.toArray(new String[0]);
    }
}

/**
 * Flights --- Inherit from the Table class and implement functionality specific to flights.
 */
public class Flights extends Table {
    /**
     * Create a default instance of the class.
     */
    public Flights() {

    }

    /**
     * Create a new instance of the class and populate it with data read from a CSV file.
     * @param path The path to the CSV to read the data from.
     */
    public Flights(String path) {
        super();
        this.loadData(path);
    }

    /**
     * Populate the with data read from a CSV file.
     * @param path The path to the CSV to read the data from.
     */
    public void loadData(String path) {
        // initialize the columns and rows
        this.columns = new ArrayList<String>();
        this.rows = new ArrayList<TableRow>();

        // open the file for reading
        File f = new File(path);
        try {
            Scanner sc = new Scanner(f); 
            
            if (sc.hasNextLine()) {
                // process the header row
                String line = sc.nextLine();

                // yes this is a total cheat, but not worth the effort when this is a bad way to read csv files anyway
                String columns[] = line.replace("\"", "").split(",");

                for (String column : columns) {
                    this.addColumn(column);
                }

                // load the table rows
                while( sc.hasNextLine() ) {
                    line = sc.nextLine();
                    String values[] = line.replace("\"", "").split(",");

                    // check for NA values when the row should be exluded
                    boolean include = true;
                    for (String value : values) {
                        if (value.equals("NA")) {
                            include = false;
                            break;
                        }
                    }

                    // add the row to the dataset
                    if (include) {
                        TableRow row = this.addRow();
                        for (int i = 0; i < values.length; i++) {
                            row.setString(i, values[i]);
                        }
                    }
                }
            }

        } catch (FileNotFoundException ex) {
            System.out.println("File " + f + " not found.");
        }
    }

    /**
     * Determine the max value from a set of data points.
     * 
     * @param data The float array of values to determine the maximum value for.
     * @return Return the max value.
     */
    public static double getMax(double data[]) {
        double max = data[0];

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
    public static double getMin(double data[]) {
        double min = data[0];

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
    public static double getMean(double[] data) {
        double total = 0;

        // calculate the sum of the data points
        for (int i = 0; i < data.length; i++) {
            total += data[i];
        }

        return total / data.length;
    }

    /*
     * Determine the data point median
     */
    public static double getMedian(double[] data) {
        Arrays.sort(data);
        int middle = data.length / 2;

        if (data.length % 2 == 0) {
            return (data[middle - 1] + data[middle]) / 2.0;
        } else {
            return data[middle];
        }
    }

    /**
     * This is the entry point to the application for answering the assignment questions.
     * @param args
     */
    public static void main(String[] args) {
        String sourcePath = "section10/Flights.csv";

        // create a new instance of the class
        Flights flights = new Flights(sourcePath);
        System.out.println("Rows Read: " + flights.getRowCount());

        // get a test row
        TableRow testRow = flights.getRow(0);
        System.out.println("0 - tailnum: " + testRow.getString("tailnum"));

        // find the number of flights leaving airports
        String[] origins = {"EWR", "JFK", "LGA"};
        for (String origin : origins) {
            System.out.println(String.format(
                "Flights leaving %s: %s",
                origin,
                flights.findRows(origin, "origin").size()));
        }

        System.out.println("\n--- Part 1: Question 4-7");
        // get the LGA rows
        Table lgaTable = new Table(flights.findRows("LGA", "origin"));
        
        // get distance as a double array for processing
        double[] lgaDistance = lgaTable.toDoubleArray("distance");
        System.out.println("LGA min    : " + Flights.getMin(lgaDistance));
        System.out.println("LGA median : " + Flights.getMedian(lgaDistance));
        System.out.println("LGA mean   : " + Flights.getMean(lgaDistance));
        System.out.println("LGA max    : " + Flights.getMax(lgaDistance));

        System.out.println("\n--- Part 2: Question 1-3");
        String[] carriers = {"UA", "HA", "B6"};
        for (String carrier : carriers) {
            // get the flights operated by the carrier
            Table carrierTable = new Table(flights.findRows(carrier, "carrier"));

            System.out.println(String.format(
                "Unique Tailnums for %s: %s",
                carrier,
                carrierTable.getUnique("tailnum").length));
        }

        System.out.println("\n--- Part 2: Question 4");
        Table b6Table = new Table(flights.findRows("B6", "carrier"));
        Table b6December = new Table(b6Table.findRows("12", "month"));
        System.out.println("B6 unique Destinations (December): " + b6December.getUnique("dest").length);

        System.out.println("\n--- Part 2: Question 5");
        // get the total number of destinations
        int destTotal = flights.getUnique("dest").length;

        // get the destinations of LGA
        int destLGA = new Table(
            flights.findRows("LGA", "origin"))
            .getUnique("dest")
            .length;

        // show the unreachable destinations count
        System.out.println("Total destinations with no direct flight from LGA: " + 
            (destTotal - destLGA));
    }
}

/**
 * Major Assignment 02 --- NYC Flights Analysis: Part 3
 * @author                 Johannes Foulds
 */
package section10;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;


/**
 * FlightScheduler --- Implement a flight scheduled.
 */
public class FlightScheduler {
    protected Flights flights;
    protected Map<String, TableRow> clusteredFlightIndex;

    /**
     * Initialize a default instance of the class.
     */
    public FlightScheduler() {
        this.flights = new Flights();
        this.clusteredFlightIndex = new HashMap<String, TableRow>();
    }

    /**
     * Read flight data from a CSV file.
     * @param flightDataFile The path to the CSV file to load.
     */
    public void loadData(String flightDataFile) {
        // initilize this variable again in case of a second load
        this.clusteredFlightIndex = new HashMap<String, TableRow>();

        // load the data from CSV
        Table sourceData = new Flights(flightDataFile);

        // create the data table with the required additional column
        this.flights = new Flights();
        for (String columnName : sourceData.columns) {
            this.flights.addColumn(columnName);
        }

        // add the new column
        this.flights.addColumn("orignal_origin");
        
        // add the source rows and initialize the orignal_origin column
        for (TableRow row : sourceData.rows) {
            TableRow newRow = this.flights.addRow();
            
            // add the original data
            for (String columnName : row.columns) {
                newRow.setString(columnName, row.getString(columnName));
            }

            // initialize the orignal_origin column
            newRow.setString("orignal_origin", null);

            // add the row to the index
            this.addToIndex(newRow);
        }
    }

    /**
     * Get the clustered key for a fligh in the index.
     * @param day The day of the flight.
     * @param month The flight month.
     * @param year The year of the flight.
     * @param flightCode The flight code.
     * @return Return the clustered key as a string.
     */
    protected String getClusterKey(String day, String month, String year, String flightCode) {
        return String.format("%s_%s_%s_%s",
            year,
            month,
            day,
            flightCode
        );
    }

    /**
     * Add a row to the clustered index.
     * @param row The row to add to the index.
     */
    protected void addToIndex(TableRow row) {
        String clusteredKey = this.getClusterKey(
            row.getString("day"), 
            row.getString("month"), 
            row.getString("year"), 
            row.getString("flight"));

        // add the row to the index
        this.clusteredFlightIndex.put(clusteredKey, row);
    }

    /**
     * Re-allocate a flight to ECI.
     * @param day The day of the flight.
     * @param month The flight month.
     * @param year The year of the flight.
     * @param flightCode The flight code.
     */
    public void reallocate(int day, int month, int year, String flightCode) {
        // get the clustered key
        String clusteredKey = this.getClusterKey(
            String.valueOf(day), 
            String.valueOf(month), 
            String.valueOf(year), 
            flightCode);

        // get the row to update
        TableRow row = this.clusteredFlightIndex.get(clusteredKey);

        // set the new origin
        row.setString("orignal_origin", row.getString("origin"));
        row.setString("origin", "ECI");
    }

    /**
     * Check if a flight is moved to ECI
     * @param day The day of the flight.
     * @param month The flight month.
     * @param year The year of the flight.
     * @param flightCode The flight code.
     * @return Returns true if the flight has been moved, false otherwise.
     */
    public boolean check(int day, int month, int year, String flightCode) {
        // get the clustered key
        String clusteredKey = this.getClusterKey(
            String.valueOf(day), 
            String.valueOf(month), 
            String.valueOf(year), 
            flightCode);

        // get the row to update
        TableRow row = this.clusteredFlightIndex.get(clusteredKey);

        return row.getString("orignal_origin") != null;
    }

    /**
     * Estimate how many flights will be re-scheduled when ECI is added.
     * This is based on the simple realization that given the number of runways about 30% of flights will be send to ECI.
     * @return The estimated number of flight changes.
     */
    public long estimateFlightChanges() {
        // calculate the ratio of flights ECI should receive
        int totalRunways = 3 + 2 + 4 + 4;
        double eciRatio = 4.0 / totalRunways;

        // get the total number of flights
        int totalFlights = flights.getRowCount();

        // calculate the number of flight changes
        double flightChanges = eciRatio * totalFlights;

        // return the result
        return Math.round(flightChanges);
    }

    /**
     * The main function for testing and debugging.
     * @param args Command line arguments.
     */
    public static void main(String[] args) {
        FlightScheduler scheduler = new FlightScheduler();
        scheduler.loadData("section10/Flights.csv");

        // calculate flight re-allocation
        //System.out.println("Re-allocations: " + scheduler.estimateFlightChanges());

        // reallocate a flight
        System.out.println(scheduler.check(25, 2, 2013, "743"));
        scheduler.reallocate(10, 7, 2013, "3910");
        System.out.println(scheduler.check(10, 7, 2013, "3910"));
        System.out.println(scheduler.check(25, 2, 2013, "743"));
    }    
}

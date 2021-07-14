/**
 * Major Assignment 02 --- NYC Flights Analysis: Part 3
 * @author                 Johannes Foulds
 */
package section10;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

/**
 * Implement a table index to use in the flight scheduler.
 */
class TableIndex {
    public Map<String, ArrayList<TableRow>> rows;
    public TableIndex childIndex;

    /**
     * Create a default instance of the class.
     */
    public TableIndex() {
        this.rows = new HashMap<String, ArrayList<TableRow>>();
        this.childIndex = new TableIndex();
    }

    /**
     * Add a new row to the index.
     * @param key The row index
     * @param row The row to add
     */
    void addRow(String key, TableRow row) {
        // get the row collection to add to
        ArrayList<TableRow> rows = this.rows.get(key);
        if (rows == null) rows = new ArrayList<TableRow>();

        // add the row to the index
        rows.add(row);
        this.rows.put(key, rows);
    }
}

/**
 * FlightScheduler --- Implement a flight scheduled.
 */
public class FlightScheduler {
    protected Flights flights;
    protected TableIndex dateIndex;

    /**
     * Initialize a default instance of the class.
     */
    public FlightScheduler() {
        this.flights = new Flights();
    }

    /**
     * Read flight data from a CSV file.
     * @param flightDataFile The path to the CSV file to load.
     */
    public void loadData(String flightDataFile) {
        Table sourceData = new Flights(flightDataFile);

        // create the data table with the required additional rows
        

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
        System.out.println("Re-allocations: " + scheduler.estimateFlightChanges());
    }    
}

/**
 * Major Assignment 02 --- NYC Flights Analysis: Part 3
 * @author                 Johannes Foulds
 */
package section10;

public class FlightScheduler {
    protected Flights flights;
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
        this.flights.loadData(flightDataFile);
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

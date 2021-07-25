package major_assignment;

import java.util.function.IntFunction;

/**
 * FlajoletMartin --- An implementation of the Flajolet-Martin Algorithm.
 */
public class FlajoletMartin {
    /**
     *Class variables.
     */
    public IntFunction hashFunction;
    public int hashLength;
    public int maxTailLength; 

    /**
     * Initialize a new instance of the class.
     * @param hashFunction The function used to hash integer values.
     * @param hashLength The length of hash values.
     */
    public FlajoletMartin(IntFunction hashFunction, int hashLength) {
        super();
        this.hashFunction = hashFunction;
        this.hashLength = hashLength;
        this.reset();
    }

    /**
     * Reset the object to process a new stream of items.
     */
    public void reset() {
        this.maxTailLength = 0;
    }

    /**
     * Compute the hash value for the input integer.
     * @param x The integer to compute the hash for.
     * @return Returns a binary string with the hash value of the integer.
     */
    public String getHash(int x) {
        String formatString = "%1$" + this.hashLength + "s";
        String binaryString = Integer.toBinaryString((int)this.hashFunction.apply(x));

        return String.format(formatString, binaryString).replace(' ', '0');
    }

    /**
     * Get the number of zeros at the end of a binary string.
     * @param binaryString The binary string to determine the number of trailing zeros for.
     * @return Return the number of trailing zeros.
     */
    public int getTrailingZeros(String binaryString) {
        return binaryString.length() - binaryString.replaceAll("0+$", "").length();
    }

    /**
     * Process an item coming from the input stream.
     * @param item The item to process.
     */
    public void processStreamItem(int item) {
        String binaryString = this.getHash(item);
        int trailingZeros = this.getTrailingZeros(binaryString);

        // if a new max tail length was found, set it to the class variable.
        if (trailingZeros > this.maxTailLength) {
            this.maxTailLength = trailingZeros;
        }
    }

    /**
     * Compute the estimate for the number of unique items.
     * @return The estimated number of unique stream items.
     */
    public double getUniqueEstimate() {
        return Math.pow(2, this.maxTailLength);
    }

    /**
     * Compute the answers for the hash function of a question.
     * @param dataStream The data stream of items to process.
     */
    public static void ComputeAnswers(int[] dataStream, IntFunction hashFunction) {
        // create the estimator
        FlajoletMartin estimator = new FlajoletMartin(hashFunction, 5);

        // process the data stream items
        for (int item : dataStream) {
            estimator.processStreamItem(item);
        }

        // display the results
        System.out.println("Maximum tail length: " + estimator.maxTailLength);
        System.out.println("Estimate of the number of distinct elements: " + estimator.getUniqueEstimate());
    }

    /**
     * Test the functionality of the FlajoletMartin class.
     * @param args Command line arguments are not processed.
     */
    public static void main(String[] args) {
        int[] dataStream = {3, 1, 4, 6, 5, 9};
        
        System.out.println("--- Question 1 ---");
        ComputeAnswers(dataStream, 
            (x) -> (2 * x + 1) % 32);

        System.out.println("--- Question 2 ---");
        ComputeAnswers(dataStream, 
            (x) -> (3 * x + 7) % 32);

        System.out.println("--- Question 3 ---");
        ComputeAnswers(dataStream, 
            (x) -> (4 * x) % 32);
    }
}

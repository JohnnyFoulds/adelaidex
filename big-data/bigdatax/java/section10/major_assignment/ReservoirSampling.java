package major_assignment;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Random;
import java.util.stream.IntStream;

/**
 * ReservoirSampling --- This class is an implementation of reservoir sampling.
 */
public class ReservoirSampling {
    /**
     * Determine if the j-th item should be included based on probability k/j
     * @param k The maximum number of items to include in the sumple.
     * @param j The index of the item to consider (the j-th element received).
     * @return Returns true if the item should be included in the sample, false otherwise.
     */
    public static boolean shouldInclude(int k, int j) {
        boolean include = false;

        if (j <= k) {
            include = true;
        }
        else {
            double pr = (double)k / j;
            include = Math.random() <= pr;
        }

        return include;
    }

    /**
     * Select a sample of data points of size k from the input array.
     * @param inputs The data points to take the sample on.
     * @param k The maximum of items to include in the sample.
     * @return Returns an integer array of points sampled form the input stream.
     */
    public static int[] sampleData(int[] inputs, int k) {
        Random rand = new Random();
        ArrayList<Integer> sample = new ArrayList<Integer>();
        int n = 0;

        for (int item : inputs) {
            n++;
            if (shouldInclude(k, n)) {
                // determine where the item should be inserted
                if (n <= k) {
                    sample.add(item);
                } else {
                    int insertIndex = rand.nextInt(k);
                    sample.set(insertIndex, item);
                }
            }

            // print the current sample
            System.out.print(String.format("%1$4s", n));
            System.out.println(" -- " + sample);
        }

        // generate the output array
        int[] sampleArray = new int[sample.size()];
        for (int i = 0; i < sample.size(); i++) sampleArray[i] = sample.get(i);

        return sampleArray;
    }

    /**
     * The main function to test the reservoir sampleing method.
     * @param args Command line areguments are ignored.
     */
    public static void main(String[] args) {
        int[] dataStream = IntStream.rangeClosed(1, 1000).toArray();
        sampleData(dataStream, 10);
    }    
}

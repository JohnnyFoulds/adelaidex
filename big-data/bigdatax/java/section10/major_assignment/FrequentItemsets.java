package major_assignment;

import java.util.ArrayList;
import java.util.Arrays;

import major_assignment.Apriori.ItemCount;

/**
 * FrequentItemsets --- This class is used to identify frequent items set for Part 2 of Major Assignment 2.
 */
public class FrequentItemsets {
    public FrequentItemsets() {
        super();
    }

    /**
     * If the support threshold is 5, which items are frequent?
     * @param apriori The initialized Apriori object.
     */
    public static void Question01(Apriori apriori) {
        System.out.println("--- Question 1: Frequent Items ---");
        ArrayList<ItemCount> frequentItems = apriori.getSingletons(5);
        apriori.printItemCountList(frequentItems);
    }

    /**
     * Get the indexes for a list of items.
     * @param apriori The initialized Apriori object.
     * @param items The item names to get the item indexes for.
     * @return Returns an integer array with the indexes.
     */
    public static int[] getItemIndexes(Apriori apriori, String[] items) {
        int[] indexes = new int[items.length];

        for (int i = 0; i < items.length; i++) {
            indexes[i] = apriori.itemIndexes.get(items[i]);
        }

        return indexes;
    }

    /**
     * Find baskets containing a set of items.
     * @param apriori The initialized Apriori object.
     * @param set The indexes, NOT names, of the set items to look for.
     * @param limit The maximum number of baskets to find.
     */
    public static void findBasketsWithSet(Apriori apriori, int[] set, int limit) {
        ArrayList<Integer> matchingBaskets = new ArrayList<Integer>();
        int basketsFound = 0;

        // get a list of baskets matching the items
        for (int basketIndex = 0; basketIndex < apriori.baskets.size(); basketIndex++) {
            int[] basket = apriori.baskets.get(basketIndex);
            int sum = 0;

            for (int itemIndex = 0; itemIndex < set.length; itemIndex++) {
                sum += basket[set[itemIndex]];
            }

            // if the basket contains all the items show it's number
            if (sum == set.length) {
                matchingBaskets.add(basketIndex + 1);
                basketsFound++;

                // quit the loop if the max number of baskets was found
                if (basketsFound == limit) {
                    break;
                }
            }
        }

        // show the matching baskets
        System.out.println(Arrays.toString(matchingBaskets.toArray(new Integer[matchingBaskets.size()])));
    }

    /**
     * Get 5 baskets with [5, 20] in them.
     * @param apriori The initialized Apriori object.
     */
    public static void Question02(Apriori apriori) {
        System.out.println("--- Question 2: Baskets Containing (5, 20) ---");

        // get the item indexes to use for searching the matrix
        int[] items = getItemIndexes(apriori, new String[] {"5", "20"});
        findBasketsWithSet(apriori, items, 5);
    }

    /**
     * For a support threshold of 5, give three different frequent triples containing item 10. For each frequent triple, list 5 basket numbers where the different items appear together.
     * @param apriori The initialized Apriori object.
     */
    public static void Question03(Apriori apriori) {
        System.out.println("--- Question 3 ---");

        // get the item index of basket item "10"
        int itemIndex = apriori.itemIndexes.get("10");

        // get the freqent triples containg item 10
        ArrayList<ItemCount> matchingTriples = new ArrayList<ItemCount>();
        ArrayList<ItemCount> frequentTriples = apriori.getFrequentItems(5, 3);

        for (ItemCount triple : frequentTriples) {
            if (np.contains(triple.items, itemIndex)) {
                matchingTriples.add(triple);
            }
        }

        // for the first 3 triples, find 5 baskets containing the triple
        for (int tripleIndex = 0; tripleIndex < 5; tripleIndex++) {
            //System.out.println(matchingTriples.get(tripleIndex));
        }

        apriori.printItemCountList(matchingTriples);
    }

    /**
     * The main entry point to perform the required computations.
     * @param args No command line arguments are processed by the main function.
     */
    public static void main(String[] args) {
        // create the list of item names
        String[] itemNames = new String[150];
        for (int i = 1; i <= 150; i++) itemNames[i-1] = Integer.toString(i);

        // create the apriori object
        Apriori apriori = new Apriori(itemNames);

        // generate the baskets
        for (int basketIndex = 1; basketIndex <= 150; basketIndex++) {
            ArrayList<String> basket = new ArrayList<String>();

            // selet the items to add to the basket -- if basketIndex mod item = 0
            for (int item = 1; item <= 150; item++) {
                if (basketIndex % item == 0) {
                    basket.add(Integer.toString(item));
                }
            }

            // add the basked to the apriori object
            apriori.addBasket(basket.toArray(new String[basket.size()]));
        }

        //apriori.printBasket(12 - 1);
        //System.out.println(Arrays.toString(np.sum(apriori.baskets, 0)));

        // --- question 1 ---
        //Question01(apriori);

        // --- question 2 ---
        //Question02(apriori);

        // --- question 3 ---
        Question03(apriori);
    }
}

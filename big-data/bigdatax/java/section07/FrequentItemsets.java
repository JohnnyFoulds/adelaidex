package section07;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;

/**
 * np --- Matrix operations helper class.
 */
class np {

    /**
     * Sum of array elements over a given axis.
     * @param a Elements to sum.
     * @param axis Axis or axes along which a sum is performed.
     * @return An array with the same shape as a, with the specified axis removed.
     */
    public static int[] sum(ArrayList<int []> a, Integer axis) {
        int[] sum = null;

        if (axis == 0) {
            // this is the column sum
            sum = new int[a.get(0).length];

            for (int row = 0; row < a.size(); row++) {
                for (int col = 0; col < a.get(row).length; col++) {
                    sum[col] = sum[col] + a.get(row)[col];
                }

            }
        }
        else if (axis == 1) {
            // calculate the row sum
            sum = new int[a.size()];

            for (int row = 0; row < a.size(); row++) {
                for (int col = 0; col < a.get(row).length; col++) {
                    sum[row] = sum[row] + a.get(row)[col];
                }
            }
        }

        return sum;
    }

    /**
     * Print the contents of an array to sysout.
     * @param a The array to display.
     */
    public static void print(int[] a) {
        System.out.println(Arrays.toString(a));
    }

    public static boolean contains(final int[] arr, final int key) {
        return Arrays.stream(arr).anyMatch(i -> i == key);
    }    
}

/**
 * FrequentItemsets --- This class allows the identification of frequent itemsets.
 */
public class FrequentItemsets {
    /**
     * ItemCount --- Hold the index of items being counted in the set and the frequency of the combination.
     */
    public class ItemCount {
        public int[] items;
        public int frequency;

        /**
         * Initialize a new instance of the class.
         * @param items The index of the items in the set.
         * @param frequency The frequency of the combination of items found in baskets.
         */
        public ItemCount(int[] items, int frequency) {
            super();
            this.items = items;
            this.frequency = frequency;
        }

        @Override
        public String toString() {
            return Arrays.toString(items) + " " + frequency;
        }
    }

    /**
     * AssociationRule --- Hold the details for an association rule.
     */
    public class AssociationRule {
        public int[] x;
        public int[] y;
        public double confidence;
        public String[] itemNames;

        /**
         * Create a new instance of the class.
         * @param x The itemset that leads to y.
         * @param y What the x itemset leads to.
         * @param confidence The confidence of the association rule.
         */
        public AssociationRule(int[] x, int[] y, double confidence, String[] itemNames) {
            super();
            this.x = x;
            this.y = y;
            this.confidence = confidence;
            this.itemNames = itemNames;
        }

        /**
         * Return a string representation of the association rule.
         */
        @Override
        public String toString() {
            String[] xNames = new String[this.x.length];
            String[] yNames = new String[this.y.length];

            // get the item names for x
            for (int i = 0; i < this.x.length; i++) xNames[i] = this.itemNames[this.x[i]];
            for (int i = 0; i < this.y.length; i++) yNames[i] = this.itemNames[this.y[i]];

            return Arrays.toString(xNames) + " => " + Arrays.toString(yNames) + " -- " + this.confidence;
        }
    }

    /**
     * Class level variables.
     */
    protected HashMap<String, Integer> itemIndexes;
    protected HashMap<Integer, String> itemNames;
    protected ArrayList<int[]> baskets;

    /**
     * Initialize a new instance of the class
     */
    public FrequentItemsets(String[] itemNames) {
        super();
        this.InitializeItemNames(itemNames);
    }

    /**
     * Initialize the item name dictionary.
     * @param itemNames An array of all the names of possible items in a basket.
     */
    public void InitializeItemNames(String[] itemNames) {
        // load the items into the dictionary
        this.itemIndexes = new HashMap<String, Integer>();
        this.itemNames = new HashMap<Integer, String>();

        for (int i = 0; i < itemNames.length; i++) {
            this.itemIndexes.put(itemNames[i], i);
            this.itemNames.put(i, itemNames[i]);
        }

        // initialize the basket collection
        this.baskets = new ArrayList<int[]>();
    }

    /**
     * Add a basked of items to the basket collection.
     * @param baskedItems The items in the basket.
     */
    public void addBasket(String[] baskedItems) {
        int[] basketMatrix = new int[this.itemIndexes.size()];

        for (String itemName : baskedItems) {
            int itemIndex = this.itemIndexes.get(itemName);
            basketMatrix[itemIndex] = 1;
        }

        this.baskets.add(basketMatrix);
    }

    /**
     * Show the basket matrix.
     */
    public void printBasketMatrix() {
        for (int[] basket : this.baskets) {
            np.print(basket);
        }
    }

    /**
     * Get the list of singletons with frequency >= s.
     * @param s The minimum frequency to match.
     * @return Returns a list of singletons
     */
    public ArrayList<ItemCount> getSingletons(int s) {
        ArrayList<ItemCount> singletons = new ArrayList<ItemCount>();

        // get the summed column values
        int[] columnTotals = np.sum(this.baskets, 0);

        // get the list of singletons
        for (int itemIndex = 0; itemIndex < columnTotals.length; itemIndex++) {
            if (columnTotals[itemIndex] >= s) {
                ItemCount itemCount = new ItemCount(
                    new int[] {itemIndex},
                    columnTotals[itemIndex]
                );

                singletons.add(itemCount);
            }
        }

        return singletons;
    }

    /**
     * Get a list of frequent itemsets.
     * @param s The minimum frequency to match.
     * @param n The number of items to group when creating the matches.
     * @return Returns a list of frequent itemsets.
     */
    public ArrayList<ItemCount> getFrequentItems(int s, int n) {
        if (n == 1) {
            return this.getSingletons(s);
        }
        else {
            return this.getFrequentItems(s, n, this.getSingletons(s));
        }
    }

    /**
     * Get a list of frequent itemsets starting from the list provided in itemCounts.
     * @param s The minimum frequency to match.
     * @param n The number of items to group when creating the matches.
     * @param itemCounts The itemset list to use as the starting point.
     * @return Returns a list of frequent itemsets.
     */
    public ArrayList<ItemCount> getFrequentItems(int s, int n, ArrayList<ItemCount> itemCounts) {
        if (n == 1) {
            return itemCounts;
        }
        else
        {
            ArrayList<String> itemKeys = new ArrayList<String>();
            ArrayList<ItemCount> itemSet = new ArrayList<ItemCount>();

            // get the list of item columns to consider
            Set<Integer> relevantColums = new HashSet<Integer>();
            for (ItemCount item : itemCounts) for (int column : item.items) relevantColums.add(column);

            for (ItemCount itemCount : itemCounts) {
                for (int columnIndex = 0; columnIndex < this.itemNames.size(); columnIndex++) {
                    if (relevantColums.contains(columnIndex) && !np.contains(itemCount.items, columnIndex)) {
                        // create a item count for the itemcounts with the additional column
                        int[] currentIndex = new int[itemCount.items.length + 1];
                        for (int i = 0; i < itemCount.items.length; i++) currentIndex[i] = itemCount.items[i];
                        currentIndex[itemCount.items.length] = columnIndex;
                        Arrays.sort(currentIndex);

                        String currentIndexKey = Arrays.toString(currentIndex);
                        if (!itemKeys.contains(currentIndexKey)) {
                            itemKeys.add(currentIndexKey);

                            ItemCount currentItemCount = new ItemCount(currentIndex, 0);

                            // find matches in the baskets
                            for (int[] basket : this.baskets) {
                                int matches = 0;
                                for (int i = 0; i < currentIndex.length; i++) {
                                    if (basket[currentIndex[i]] != 0) {
                                        matches++;
                                    }
                                }

                                if (matches == currentIndex.length) {
                                    currentItemCount.frequency++;
                                }
                            }

                            // add the item to the new item set if the frequency is greater or equal to s
                            if (currentItemCount.frequency >= s) {
                                itemSet.add(currentItemCount);
                            }
                        }
                    }
               }
           }

           // process the next step
           return this.getFrequentItems(s, n-1, itemSet);
        }
    }

    //getAssociationRules

    /**
     * Print an ItemCount list with basket item names.
     * @param itemCountList The item count list to output to stdout.
     */
    public void printItemCountList(ArrayList<ItemCount> itemCountList) {
        for (ItemCount itemCount : itemCountList) {
            // print the items in the set
            System.out.print("[");
            for (int i = 0; i < itemCount.items.length; i++) {
                int itemIndex = itemCount.items[i];
                System.out.print(this.itemNames.get(itemIndex));

                if (i < itemCount.items.length - 1) {
                    System.out.print(", ");
                }
            }
            System.out.print("]");

            // print the frequemcey
            System.out.println(" " + itemCount.frequency);
        }
    }

    /**
     * Test the FrequentItemsets class.
     */
    public static void main(String[] args) {
        String[] itemNames = {
            "Bread", "Oranges", "Grapes", "Cereal", "Strawberries", "Eggs", "Milk", "Diapers", "Beer", "Apples"
        };

        FrequentItemsets itemset = new FrequentItemsets(itemNames);
        itemset.addBasket(new String[] {"Bread", "Oranges", "Grapes"});
        itemset.addBasket(new String[] {"Grapes", "Cereal", "Strawberries"});
        itemset.addBasket(new String[] {"Eggs", "Milk", "Bread", "Diapers", "Beer", "Strawberries"});
        itemset.addBasket(new String[] {"Milk", "Cereal", "Diapers", "Beer", "Apples"});
        itemset.addBasket(new String[] {"Milk", "Eggs", "Diapers", "Bread"});

        //itemset.getAssociationRules(0);
        //AssociationRule r = itemset.new AssociationRule(new int[] {0, 1}, new int[] {2}, 3, itemNames);
        //System.out.println(r);

        // String[] itemNames = {
        //     "Chocolate",
        //     "Beer",
        //     "Milk",
        //     "Bread",
        //     "Eggs",
        //     "Oranges",
        //     "Strawberries",
        //     "Diapers",
        //     "Cereal",
        //     "Grapes",
        //     "Apples",
        //     "Brocolli",
        //     "Pears"
        // };
        
        // FrequentItemsets itemset = new FrequentItemsets(itemNames);
        
        // // add the item baskets
        // itemset.addBasket(new String[] {"Chocolate", "Beer", "Milk", "Bread"});
        // itemset.addBasket(new String[] {"Bread", "Eggs", "Chocolate", "Oranges", "Milk", "Beer"});
        // itemset.addBasket(new String[] {"Chocolate", "Oranges", "Eggs", "Strawberries", "Milk"});
        // itemset.addBasket(new String[] {"Strawberries", "Milk", "Diapers", "Cereal"});
        // itemset.addBasket(new String[] {"Chocolate", "Beer", "Grapes", "Diapers", "Apples"});
        // itemset.addBasket(new String[] {"Milk", "Chocolate", "Cereal", "Diapers"});
        // itemset.addBasket(new String[] {"Milk", "Beer", "Chocolate", "Grapes", "Eggs", "Brocolli"});
        // itemset.addBasket(new String[] {"Brocolli", "Pears", "Milk", "Beer"});

        // System.out.println("--- Basket Matrix ---");
        // itemset.printBasketMatrix();

        // System.out.println("--- Basket Column Sums ---");
        // np.print(np.sum(itemset.baskets, 0));

        // System.out.println("--- Singletons (s=3) ---");
        // ArrayList<ItemCount> singletons = itemset.getSingletons(3);
        // itemset.printItemCountList(singletons);

        // System.out.println("--- Frequent Items (s=3, n=2) ---");
        // itemset.printItemCountList(itemset.getFrequentItems(3, 2));

        // System.out.println("--- Frequent Items (s=3, n=3) ---");
        // itemset.printItemCountList(itemset.getFrequentItems(3, 3));

        // System.out.println("=== SUPPORT ===");
        // System.out.println("--- Singletons (s=1) ---");
        // itemset.printItemCountList(itemset.getSingletons(1));

        // System.out.println("--- Frequent Items (s=1, n=2) ---");
        // itemset.printItemCountList(itemset.getFrequentItems(1, 2));

    }
}
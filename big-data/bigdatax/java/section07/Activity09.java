import section07.*;
import section07.Apriori.*;
import java.util.ArrayList;

public class Activity09 {
    public static void question01() {
        String[] itemNames = { "A", "B", "C", "D", "E", "F", "G" };
        Apriori itemset = new Apriori(itemNames);

        // add the baskets
        itemset.addBasket(new String[] {"A", "B", "D", "G"});
        itemset.addBasket(new String[] {"B", "D", "E"});
        itemset.addBasket(new String[] {"A", "B", "C", "E", "F"});
        itemset.addBasket(new String[] {"B", "D", "E", "G"});
        itemset.addBasket(new String[] {"A", "B", "C", "E", "F"});
        itemset.addBasket(new String[] {"B", "E", "G"});
        itemset.addBasket(new String[] {"A", "C", "D", "E"});
        itemset.addBasket(new String[] {"B", "E"});
        itemset.addBasket(new String[] {"A", "B", "E", "F"});
        itemset.addBasket(new String[] {"A", "C", "D", "E"});

        System.out.println("--- Singletons (s=4) ---");
        ArrayList<ItemCount> singletons = itemset.getSingletons(4);
        itemset.printItemCountList(singletons);

        System.out.println("--- Frequent Items (s=4, n=2) ---");
        itemset.printItemCountList(itemset.getFrequentItems(4, 2));

        System.out.println("--- Frequent Items (s=5, n=2) ---");
        itemset.printItemCountList(itemset.getFrequentItems(5, 2));

        System.out.println("--- Association Rules (coonfidence=1) ---");
        ArrayList<AssociationRule> rules = itemset.getAssociationRules();
        for (AssociationRule rule : rules) {
            if (rule.confidence == 1) {
                System.out.println(rule);
            }
        }
    }

    public static void question06() {
        String[] itemNames = { "A", "B", "C", "D", "E"};
        Apriori itemset = new Apriori(itemNames);

        // add the baskets
        itemset.addBasket(new String[] {"A", "C", "D"});
        itemset.addBasket(new String[] {"B", "C", "E"});
        itemset.addBasket(new String[] {"A", "B", "C", "E"});
        itemset.addBasket(new String[] {"B", "E"});

        System.out.println("--- Question 6: Frequent Items ---");
        int n = 1;
        int s = 2;
        ArrayList<ItemCount> frequentItems = itemset.getFrequentItems(s, n);
        while (frequentItems.size() > 0) {
            itemset.printItemCountList(frequentItems);

            n++;
            frequentItems = itemset.getFrequentItems(s, n);
        }
    }


    public static void main(String[] args) {
        question06();
	}    
}

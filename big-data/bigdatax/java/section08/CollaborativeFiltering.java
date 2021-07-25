import java.util.Arrays;

/**
 * CollaborativeFiltering --- Caclulate Jaccard and cosine similarity between users.
 */
public class CollaborativeFiltering {
    final int[][] ratingMatrix;

    /**
     * Create a new instance of the class.
     * @param ratingMatrix The rating matrix to use for computations.
     */
    public CollaborativeFiltering(int[][] ratingMatrix) {
        super();
        this.ratingMatrix = ratingMatrix;
    }

    /**
     * Calculate the cosine similarity betwee two users.
     * @param user1 The index of the first user to compare.
     * @param user2 The index of the second user to compare.
     * @return Return the cosine similarity between the two users.
     */
    private double getCosineSimilarity(int user1, int user2) {
        double numerator = 0;
        double user1SquareSum = 0;
        double user2SquareSum = 0;

        for (int i = 0; i < this.ratingMatrix[user1].length; i++) {
            numerator += this.ratingMatrix[user1][i] * this.ratingMatrix[user2][i];

            user1SquareSum += this.ratingMatrix[user1][i] * this.ratingMatrix[user1][i];
            user2SquareSum += this.ratingMatrix[user2][i] * this.ratingMatrix[user2][i];
        }

        return numerator / ( Math.sqrt(user1SquareSum) * Math.sqrt(user2SquareSum));
    }

    /**
     * Calculate the Cosine Similarity between all users and return the results as a matrix
     * @return Return a matrix with all similarities.
     */
    private double[][] getSimilarityMatrix() {
        double[][] similarityMatrix = new double[this.ratingMatrix.length][this.ratingMatrix.length];

        for (int userIndex = 0; userIndex < this.ratingMatrix.length; userIndex++) {
            for (int comparisonIndex = 0; comparisonIndex < this.ratingMatrix.length; comparisonIndex++) {
                if (comparisonIndex != userIndex) {
                    similarityMatrix[userIndex][comparisonIndex] = Math.round(this.getCosineSimilarity(userIndex, comparisonIndex) * 10000) / 10000.0;
                }
                else {
                    similarityMatrix[userIndex][comparisonIndex] = 0;
                }
            }
        }

        return similarityMatrix;
    }


    /**
     * Use the worked example from "Making recommendations" to verify functionality.
     */
    private static void WorkedExample() {
        int[][] ratingMatrix = {
            {1, 3, 2, 4},
            {2, 2, 3, 3}
        };

        CollaborativeFiltering filter = new CollaborativeFiltering(ratingMatrix);
        System.out.println("Cosine Similarity: " + filter.getCosineSimilarity(1-1, 2-1));
    }

    /**
     * Compute the results required for Acivity 10.
     * @param args No command line arguments are used.
     */
    public static void main(String[] args) {
        //WorkedExample();
        
        int[][] ratingMatrix = {
            {2, 3, 2, 2, 1},
            {2, 3, 1, 2, 2},
            {4, 3, 4, 4, 1},
            {3, 2, 4, 1, 1}            
        };

        CollaborativeFiltering filter = new CollaborativeFiltering(ratingMatrix);
        
        System.out.println("--- Question 1 ---");
        System.out.println(filter.getCosineSimilarity(1-1, 4-1));

        System.out.println("--- Question 2 ---");
        System.out.println(filter.getCosineSimilarity(3-1, 4-1));

        System.out.println("--- Question 3 ---");
        double[][] similarityMatrix = filter.getSimilarityMatrix();
        for (double[] row : similarityMatrix) {
            System.out.println(Arrays.toString(row));
        }
    }
}

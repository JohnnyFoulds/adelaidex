package section02.activity01;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

/**
 * GraphMatrix --- Implement the 34 x 34 matrix.
 */

public class GraphMatrix {
    int[][] matrix;

    /**
     * Initialize a new instance of the class.
     * @param path The path to the data file to load.
     */
    public GraphMatrix(String path) {
        super();
        this.loadData(path);
    }

    /**
     * Load the data into the 34 x 34 matrix
     * @param path
     */
    public void loadData(String path) {
        // create the matrix with one item more to allow for 1 indexing used in the question
        this.matrix = new int[35][35];

       // read the input data file and build the matrix
       File f = new File(path);
       try {
           Scanner sc = new Scanner(f);

           // discard the first line
           sc.nextLine();

           while( sc.hasNextLine() ) {
               String line = sc.nextLine();
               String[] tokens = line.split("\\s");

               // get the edge from the tokens
               int node1 = Integer.parseInt(tokens[1]);
               int node2 = Integer.parseInt(tokens[2]);

               // set the edge in the matrix
               this.matrix[node1][node2] = 1;
               this.matrix[node2][node1] = 1;
           }
       } catch (FileNotFoundException ex) {
           System.out.println("File "+f+" not found.");
       }        
    }

    /**
     * Count the number of edges for a row.
     * @param rowIndex Thew row index to count the edges for.
     * @return Return a the sum of each column in the row.
     */
    public int getNodeDegree(int node) {
        int total = 0;
        for (int i = 1; i <= 34; i++) {
            total += this.matrix[node][i];
        }

        return total;
    }

    /**
     * Show the matrix
     */
    public void printStructure() {
        // print the heading
        System.out.print("   ");
        for (int i = 1; i <= 34; i++) {
            System.out.print(String.format("%3s", i));
        }
        System.out.println();

        // print the rows
        for (int row = 1; row <= 34; row++) {
            System.out.print(String.format("%3s", row));

            for (int col = 1; col <= 34; col++) {
                System.out.print(String.format("%3s", this.matrix[row][col]));
            }

            System.out.println();
        }
    }

    /**
     * The main method for running the activity code.
     */
    public static void main(String[] args) {
        String dataPath = "section02/activity01/soc-karate.mis";
        GraphMatrix matrix = new GraphMatrix(dataPath);

        // print the matrix structure
        //matrix.printStructure();

        System.out.println("--- Question 6: In the soc-karate network what is the degree of node 1?");
        System.out.println(matrix.getNodeDegree(1));

        System.out.println("--- Question 7: In the soc-karate network what is the degree of node 32?");
        System.out.println(matrix.getNodeDegree(32));

        System.out.println(matrix.getNodeDegree(16));
        System.out.println("node 8: " + matrix.getNodeDegree(8));
        System.out.println("node 20: " + matrix.getNodeDegree(20));
    }    
}

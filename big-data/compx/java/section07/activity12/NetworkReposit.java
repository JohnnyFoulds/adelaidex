package section07.activity12;

import java.util.ArrayList;
import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class NetworkReposit {
    public static void main(String[] args) {
        // create a graph object to hold the data
        Graph networkGraph = new Graph();

        // initialize the nodes in the graph
        for (int i = 1; i <= 1299; i++) {
            networkGraph.addNode(String.valueOf(i));
        }

        // read the input data file and build the graph
        File f = new File("section07/activity12/web-google.mtx");
        int lineCounter = 0;
        try {
            Scanner sc = new Scanner(f);
            while( sc.hasNextLine() ) {
                String line = sc.nextLine();
                String[] tokens = line.split("\\s");
                lineCounter++;

                // the first two lines in the file can be ignored
                if (lineCounter > 2) {
                    // add the edges to the graph
                    networkGraph.addEdge(tokens[0], tokens[1]);
                    //System.out.println(tokens[0] + " - " + tokens[1]);
                }
            }
        } catch (FileNotFoundException ex) {
            System.out.println("File "+f+" not found.");
        }

        // show the edges of node 333
        Node testNode = networkGraph.getNode("1");
        ArrayList<Node> edges = networkGraph.edges.edges.get(testNode.name);
        System.out.println("Node 333 Edges: "  + edges.toString());

        // 1. Is there an edge between nodes 333 and 202
        System.out.println("Is there an edge between nodes 333 and 202: " +
            networkGraph.hasEdge("333", "202"));

    }
}

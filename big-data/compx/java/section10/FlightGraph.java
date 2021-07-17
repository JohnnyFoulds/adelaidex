package section10;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.UUID;

/**
 * Graph --- This class inplement a graph structure with child nodes.
 */
class Graph {
    protected Map<String, Node> nodes;
    protected Edges edges;

    /**
     * Create a default instance of the class.
     */
    public Graph() {
        this.nodes = new TreeMap<String, Node>();
        this.edges = new Edges();
    }

    /**
     * Add a node to the graph network.
     * @param name The name of the node.
     */
    public void addNode(String name) {
        // create the new node and add it to the nodes collection
        Node node = new Node(name);
        this.nodes.put(name, node);
    }

    /**
     * Remove the node with a given name from the graph network.
     * @param name The name of the node to remove.
     */
    public void removeNode(String name) {
        // validate that the node exist
        if (!this.nodes.containsKey(name)) throw new IndexOutOfBoundsException("The node '" + name + "' does not exist.");
        Node node = this.nodes.get(name);

        // remove the node from the edges
        this.edges.removeNode(node);

        // remove the node
        this.nodes.remove(name);
    }

    /**
     * Returns the Node object with a given name from the graph network if it exists. Returns null otherwise.
     * @param name The name of the node tp get.
     * @return The node if it exists, null otherwise.
     */
    public Node getNode(String name) {
        // validate that the node exist
        if (!this.nodes.containsKey(name)) return null;

        return this.nodes.get(name);
    }

    /**
     * Connect two nodes with given names together if they exist.
     * @param node1 The first node to create the edge for.
     * @param node2 The node to connect the fist to.
     */
    public void addEdge(String node1, String node2) {
        // validate that the nodes exist
        if (!this.nodes.containsKey(node1)) throw new IndexOutOfBoundsException("The node '" + node1 + "' does not exist.");
        if (!this.nodes.containsKey(node2)) throw new IndexOutOfBoundsException("The node '" + node2 + "' does not exist.");

        // add the edge
        this.edges.addEdge(this.nodes.get(node1), this.nodes.get(node2));
    }

    /**
     * Determine if an edge exists between two nodes.
     * @param node1 The first node to check for an edge.
     * @param node2 The second node to check for the existence of an edge.
     * @return Returns a boolean value; true if there is an edge from node1 to node2, false otherwise
     */
    public boolean hasEdge(String node1, String node2) {
        // validate that the nodes exist
        if (!this.nodes.containsKey(node1)) return false;
        if (!this.nodes.containsKey(node2)) return false;

        // determine if an edge exist for the nodes
        return this.edges.hasEdge(this.nodes.get(node1), this.nodes.get(node2));
    }

    /**
     * Remove the edge between the given nodes if one exists.
     * @param node1 The first node to remove the edge from.
     * @param node2 The second node of the edge.
     */
    public void removeEdge(String node1, String node2) {
        if (this.hasEdge(node1, node2)) {
            this.edges.removeEdge(this.nodes.get(node1), this.nodes.get(node2));
        }
    }

    /**
     * Get a klist of connected nodes for the specifided note.
     * @param node The node to get the list for.
     * @return Returns a list of child nodes.
     */
    public ArrayList<Node> getChildNodes(String node) {
        return this.edges.edges.get(node);
    }

    /**
     * Display a node and it's edged.
     * @param node The node to display the edges for.
     */
    public void printStructure(String node) {
        ArrayList<Node> childNodes = this.getChildNodes(node);

        System.out.print(node);
        // print the connections
        for (Node chidlNode : childNodes) {
            System.out.print("-" + chidlNode.name);
        }

        // print the newline
        System.out.println();
    }

    /**
     * Display all of the nodes and all of the edges between nodes.
     */
    public void printStructure() {
        for ( Map.Entry<String, Node> nodeEntry : this.nodes.entrySet() ) {
            Node node = nodeEntry.getValue();
            System.out.println(node.toString());
        }

        // print the edges
        this.edges.printStructure();
    }
}
 
/**
 * Node --- This class is used to store node information used in the Graph class.
 */
class Node {
    public String _id;
    public String name;

    /**
     * Create a default instance of the class.
     */
    public Node() {
        // assign a unique id to the node
        this._id = UUID.randomUUID().toString();
        this.name = null;
    }

    /**
     * Create a new instance of a now with a specific name.
     * @param name
     */
    public Node(String name) {
        this();
        this.name = name;
    }

    /**
     * Display the node structure.
     */
    public String toString() {
        return this.name;
    }    
}

/**
 * Edges -- This class represents edges in a graph network.
 */
class Edges {
    protected Map<String, ArrayList<Node>> edges;

    /**
     * Create a default instance of the Edges class.
     */
    public Edges() {
        this.edges = new TreeMap<String, ArrayList<Node>>();
    }

    /**
     * Add the edge between node11 and node2.
     * @param node1 This node to add the edge for.
     * @param node2 The node to connect to.
     */
    public void addEdge(Node node1, Node node2) {
        // add an entry for node1 if it does not already exist.
        if (!this.edges.containsKey(node1.name)) {
            this.edges.put(node1.name, new ArrayList<Node>());
        }

        // add node2 to the connections of node1
        this.edges.get(node1.name).add(node2);
    }

    /**
     * Remove a node and all its edged.
     * @param name The the node to remove.
     */
    public void removeNode(Node node) {
        // remove the node entry
        this.edges.remove(node.name);

        // remove connections in the other nodes
        for ( Map.Entry<String, ArrayList<Node>> edgeEntry : this.edges.entrySet() ) {
            ArrayList<Node> connections = edgeEntry.getValue();
            if (connections.contains(node)) {
                connections.remove(node);
            }
        }
    }

    /**
     * Determine if an edge exists between two nodes.
     * @param node1 The first node to check for an edge.
     * @param node2 The second node to check for the existence of an edge.
     * @return Returns a boolean value; true if there is an edge from node1 to node2, false otherwise
     */
    public boolean hasEdge(Node node1, Node node2) {
        // if no edges exist for node 1, then there is no edges
        if (!this.edges.containsKey(node1.name)) {
            return false;
        } else {
            ArrayList<Node> connections = this.edges.get(node1.name);
            return connections.contains(node2);
        }
    }

    /**
     * Remove the edge between the given nodes if one exists.
     * @param node1 The first node to remove the edge from.
     * @param node2 The second node of the edge.
     */
    public void removeEdge(Node node1, Node node2) {
        if (this.edges.containsKey(node1.name)) {
            ArrayList<Node> connections = this.edges.get(node1.name);
            if (connections.contains(node2)) {
                connections.remove(node2);
            }
        }
    }

    /**
     * Display the edge connections between nodes.
     */
    public void printStructure() {
        for ( Map.Entry<String, ArrayList<Node>> edgeEntry : this.edges.entrySet() ) {
            String nodeName = edgeEntry.getKey();
            ArrayList<Node> connections = edgeEntry.getValue();

            System.out.print(nodeName.toString());

            // print the connections
            for (Node node : connections) {
                System.out.print("-" + node.name);
            }

            // print the newline
            System.out.println();
        }
    }
}

/**
 * FlightGraph --- Inherits from the Graph class to represents the fligts dataset.
 */
public class FlightGraph extends Graph {
    protected Flights flights;

    /**
     * Initialize a new instance of the class.
     */
    public FlightGraph() {
        super();

        String sourcePath = "section10/Flights.csv";
        this.flights = new Flights(sourcePath);
    }

    /**
     * Get a node from the graph, if it does not exist, create it.
     * @param name The name of the node.
     * @return Return the graph node.
     */
    public Node getNodeWithCreate(String name) {
        // create the node if required
        if (!this.nodes.containsKey(name)) {
            this.addNode(name);
        }

        // return the node
        return this.getNode(name);
    }

    /**
     * Construct a cyclical graph from the flights dataset.
     */
    public void constructUndirectedGraph() {
        for (int i = 0; i < this.flights.getRowCount(); i++) {
            // get the row and values
            TableRow row = this.flights.getRow(i);
            String origin = row.getString("origin");
            String dest = row.getString("dest");

            // get the nodes to make sure they exist
            this.getNodeWithCreate(origin);
            this.getNodeWithCreate(dest);

            // add the edges
            if (!this.hasEdge(origin, dest)) this.addEdge(origin, dest);
            if (!this.hasEdge(dest, origin)) this.addEdge(dest, origin);
        }
    }

    /**
     * Get the child nodes names of a node.
     * @param name The name of the node to get the names for.
     * @return Return a list of child node names.
     */
    ArrayList<String> getChildNodeNames(String name) {
        ArrayList<String> childNames = new ArrayList<String>();
        ArrayList<Node> childNodes = this.getChildNodes(name);

        for (Node node : childNodes) {
            childNames.add(node.name);
        }

        return childNames;
    }

     /**
      * Recursively get a list of unique nodes for the nodes in the parent list.
      * @param parents The partents to return nodes for.
      * @param level The debt to search to. When 0 simply return the unique values from the partent list.
      * @return The list of unique nodes.
      */
    public HashSet<String> getUniqueChildren(HashSet<String> parents, int level) {
        if (level == 0) {
            return parents;
        }
        else {
            level--;
            HashSet<String> childSet = new HashSet<String>();

            // get the set of children for the parent nodes
            for (String parent : parents) {
                childSet.addAll(this.getChildNodeNames(parent));
            }

            return this.getUniqueChildren(childSet, level);
        }
    }

    /**
     * The main function to test the functionality.
     * @param args The command line arguments.
     */
    public static void main(String[] args) {
        FlightGraph graph = new FlightGraph();
        graph.constructUndirectedGraph();

        graph.printStructure("EWR");
        System.out.println(graph.getChildNodes("EWR").size());
        System.out.println();

        HashSet<String> ewrList = new HashSet<String>();
        ewrList.add("EWR");
        System.out.println(graph.getUniqueChildren(ewrList, 1));
        System.out.println(graph.getUniqueChildren(ewrList, 1).size());

        System.out.println("--- Two Flights:");
        System.out.println(graph.getUniqueChildren(ewrList, 2));
        System.out.println(graph.getUniqueChildren(ewrList, 2).size());

        System.out.println("--- Three Flights:");
        System.out.println(graph.getUniqueChildren(ewrList, 3));
        System.out.println(graph.getUniqueChildren(ewrList, 3).size());
    }
}

import numpy as np
import igraph as gp

class PageRank:
    """
    Implement the PageRank algorithm using matrix manipulation.
    """
    def __init__(self, edges):
        """
        Create a dafault instance of the class.

        Args:
            edges: The edges to create the page graph from.
        """
        self.graph = self.createGraph(edges)

    def createGraph(self, edges):
        """
        Construct a graph from the page edges.

        Args:
            edges: The edges to create the page graph from.

        Returns:
            The graph created from the input edges.
        """
        return gp.Graph.TupleList(edges, directed=True)


    def plotGraph(self, width=300, height=300, margin=15, layout='auto', edge_curved=True):
        """
        Plot the page graph.
        """
        return gp.plot(self.graph, 
            vertex_label=self.graph.vs["name"], 
            layout=layout, 
            margin=margin, 
            bbox=(0, 0, width, height), 
            edge_curved=edge_curved)

    def get_transitionmatrix(self):
        """
        Get the transation matrix of the graph.

        Returns:
            A numpy array containing the transition matrix.
        """
        # initialize the transition matrix with zeros
        node_count = len(self.graph.vs)
        transition_matrix = np.zeros([node_count, node_count])

        # get the in and out adjacency list
        out_adj = self.graph.get_adjlist(mode='out')
        in_adj = self.graph.get_adjlist(mode='in')

        # calculate the transition matrix
        for i in range(node_count):
            for j in range(node_count):
                # if there is no link from j to i, then mij equals zero
                if i not in out_adj[j]:
                    transition_matrix[i][j] = 0
                else: # mij equals 1/k, if there's a link from page j to i. k is the total number of outgoing links from j
                    transition_matrix[i][j] = 1.0 /  len(out_adj[j])


        return transition_matrix

    def get_initial_vector(self):
        """
        Get the initial pagerank vector v0.
        """
        node_count = len(self.graph.vs)

        vector = np.empty(node_count)
        vector.fill(1/node_count)

        return vector

    def get_distribution(self, n):
        """
        Get the distribution after n steps.
        """
        M = self.get_transitionmatrix()
        v = self.get_initial_vector()

        for i in range(n):
            v = np.matmul(M, v)

        return v
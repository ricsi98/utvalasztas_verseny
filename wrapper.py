import ctypes

# Load the C library
lib = ctypes.CDLL("./longest_path_dag.so")


# Define required C types
class Edge(ctypes.Structure):
    _fields_ = [("source", ctypes.c_int), ("destination", ctypes.c_int)]


class Graph(ctypes.Structure):
    _fields_ = [("V", ctypes.c_int), ("E", ctypes.c_int), ("edge", ctypes.POINTER(Edge))]


GraphPtr = ctypes.POINTER(Graph)

# Define functions
lib.createGraph.restype = GraphPtr
lib.createGraph.argtypes = [ctypes.c_int, ctypes.c_int]
lib.computeLongestPath.argtypes = [GraphPtr]
lib.computeLongestPath.restype = ctypes.c_int
lib.freeGraph.argtypes = [GraphPtr]


# Python wrapper functions
def compute_longest_path(graph):
    return lib.computeLongestPath(graph)


def create_graph(V, E, edges):
    graph = lib.createGraph(V, E)
    edge_array = (Edge * E)(*edges)
    graph.contents.edge = ctypes.cast(edge_array, ctypes.POINTER(Edge))
    return graph


def free_graph(graph):
    print("FEE")
    lib.freeGraph(graph)


# Example usage
if __name__ == "__main__":
    # Example graph
    edges = [(0, 1), (0, 2), (1, 3), (1, 4), (2, 4), (3, 5), (4, 5)]
    V = 6
    E = len(edges)

    graph = create_graph(V, E, edges)
    longest_path = compute_longest_path(graph)
    print("Longest Path Length22:", longest_path)
    free_graph(graph)

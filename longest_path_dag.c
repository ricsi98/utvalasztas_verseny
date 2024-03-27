#include <stdio.h>
#include <stdlib.h>

#define MAX_NODES 1000

int max(int a, int b) {
    return (a > b) ? a : b;
}

// Structure to represent a directed edge in the graph
struct Edge {
    int source, destination;
};

// Structure to represent a graph
struct Graph {
    int V, E;
    struct Edge* edge;
};

// Function to create a new graph
struct Graph* createGraph(int V, int E) {
    struct Graph* graph = (struct Graph*)malloc(sizeof(struct Graph));
    graph->V = V;
    graph->E = E;
    graph->edge = (struct Edge*)malloc(E * sizeof(struct Edge));
    return graph;
}

// Function to find the longest path from a given source vertex
int longestPath(struct Graph* graph, int source, int* dp) {
    if (dp[source] != -1) // If already calculated
        return dp[source];

    int maxLength = 0;

    for (int i = 0; i < graph->E; i++) {
        if (graph->edge[i].source == source) {
            int temp = longestPath(graph, graph->edge[i].destination, dp);
            maxLength = max(maxLength, temp + 1);
        }
    }

    dp[source] = maxLength;
    return maxLength;
}

// Function to compute the longest path in a DAG
int computeLongestPath(struct Graph* graph) {
    int* dp = (int*)malloc(graph->V * sizeof(int));
    for (int i = 0; i < graph->V; i++)
        dp[i] = -1;

    int maxPathLength = 0;

    for (int i = 0; i < graph->V; i++) {
        if (dp[i] == -1)
            longestPath(graph, i, dp);
        maxPathLength = max(maxPathLength, dp[i]);
    }

    free(dp);
    return maxPathLength;
}

// Function to free dynamically allocated memory for the graph
void freeGraph(struct Graph* graph) {
    free(graph->edge);
    free(graph);
}

int main() {
    // Example graph
    int V = 6;
    int E = 7;  // Number of edges
    struct Edge edges[] = {
        {0, 1}, {0, 2}, {1, 3}, {1, 4}, {2, 4}, {3, 5}, {4, 5}
    };

    // Create graph
    struct Graph* graph = createGraph(V, E);
    for (int i = 0; i < E; i++) {
        graph->edge[i] = edges[i];
    }

    // Compute longest path
    int longestPathLength = computeLongestPath(graph);
    printf("Longest Path Length: %d\n", longestPathLength);

    // Free graph memory
    freeGraph(graph);

    return 0;
}

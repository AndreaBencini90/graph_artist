# Step 1: Caricamento del file RData
cat("Step 1: Loading the RData file...\n")
load("C:/Users/048115571/Documents/GraphArte/Graph tesi/tesi_gottard/applicazione/GRAVIER.RData") # nolint
cat("RData file loaded successfully.\n")

# Step 2: Accesso ai dati del dataset 'gravier'
cat("Step 2: Extracting 'x' and 'y' from the 'gravier' dataset...\n")
X <- gravier$x  # Gene expression data
y <- gravier$y  # Class labels
cat(sprintf("Shape of X: %d samples, %d features\n", nrow(X), ncol(X)))
cat(sprintf("Length of y: %d\n", length(y)))

# Step 3: Applicazione dei ranghi sui dati
cat("Step 3: Ranking the data...\n")
X_ranked <- apply(X, 2, rank)  # Applicazione della funzione rank su ogni colonna
X_df <- as.data.frame(X_ranked)  # Conversione in data frame
cat("Data ranking completed.\n")

# Step 4: Applicazione del PC Algorithm
library(pcalg)
library(graph)
cat("Step 4: Applying the PC Algorithm...\n")
# Definire i parametri del PC Algorithm
suffStat <- list(C = cor(X_df), n = nrow(X_df))  # Statistiche sufficienti
pc.fit <- pc(suffStat, indepTest = gaussCItest, p = ncol(X_df), alpha = 0.05)
cat("PC Algorithm executed successfully.\n")

# Step 5: Conversione del grafo in formato adjacency matrix
cat("Step 5: Converting the output to an adjacency matrix...\n")
adjacency_matrix <- as(pc.fit@graph, "matrix")
cat(sprintf("Adjacency matrix shape: %d x %d\n", nrow(adjacency_matrix), ncol(adjacency_matrix)))

# Step 6: Creazione del grafo non orientato in formato GraphML
cat("Step 6: Creating an undirected graph and saving in GraphML format...\n")
library(igraph)
graph_igraph <- graph_from_adjacency_matrix(adjacency_matrix, mode = "undirected")
write_graph(graph_igraph, file = "PC_AlgorithmrRANK.graphml", format = "graphml")
cat("Graph saved successfully as 'PC_AlgorithmrRANK.graphml'.\n")
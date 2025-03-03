# Caricamento librerie
library(jsonlite)
library(bnlearn)
library(igraph)

# Step 1: Caricamento del file RData
cat("Step 1: Loading the RData file...\n")
load("alon.RData")  # nolint
cat("RData file loaded successfully.\n")

# Step 2: Accesso ai dati del dataset 'alon'
cat("Step 2: Extracting 'x' and 'y' from the 'alon' dataset...\n")
X <- alon$x  # Gene expression data
y <- alon$y  # Class labels
cat(sprintf("Shape of X: %d samples, %d features\n", nrow(X), ncol(X)))
cat(sprintf("Length of y: %d\n", length(y)))

# Step 3: Caricamento delle variabili dal file JSON
cat("Step 3: Loading selected variables from JSON...\n")
json_file <- "top_500_features_importance.json"  # JSON generato in Python
selected_features <- names(fromJSON(json_file))  # Estrarre i nomi delle variabili
cat(sprintf("Number of selected features: %d\n", length(selected_features)))

# Step 4: Filtraggio delle variabili in X
cat("Step 4: Filtering variables in X...\n")
# Funzione per trasformazione in ranghi
rank_transform <- function(x) rank(x, ties.method = "average")
X <- apply(X, 2, rank_transform)
X_filtered <- X[, selected_features, drop = FALSE]  # Tenere solo le variabili selezionate
cat(sprintf("Filtered X: %d samples, %d features\n", nrow(X_filtered), ncol(X_filtered)))

# Step 5: Applicazione del GS Algorithm
cat("Step 5: Applying the Grow-Shrink Algorithm...\n")
gs.fit <- gs(as.data.frame(X_filtered),undirected = TRUE)  # Applicazione del GS Algorithm
cat("GS Algorithm executed successfully.\n")

# Step 6: Conversione del grafo in formato adjacency matrix
cat("Step 6: Converting the output to an adjacency matrix...\n")
adjacency_matrix <- amat(gs.fit)  # Estrazione della matrice di adiacenza
cat(sprintf("Adjacency matrix shape: %d x %d\n", nrow(adjacency_matrix), ncol(adjacency_matrix)))

# Step 7: Creazione del grafo non orientato in formato GraphML
cat("Step 7: Creating an undirected graph and saving in GraphML format...\n")
graph_igraph <- graph_from_adjacency_matrix(adjacency_matrix, mode = "undirected")  # Grafo non orientato
write_graph(graph_igraph, file = "GS_Algorithm_alon_filtered.graphml", format = "graphml")
cat("Graph saved successfully as 'GS_Algorithm_alon_filtered.graphml'.\n")

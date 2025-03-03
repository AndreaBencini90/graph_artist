import pandas as pd
import json
from xgboost import XGBClassifier
# feature to select
feature_number=500
# Leggere i dati
X = pd.read_csv("alon_x.csv")
y = pd.read_csv("alon_y.csv").squeeze()  # Convertire in Serie se necessario

# Conversione di y in numerico (ad esempio 0 e 1)
y = y.astype("category").cat.codes  # Converte i valori unici in codici numerici

# Verifica e conversione dei dati
X = X.select_dtypes(include=["number"])  # Tieni solo colonne numeriche

# Creare e allenare il modello XGBoost per classificazione
model = XGBClassifier(objective='binary:logistic', n_estimators=10000, random_state=42)
model.fit(X, y)

# Estrarre l'importanza delle caratteristiche
importance = model.feature_importances_
features_importance = {feature: float(score) for feature, score in zip(X.columns, importance)}

# Ordinare le caratteristiche per importanza
sorted_features_importance = dict(sorted(features_importance.items(), key=lambda item: item[1], reverse=True))

# Prendere solo le prime 500 caratteristiche più importanti
top_500_features = dict(list(sorted_features_importance.items())[:feature_number])

# Salvare i risultati in un file JSON
output_file = "top_500_features_importance.json"
with open(output_file, "w") as f:
    json.dump(top_500_features, f, indent=4)

print(f"Le prime 500 variabili più importanti sono salvate nel file '{output_file}'.")

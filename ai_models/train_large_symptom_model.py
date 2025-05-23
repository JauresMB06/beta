import pandas as pd
from sklearn.preprocessing import MultiLabelBinarizer
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
import joblib

# Load your large symptom-disease dataset
df = pd.read_csv("ai_models/large_symptom_disease_dataset.csv")

# Parsing symptoms into lists
df['symptoms'] = df['symptoms'].apply(lambda x: [s.strip().lower() for s in x.split("|")])

# Multi-hot encode symptoms
mlb = MultiLabelBinarizer()
X = mlb.fit_transform(df['symptoms'])
y = df['disease']

# Train-test split (optional for evaluation)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train model
model = RandomForestClassifier(n_estimators=200, random_state=42)
model.fit(X_train, y_train)

# Save model & encoder for API use
joblib.dump(model, "ai_models/large_symptom_rf_model.pkl")
joblib.dump(mlb, "ai_models/large_symptom_encoder.pkl")
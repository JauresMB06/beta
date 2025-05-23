import pandas as pd
from sklearn.preprocessing import MultiLabelBinarizer
from sklearn.ensemble import RandomForestClassifier
import joblib

# Load data
df = pd.read_csv("ai_models/symptom_disease_dataset.csv")
df['symptoms'] = df['symptoms'].apply(lambda x: [s.strip().lower() for s in x.split(",")])

mlb = MultiLabelBinarizer()
X = mlb.fit_transform(df['symptoms'])
y = df['disease']

# Train model
model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X, y)

# Save model & encoder
joblib.dump(model, "ai_models/symptom_rf_model.pkl")
joblib.dump(mlb, "ai_models/symptom_encoder.pkl")
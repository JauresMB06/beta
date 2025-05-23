import pandas as pd
from sklearn.preprocessing import MultiLabelBinarizer, LabelEncoder, OneHotEncoder
from sklearn.ensemble import RandomForestClassifier
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
import joblib

# Load extended dataset
df = pd.read_csv("ai_models/extended_symptom_disease_dataset.csv")
df['symptoms'] = df['symptoms'].apply(lambda x: [s.strip().lower() for s in x.split("|")])
df['history'] = df['history'].fillna("").apply(lambda x: [h.strip().lower() for h in x.split(",") if h.strip()])

# Prepare encoders
symptom_mlb = MultiLabelBinarizer()
history_mlb = MultiLabelBinarizer()
gender_le = LabelEncoder()

# Encode each column
X_symptoms = symptom_mlb.fit_transform(df['symptoms'])
X_history = history_mlb.fit_transform(df['history'])
X_gender = gender_le.fit_transform(df['gender'])
X_age = df['age'].values.reshape(-1, 1)

# Combine all features
import numpy as np
X = np.hstack([X_symptoms, X_history, X_gender.reshape(-1,1), X_age])
y = df['disease']

# Train model
model = RandomForestClassifier(n_estimators=200, random_state=42)
model.fit(X, y)

# Save model and encoders
joblib.dump(model, "ai_models/extended_symptom_rf_model.pkl")
joblib.dump(symptom_mlb, "ai_models/extended_symptom_encoder.pkl")
joblib.dump(history_mlb, "ai_models/extended_history_encoder.pkl")
joblib.dump(gender_le, "ai_models/gender_encoder.pkl")
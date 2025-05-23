import joblib
import numpy as np
from .disease_risk_dict import DISEASE_RISK

# Make sure these files exist and are trained
model = joblib.load("ai_models/extended_symptom_rf_model.pkl")
symptom_mlb = joblib.load("ai_models/extended_symptom_encoder.pkl")
history_mlb = joblib.load("ai_models/extended_history_encoder.pkl")
gender_le = joblib.load("ai_models/gender_encoder.pkl")

def predict_disease(symptoms, age, gender, history, records_context: str = ""):
    symptoms = [s.strip().lower() for s in symptoms]
    history = [h.strip().lower() for h in history]
    if records_context:
        history.append(records_context.lower())
    X_symptoms = symptom_mlb.transform([symptoms])
    X_history = history_mlb.transform([history])
    X_gender = gender_le.transform([gender.lower()])[0]
    X_age = np.array([[age]])

    X = np.hstack([X_symptoms, X_history, [[X_gender]], X_age])
    probs = model.predict_proba(X)[0]
    classes = model.classes_
    top_idx = np.argsort(probs)[::-1][:5]
    results = []
    for i in top_idx:
        if probs[i] > 0:
            disease = str(classes[i])
            risk_info = DISEASE_RISK.get(disease, {"risk": "unknown", "advice": "No advice available."})
            results.append({
                "disease": disease,
                "probability": float(probs[i]),
                "risk": risk_info["risk"],
                "advice": risk_info["advice"]
            })
    return results
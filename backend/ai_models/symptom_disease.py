SYMPTOM_DISEASE_MAP = {
    "fever": ["Flu", "Malaria", "COVID-19"],
    "cough": ["Flu", "COVID-19", "Bronchitis"],
    "chest pain": ["Heart Attack", "Angina", "Anxiety"],
    "headache": ["Migraine", "Flu", "Malaria", "COVID-19"],
    "shortness of breath": ["Asthma", "COVID-19", "Heart Failure"]
}

DISEASE_RISK = {
    "Flu": "low",
    "Malaria": "high",
    "COVID-19": "high",
    "Bronchitis": "medium",
    "Heart Attack": "critical",
    "Angina": "high",
    "Anxiety": "low",
    "Migraine": "medium",
    "Asthma": "high",
    "Heart Failure": "critical",
}

def get_possible_diseases(symptoms):
    diseases = set()
    found_symptoms = []
    for symptom in symptoms:
        for key in SYMPTOM_DISEASE_MAP:
            if key in symptom.lower():
                found_symptoms.append(key)
                diseases.update(SYMPTOM_DISEASE_MAP[key])
    return list(diseases), found_symptoms

def get_highest_risk(diseases):
    risk_rank = {"low": 1, "medium": 2, "high": 3, "critical": 4}
    highest = "low"
    for d in diseases:
        risk = DISEASE_RISK.get(d, "low")
        if risk_rank[risk] > risk_rank[highest]:
            highest = risk
    return highest
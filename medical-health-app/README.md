# Medical Health App

A cross-platform mobile application for securely storing, managing, and sharing medical records. Features an AI chatbot for symptom checking, risk evaluation, and personalized medical guidance. Doctors can access patient histories from any hospital, and the system suggests nearby hospitals based on patient needs.

## Tech Stack

- **Mobile:** Flutter
- **Backend:** FastAPI (Python)
- **AI:** Python (scikit-learn, transformers, or similar)
- **Database:** PostgreSQL (recommended), or SQLite for dev

## Directory Structure

```
/medical-health-app
  /mobile      # Flutter mobile app
  /backend     # FastAPI backend
  /ai_models   # AI logic, ML models, symptom checker
```

## Quick Start

### 1. Mobile App

```bash
cd mobile
flutter pub get
flutter run
```

### 2. Backend API

```bash
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload
```

### 3. AI Models

- Placeholder for now. Models will be served via API endpoints in `/backend/ai/`.

---

## Features

- Secure medical record storage & sharing
- Patient & Doctor roles
- AI-powered chatbot for symptom/disease prediction and risk analysis
- Deep Checker: advanced analysis based on patient’s history
- Hospital locator
# Medical AI App — Backend + Flutter Mobile

## Features
- AI-powered disease prediction and risk assessment
- Doctor dashboard to view patient lists, medical records, and chatbot history
- Deep Checker: automatic context from patient medical records
- Chat logging for quality and audit
- Medication/treatment advice for low-risk diseases
- Hospital locator (Cameroon)
- Flutter mobile app (doctor & patient flows)
- SQLite by default, easily swappable

## Running Locally

### Backend (FastAPI)
```bash
cd backend
pip install -r requirements.txt
uvicorn main:app --reload
```
Visit [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs) for API docs.

### Mobile (Flutter)
```bash
cd mobile
flutter pub get
flutter run
```
- Use `10.0.2.2` for backend API on Android emulator.
- For real device, set backend URL to your computer’s IP.

### Preview on GitHub
If you have Codespaces enabled:
- Click "Code" > "Open with Codespaces"
- Run backend and Flutter web as above

## Disclaimer
This project is for educational purposes only and does not replace professional medical advice.
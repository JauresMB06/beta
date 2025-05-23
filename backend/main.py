from fastapi import FastAPI, Depends, HTTPException, Body, UploadFile, File, Form
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from fastapi.middleware.cors import CORSMiddleware
from .database import SessionLocal, engine, Base
from .models import User, MedicalRecord, ChatLog
from .ai_models.symptom_predictor import predict_disease
from .auth import (
    get_current_user, get_password_hash, verify_password, create_access_token, get_db
)
import shutil
import os
from datetime import datetime

app = FastAPI()

# CORS for mobile/web local dev
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Change for production!
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

Base.metadata.create_all(bind=engine)

UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)

@app.post("/register")
def register(
    full_name: str = Form(...),
    email: str = Form(...),
    password: str = Form(...),
    is_doctor: bool = Form(False),
    db: Session = Depends(get_db)
):
    if db.query(User).filter(User.email == email).first():
        raise HTTPException(400, "Email already registered")
    user = User(
        full_name=full_name,
        email=email,
        hashed_password=get_password_hash(password),
        is_doctor=is_doctor
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return {"msg": "Registered successfully", "user_id": user.id}

@app.post("/token")
def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == form_data.username).first()
    if not user or not verify_password(form_data.password, user.hashed_password):
        raise HTTPException(401, "Incorrect email or password")
    token = create_access_token({"sub": str(user.id)})
    return {"access_token": token, "token_type": "bearer"}

@app.post("/upload-record/")
def upload_record(
    file: UploadFile = File(...),
    description: str = Form(""),
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    file_location = os.path.join(UPLOAD_DIR, file.filename)
    with open(file_location, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)
    record = MedicalRecord(
        user_id=user.id,
        filename=file.filename,
        upload_time=datetime.utcnow(),
        description=description
    )
    db.add(record)
    db.commit()
    db.refresh(record)
    return {"msg": "File uploaded successfully", "record_id": record.id}

@app.get("/patients")
def get_patients(user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    if not user.is_doctor:
        raise HTTPException(403, "Not allowed")
    patients = db.query(User).filter(User.is_doctor == False).all()
    return [{"id": p.id, "name": p.full_name, "email": p.email} for p in patients]

@app.get("/patient/{patient_id}/history")
def get_patient_history(patient_id: int, user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    if not user.is_doctor:
        raise HTTPException(403, "Not allowed")
    records = db.query(MedicalRecord).filter(MedicalRecord.user_id == patient_id).all()
    return [{"filename": r.filename, "uploaded": r.upload_time, "description": r.description} for r in records]

@app.get("/patient/{patient_id}/chatlogs")
def get_chatlogs(patient_id: int, user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    if not user.is_doctor:
        raise HTTPException(403, "Not allowed")
    logs = db.query(ChatLog).filter(ChatLog.user_id == patient_id).all()
    return [{"message": l.message, "response": l.response, "timestamp": l.created_at} for l in logs]

@app.post("/chatbot")
def chatbot_query(
    payload: dict = Body(...),
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    message = payload.get("message", "")
    age = int(payload.get("age", 30))
    gender = payload.get("gender", "other")
    history = [h.strip() for h in payload.get("history", "").split(",") if h.strip()]
    symptoms = [s.strip().lower() for s in message.split(",") if s.strip()]

    records = db.query(MedicalRecord).filter(MedicalRecord.user_id == user.id).order_by(MedicalRecord.upload_time.desc()).all()
    recent_records_text = " ".join([r.description for r in records[:5] if r.description])

    predictions = predict_disease(symptoms, age, gender, history, records_context=recent_records_text)
    if not predictions:
        response = "Sorry, no possible disease found for the provided symptoms."
    else:
        response = "Based on your symptoms and profile, possible diseases and risk:\n"
        for p in predictions:
            response += f"- {p['disease']} (probability: {p['probability']:.2f}, risk: {p['risk']})\n"
            if p["risk"] == "low":
                response += f"  Suggested treatment: {p['advice']}\n"
        if any(p["risk"] in ["high", "critical"] for p in predictions):
            response += "Your symptoms indicate a high risk. Please visit the nearest hospital."
        else:
            response += "Your symptoms do not indicate a high risk, but monitor your health and consult a doctor if needed."
        if recent_records_text:
            response += f"\n\nThe following recent medical records were considered in your assessment:\n{recent_records_text}"

    db.add(ChatLog(user_id=user.id, message=message, response=response))
    db.commit()
    return {"response": response}
from pydantic import BaseModel
from datetime import datetime

class MedicalRecordOut(BaseModel):
    id: int
    filename: str
    upload_time: datetime

    class Config:
        orm_mode = True
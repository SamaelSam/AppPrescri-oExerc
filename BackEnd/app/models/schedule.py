from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class Schedule(BaseModel):
    patient_id: str
    exercise_id: str
    date: datetime
    notes: Optional[str] = None

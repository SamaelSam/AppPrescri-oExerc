from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional

class Schedule(BaseModel):
    id: Optional[str] = Field(None, alias="_id")
    user_id: str
    exercise_id: str
    scheduled_time: datetime
    duration_minutes: int
    notes: Optional[str] = None

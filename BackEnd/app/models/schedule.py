from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional, List

class Schedule(BaseModel):
    id: Optional[str] = Field(None, alias="_id")
    user_id: str
    exercise_ids: List[str]
    scheduled_time: datetime
    duration_minutes: int
    notes: Optional[str] = None

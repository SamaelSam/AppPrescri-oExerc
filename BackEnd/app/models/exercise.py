# models.py
from pydantic import BaseModel
from typing import Optional

class Exercise(BaseModel):
    id: str  # ID enviado pelo frontend
    name: str
    description: Optional[str] = None
    videoUrl: Optional[str] = None
    difficulty: Optional[str] = None
    category: Optional[str] = None

from pydantic import BaseModel
from typing import Optional

class Exercise(BaseModel):
    id: Optional[str] = None  # Agora id é opcional
    name: str
    description: Optional[str] = None
    videoUrl: Optional[str] = None
    difficulty: Optional[str] = None
    category: Optional[str] = None

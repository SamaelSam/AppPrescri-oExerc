from pydantic import BaseModel
from typing import Optional

class Exercise(BaseModel):
    name: str
    description: Optional[str] = None
    category: Optional[str] = None
    difficulty: str = "medium"

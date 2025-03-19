from pydantic import BaseModel
from typing import Optional

class Exercise(BaseModel):
    name: str
    description: str
    category: str
    difficulty: Optional[str] = "medium"

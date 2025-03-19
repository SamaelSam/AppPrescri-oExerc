from pydantic import BaseModel, Field
from typing import Optional
from datetime import date

class Patient(BaseModel):
    name: str = Field(..., min_length=3, max_length=100)
    age: int = Field(..., gt=0, le=120)
    weight: float = Field(..., gt=0)
    height: float = Field(..., gt=0)
    medical_history: Optional[str] = None

    class Config:
        populate_by_name = True
        schema_extra = {
            "example": {
                "name": "João da Silva",
                "age": 30,
                "weight": 70.5,
                "height": 1.75,
                "medical_history": "Hipertensão e diabetes"
            }
        }

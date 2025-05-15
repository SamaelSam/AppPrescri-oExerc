from pydantic import BaseModel, Field, EmailStr, constr


class Patient(BaseModel):
    name: str = Field(..., example="João Silva")
    age: int = Field(..., ge=0, example=30)
    weight: float = Field(..., gt=0, example=70.5)  # kg
    height: float = Field(..., gt=0, example=1.75)  # metros
    medical_condition: str = Field(..., example="Hipertensão")
    email: EmailStr = Field(..., example="joao.silva@example.com")
    phone: constr(min_length=10, max_length=15) = Field(..., example="(11) 91234-5678")

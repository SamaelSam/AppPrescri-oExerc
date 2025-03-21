from pydantic import BaseModel, Field
class Patient(BaseModel):
    name: str
    age: int
    email: str



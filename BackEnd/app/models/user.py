from pydantic import BaseModel, EmailStr

class User(BaseModel):
    username: str
    hashed_password: str
    email: EmailStr


from pydantic import BaseModel, EmailStr
from enum import Enum

class Role(str, Enum):
    ADMIN = "admin"
    USER = "user"

class User(BaseModel):
    username: str
    email: EmailStr
    password: str
    role: Role = Role.USER

class UserDisplay(BaseModel):
    username: str
    email: EmailStr
    role: Role

from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from passlib.context import CryptContext

from app.utils.security import verify_password, create_access_token
from app.services.user_service import get_user_by_email
from app.database import create_user_in_db, get_collection
from app.services.auth_service import create_user
from app.models.user import User, UserDisplay, Role
from app.models.login_response import LoginResponse

auth_router = APIRouter()

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

class LoginRequest(BaseModel):
    email: str
    password: str

@auth_router.post("/register", response_model=UserDisplay)
async def register_user(user: User):
    collection = get_collection("fitness_app.users")
    
    existing = await collection.find_one({"email": user.email})
    if existing:
        raise HTTPException(status_code=400, detail="Email já registrado")
    
    hashed_password = pwd_context.hash(user.password)
    user_dict = user.dict()
    user_dict["password"] = hashed_password
    user_dict["role"] = Role.USER.value  # força role USER
    
    result = await collection.insert_one(user_dict)
    
    return UserDisplay(username=user.username, email=user.email, role=Role.USER.value)

@auth_router.post("/login", response_model=LoginResponse)
async def login(data: LoginRequest):
    user = await get_user_by_email(data.email)

    if not user or not verify_password(data.password, user["password"]):
        raise HTTPException(status_code=401, detail="Credenciais inválidas")

    token = create_access_token({"sub": user["email"], "role": user["role"]})

    user_display = UserDisplay(
        username=user["username"],
        email=user["email"],
        role=user["role"]
    )

    return {
        "access_token": token,
        "token_type": "bearer",
        "user": user_display
    }

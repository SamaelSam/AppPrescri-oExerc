from fastapi import APIRouter, HTTPException, Depends
from fastapi.security import OAuth2PasswordRequestForm
from app.services.auth_service import verify_password, create_access_token
from app.services.user_service import get_user_by_email  # vamos implementar isso
from datetime import timedelta

router = APIRouter()

@router.post("/login/")
async def login(form_data: OAuth2PasswordRequestForm = Depends()):
    user = await get_user_by_email(form_data.username)
    if not user or not verify_password(form_data.password, user["password"]):
        raise HTTPException(status_code=400, detail="Credenciais inválidas")
    
    token_data = {
        "sub": user["email"],
        "username": user["username"],
        "role": user["role"]
    }
    access_token = create_access_token(token_data, timedelta(minutes=30))
    return {"access_token": access_token, "token_type": "bearer"}

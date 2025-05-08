from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from app.utils.security import verify_password, create_access_token
from app.services.user_service import get_user_by_email
from app.database import create_user_in_db
from app.services.auth_service import create_user

auth_router = APIRouter()

class LoginRequest(BaseModel):
    email: str
    password: str

@auth_router.post("/login")
async def login(data: LoginRequest):
    user = await get_user_by_email(data.email)

    if not user or not verify_password(data.password, user["password"]):
        raise HTTPException(status_code=401, detail="Credenciais inválidas")

    token = create_access_token({"sub": user["email"]})
    return {"access_token": token, "token_type": "bearer"}

# Rota para criar um usuário de teste
@auth_router.post("/create-test-user")
async def create_test_user():
    test_user = {
        "username": "fabricio",
        "email": "fabriciobc47@gmail.com",
        "password": "fabricio99",  # Senha para o teste
        "role": "admin"
    }
    
    try:
        user_id = await create_user_in_db(test_user)  # Chama a função que salva o usuário
        return {"message": "Usuário de teste criado com sucesso", "user_id": user_id}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

from fastapi import FastAPI
from app.routes.patient_routes import router as patient_router
from app.routes.user_routes import router as user_router
from app.routes.exercise_routes import router as exercise_router
from app.routes.schedule_routes import router as schedule_router
from app.routes.auth_routes import auth_router as auth_router  # ✅ Novo import
from fastapi.middleware.cors import CORSMiddleware
from app.services.auth_service import create_user
app = FastAPI()
async def create_test_user():
    # Dados do usuário de teste
    test_user_data = {
        "username": "teste_usuario",
        "email": "fabriciobc47@gmail.com",
        "password": "fabricio99",  # A senha será hasheada automaticamente
        "role": "admin"
    }
    
    # Criação do usuário com a senha hasheada e inserção no MongoDB
    create_user(test_user_data)
    print("Usuário de teste criado com sucesso.")

# Criar o usuário de teste assim que o servidor iniciar
@app.on_event("startup")
async def startup():
    await create_test_user()

# Endpoint de teste para confirmar
@app.get("/test")
def read_test_user():
    return {"message": "Usuário de teste criado com sucesso!"}

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # ou use ["http://localhost:PORT"] se quiser restringir
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Registrar rotas
app.include_router(patient_router)
app.include_router(user_router)
app.include_router(exercise_router)
app.include_router(schedule_router)
app.include_router(auth_router)  # ✅ Adiciona a rota de autenticação

@app.get("/")
async def root():
    return {"message": "API de Prescrição de Exercícios"}

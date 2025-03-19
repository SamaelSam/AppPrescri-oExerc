from fastapi import FastAPI
from app.routes.patient_routes import router as patient_router
from app.routes.user_routes import router as user_router
from app.routes.exercise_routes import router as exercise_router
from app.routes.schedule_routes import router as schedule_router

app = FastAPI()

# Registrar rotas
app.include_router(patient_router)
app.include_router(user_router)
app.include_router(exercise_router)
app.include_router(schedule_router)

@app.get("/")
async def root():
    return {"message": "API de Prescrição de Exercícios"}

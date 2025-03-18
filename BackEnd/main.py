from fastapi import FastAPI
from routes import patient, trainer, exercise

app = FastAPI(title="App de Prescrição de Exercícios")

# Rotas principais
app.include_router(patient.router, prefix="/patients", tags=["Patients"])
app.include_router(trainer.router, prefix="/trainers", tags=["Trainers"])
app.include_router(exercise.router, prefix="/exercises", tags=["Exercises"])

@app.get("/")
def home():
    return {"message": "Bem-vindo ao sistema de prescrição de exercícios!"}

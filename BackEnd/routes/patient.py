from fastapi import APIRouter

router = APIRouter()

@router.post("/")
async def create_patient(name: str, age: int):
    return {"message": f"Paciente {name} cadastrado com sucesso!"}

@router.get("/")
async def list_patients():
    return [{"name": "João", "age": 30}, {"name": "Maria", "age": 25}]

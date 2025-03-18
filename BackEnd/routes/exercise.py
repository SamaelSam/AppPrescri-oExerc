from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def list_exercises():
    return [
        {"name": "Corrida", "duration": "30 minutos"},
        {"name": "Levantamento de Peso", "sets": "3 séries de 10"}
    ]

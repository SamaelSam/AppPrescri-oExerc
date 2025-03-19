from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def list_trainers():
    return [{"name": "Carlos Silva"}, {"name": "Ana Souza"}]

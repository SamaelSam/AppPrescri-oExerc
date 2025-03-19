from fastapi import APIRouter
from app.models.exercise import Exercise
from app.services.exercise_service import (
    get_all_exercises, 
    create_exercise, 
    get_exercise_by_id, 
    delete_exercise
)

router = APIRouter()

@router.get("/exercises/")
async def list_exercises():
    return await get_all_exercises()

@router.post("/exercises/")
async def add_exercise(exercise: Exercise):
    return await create_exercise(exercise)

@router.get("/exercises/{exercise_id}")
async def get_exercise(exercise_id: str):
    return await get_exercise_by_id(exercise_id)

@router.delete("/exercises/{exercise_id}")
async def remove_exercise(exercise_id: str):
    return await delete_exercise(exercise_id)

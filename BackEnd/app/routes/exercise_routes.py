from fastapi import APIRouter, HTTPException
from app.models.exercise import Exercise

router = APIRouter(prefix="/exercises", tags=["Exercises"])

exercises = []

@router.post("/", response_model=Exercise)
async def create_exercise(exercise: Exercise):
    exercises.append(exercise)
    return exercise

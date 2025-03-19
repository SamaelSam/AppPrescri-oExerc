from bson import ObjectId
from fastapi import HTTPException
from app.db.connection import get_collection
from app.models.exercise import Exercise

collection = get_collection("exercises")

async def get_all_exercises():
    exercises = await collection.find().to_list(100)
    for exercise in exercises:
        exercise["_id"] = str(exercise["_id"])
    return exercises

async def create_exercise(exercise: Exercise):
    result = await collection.insert_one(exercise.dict())
    return {"id": str(result.inserted_id)}

async def get_exercise_by_id(exercise_id: str):
    exercise = await collection.find_one({"_id": ObjectId(exercise_id)})
    if exercise:
        exercise["_id"] = str(exercise["_id"])
        return exercise
    raise HTTPException(status_code=404, detail="Exercício não encontrado")

async def delete_exercise(exercise_id: str):
    result = await collection.delete_one({"_id": ObjectId(exercise_id)})
    if result.deleted_count == 1:
        return {"message": "Exercício removido com sucesso"}
    raise HTTPException(status_code=404, detail="Exercício não encontrado")

from fastapi import HTTPException
from bson import ObjectId
from app.database import get_collection
from app.models.exercise import Exercise

collection = get_collection("fitness_app.exercises")

async def create_exercise(exercise: Exercise) -> dict:
    # Converte o objeto Pydantic em dicionário, excluindo campos None
    exercise_data = exercise.model_dump(exclude_none=True)
    result = await collection.insert_one(exercise_data)
    return {
        "name": exercise_data["name"],
        "_id": str(result.inserted_id)
    }


async def get_exercise_by_name(name: str) -> dict | None:
    exercise = await collection.find_one({"name": name})
    if exercise:
        exercise["_id"] = str(exercise["_id"])
        return exercise
    return None

async def get_exercise_by_id(exercise_id: str) -> dict:
    exercise = await collection.find_one({"_id": ObjectId(exercise_id)})
    if exercise:
        exercise["_id"] = str(exercise["_id"])
        return exercise
    raise HTTPException(status_code=404, detail="Exercício não encontrado")

async def get_all_exercises() -> list:
    exercises = await collection.find().to_list(100)
    for ex in exercises:
        ex["_id"] = str(ex["_id"])
    return exercises

async def delete_exercise(exercise_id: str) -> dict:
    result = await collection.delete_one({"_id": ObjectId(exercise_id)})
    if result.deleted_count == 1:
        return {"message": "Exercício removido com sucesso"}
    raise HTTPException(status_code=404, detail="Exercício não encontrado")

from bson import ObjectId
from fastapi import HTTPException
from app.database import get_collection
from app.models.schedule import Schedule

collection = get_collection("fitness_app.schedules")


async def create_schedule(schedule: Schedule) -> dict:
    """
    Cria um novo agendamento a partir do modelo Schedule.
    """
    doc = schedule.dict(by_alias=True, exclude={"id"})
    result = await collection.insert_one(doc)
    doc["_id"] = str(result.inserted_id)
    return doc


async def get_all_schedules() -> list:
    """
    Retorna todos os agendamentos.
    """
    schedules = await collection.find().to_list(length=1000)
    for schedule in schedules:
        schedule["_id"] = str(schedule["_id"])
    return schedules


async def get_schedule_by_id(schedule_id: str) -> dict:
    """
    Retorna um agendamento pelo seu ID.
    """
    schedule = await collection.find_one({"_id": ObjectId(schedule_id)})
    if schedule:
        schedule["_id"] = str(schedule["_id"])
        return schedule
    raise HTTPException(status_code=404, detail="Agendamento não encontrado")


async def delete_schedule(schedule_id: str) -> dict:
    """
    Deleta um agendamento pelo ID.
    """
    result = await collection.delete_one({"_id": ObjectId(schedule_id)})
    if result.deleted_count == 1:
        return {"message": "Agendamento removido com sucesso"}
    raise HTTPException(status_code=404, detail="Agendamento não encontrado")

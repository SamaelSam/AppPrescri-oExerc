from typing import List, Optional
from pymongo.collection import Collection
from bson import ObjectId
from app.models.schedule import Schedule

def get_collection() -> Collection:
    # Função para obter a coleção do MongoDB
    from db import get_database
    db = get_database()
    return db["schedules"]

async def get_all_schedules():
    collection = get_collection("schedules")
    schedules = await collection.find().to_list(length=1000)
    return schedules

async def create_schedule(schedule: Schedule) -> dict:
    collection = get_collection()
    schedule_dict = schedule.dict(by_alias=True, exclude={"id"})
    result = await collection.insert_one(schedule_dict)
    schedule_dict["_id"] = str(result.inserted_id)
    return schedule_dict

async def get_schedule_by_id(schedule_id: str) -> Optional[dict]:
    collection = get_collection()
    schedule = await collection.find_one({"_id": ObjectId(schedule_id)})
    if schedule:
        schedule["_id"] = str(schedule["_id"])
    return schedule

async def delete_schedule(schedule_id: str) -> dict:
    collection = get_collection()
    result = await collection.delete_one({"_id": ObjectId(schedule_id)})
    if result.deleted_count:
        return {"message": "Agendamento removido com sucesso"}
    else:
        return {"message": "Agendamento não encontrado"}

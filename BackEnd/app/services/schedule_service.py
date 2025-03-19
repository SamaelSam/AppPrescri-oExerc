from bson import ObjectId
from fastapi import HTTPException
from app.db.connection import get_collection
from app.models.schedule import Schedule

collection = get_collection("schedules")

async def get_all_schedules():
    schedules = await collection.find().to_list(100)
    for schedule in schedules:
        schedule["_id"] = str(schedule["_id"])
    return schedules

async def create_schedule(schedule: Schedule):
    result = await collection.insert_one(schedule.dict())
    return {"id": str(result.inserted_id)}

async def get_schedule_by_id(schedule_id: str):
    schedule = await collection.find_one({"_id": ObjectId(schedule_id)})
    if schedule:
        schedule["_id"] = str(schedule["_id"])
        return schedule
    raise HTTPException(status_code=404, detail="Agenda não encontrada")

async def delete_schedule(schedule_id: str):
    result = await collection.delete_one({"_id": ObjectId(schedule_id)})
    if result.deleted_count == 1:
        return {"message": "Agenda removida com sucesso"}
    raise HTTPException(status_code=404, detail="Agenda não encontrada")

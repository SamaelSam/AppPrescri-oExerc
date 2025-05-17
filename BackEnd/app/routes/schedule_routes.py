from fastapi import APIRouter, HTTPException
from app.models.schedule import Schedule
from app.database import get_collection 
from app.services.schedule_service import (
    get_all_schedules, 
    create_schedule, 
    get_schedule_by_id, 
    delete_schedule
)
router = APIRouter()
collection = get_collection("fitness_app.schedules")
@router.get("/schedules/")
async def list_schedules():
    return await get_all_schedules()

@router.post("/schedules/")
async def add_schedule(schedule: Schedule):
    return await create_schedule(schedule)

@router.get("/schedules/{schedule_id}")
async def get_schedule(schedule_id: str):
    return await get_schedule_by_id(schedule_id)

@router.delete("/schedules/{schedule_id}")
async def remove_schedule(schedule_id: str):
    return await delete_schedule(schedule_id)


@router.get("/schedules/user/{user_id}")
async def get_schedules_by_user(user_id: str):
    cursor = collection.find({"user_id": user_id})
    schedules = []
    async for schedule in cursor:
        schedule["_id"] = str(schedule["_id"])
        schedules.append(schedule)
    if not schedules:
        raise HTTPException(status_code=404, detail="Nenhum agendamento encontrado para esse usuário")
    return schedules
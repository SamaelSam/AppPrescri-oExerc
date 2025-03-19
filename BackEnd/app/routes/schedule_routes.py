from fastapi import APIRouter
from app.models.schedule import Schedule
from app.services.schedule_service import (
    get_all_schedules, 
    create_schedule, 
    get_schedule_by_id, 
    delete_schedule
)

router = APIRouter()

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

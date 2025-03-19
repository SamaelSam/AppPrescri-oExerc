from fastapi import APIRouter, HTTPException
from app.models.schedule import Schedule

router = APIRouter(prefix="/schedules", tags=["schedules"])

schedules = []

@router.post("/", response_model=Schedule)
async def create_schedule(schedule: Schedule):
    schedules.append(schedule)
    return schedule

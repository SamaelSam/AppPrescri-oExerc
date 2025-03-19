import pytest
from app.services.schedule_service import (
    create_schedule, get_schedule, get_all_schedules,
    update_schedule, delete_schedule
)

@pytest.mark.asyncio
async def test_create_schedule():
    schedule_data = {"title": "Treino de hipertrofia", "duration": "6 semanas"}
    result = await create_schedule(schedule_data)
    assert "title" in result
    assert result["title"] == "Treino de hipertrofia"

@pytest.mark.asyncio
async def test_get_schedule():
    schedule_data = {"title": "Treino para resistência", "duration": "8 semanas"}
    created_schedule = await create_schedule(schedule_data)
    found_schedule = await get_schedule(created_schedule["_id"])
    assert found_schedule is not None
    assert found_schedule["title"] == "Treino para resistência"

@pytest.mark.asyncio
async def test_update_schedule():
    schedule_data = {"title": "Treino básico", "duration": "4 semanas"}
    created_schedule = await create_schedule(schedule_data)
    updated_data = {"duration": "5 semanas"}
    updated_schedule = await update_schedule(created_schedule["_id"], updated_data)
    assert updated_schedule["duration"] == "5 semanas"

@pytest.mark.asyncio
async def test_delete_schedule():
    schedule_data = {"title": "Treino avançado", "duration": "12 semanas"}
    created_schedule = await create_schedule(schedule_data)
    result = await delete_schedule(created_schedule["_id"])
    assert result is True

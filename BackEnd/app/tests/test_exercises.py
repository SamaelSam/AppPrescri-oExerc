import pytest
from app.services.exercise_service import (
    create_exercise, get_exercise, get_all_exercises,
    update_exercise, delete_exercise
)

@pytest.mark.asyncio
async def test_create_exercise():
    exercise_data = {"name": "Agachamento", "reps": 15}
    result = await create_exercise(exercise_data)
    assert "name" in result
    assert result["name"] == "Agachamento"

@pytest.mark.asyncio
async def test_get_exercise():
    exercise_data = {"name": "Supino", "reps": 10}
    created_exercise = await create_exercise(exercise_data)
    found_exercise = await get_exercise(created_exercise["_id"])
    assert found_exercise is not None
    assert found_exercise["name"] == "Supino"

@pytest.mark.asyncio
async def test_update_exercise():
    exercise_data = {"name": "Flexão", "reps": 12}
    created_exercise = await create_exercise(exercise_data)
    updated_data = {"reps": 15}
    updated_exercise = await update_exercise(created_exercise["_id"], updated_data)
    assert updated_exercise["reps"] == 15

@pytest.mark.asyncio
async def test_delete_exercise():
    exercise_data = {"name": "Prancha", "duration": 60}
    created_exercise = await create_exercise(exercise_data)
    result = await delete_exercise(created_exercise["_id"])
    assert result is True

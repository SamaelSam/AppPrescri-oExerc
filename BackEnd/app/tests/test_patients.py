import pytest
from app.services.patient_service import (
    create_patient, get_patient, get_all_patients,
    update_patient, delete_patient
)

@pytest.mark.asyncio
async def test_create_patient():
    patient_data = {"name": "João Silva", "age": 30}
    result = await create_patient(patient_data)
    assert "name" in result
    assert result["name"] == "João Silva"

@pytest.mark.asyncio
async def test_get_patient():
    patient_data = {"name": "Maria Souza", "age": 40}
    created_patient = await create_patient(patient_data)
    found_patient = await get_patient(created_patient["_id"])
    assert found_patient is not None
    assert found_patient["name"] == "Maria Souza"

@pytest.mark.asyncio
async def test_update_patient():
    patient_data = {"name": "Carlos Lima", "age": 35}
    created_patient = await create_patient(patient_data)
    updated_data = {"age": 36}
    updated_patient = await update_patient(created_patient["_id"], updated_data)
    assert updated_patient["age"] == 36

@pytest.mark.asyncio
async def test_delete_patient():
    patient_data = {"name": "Ana Paula", "age": 28}
    created_patient = await create_patient(patient_data)
    result = await delete_patient(created_patient["_id"])
    assert result is True

from fastapi import APIRouter, HTTPException
from app.models.patient import Patient
from app.services.patient_service import (
    get_all_patients, 
    create_patient, 
    get_patient_by_id, 
    delete_patient
)

router = APIRouter()

@router.get("/patients/")
async def list_patients():
    return await get_all_patients()

@router.post("/patients/")
async def add_patient(patient: Patient):
    return await create_patient(patient)

@router.get("/patients/{patient_id}")
async def get_patient(patient_id: str):
    return await get_patient_by_id(patient_id)

@router.delete("/patients/{patient_id}")
async def remove_patient(patient_id: str):
    return await delete_patient(patient_id)

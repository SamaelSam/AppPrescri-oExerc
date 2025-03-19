from bson import ObjectId
from fastapi import HTTPException
from app.db.connection import get_collection
from app.models.patient import Patient

collection = get_collection("patients")

async def get_all_patients():
    patients = await collection.find().to_list(100)
    for patient in patients:
        patient["_id"] = str(patient["_id"])
    return patients

async def create_patient(patient: Patient):
    result = await collection.insert_one(patient.dict())
    return {"id": str(result.inserted_id)}

async def get_patient_by_id(patient_id: str):
    patient = await collection.find_one({"_id": ObjectId(patient_id)})
    if patient:
        patient["_id"] = str(patient["_id"])
        return patient
    raise HTTPException(status_code=404, detail="Paciente não encontrado")

async def delete_patient(patient_id: str):
    result = await collection.delete_one({"_id": ObjectId(patient_id)})
    if result.deleted_count == 1:
        return {"message": "Paciente removido com sucesso"}
    raise HTTPException(status_code=404, detail="Paciente não encontrado")

from fastapi import HTTPException
from bson import ObjectId
from app.database import get_collection
from app.models.patient import Patient

collection = get_collection("fitness_app.patients")  # ajuste conforme seu banco/coleção

async def create_patient(patient: Patient) -> dict:
    patient_data = patient.model_dump(by_alias=True)  # usa snake_case no dicionário
    result = await collection.insert_one(patient_data)
    return {
        "name": patient_data["name"],
        "_id": str(result.inserted_id)
    }

async def get_patient_by_id(patient_id: str) -> dict:
    patient = await collection.find_one({"_id": ObjectId(patient_id)})
    if patient:
        patient["_id"] = str(patient["_id"])
        return patient
    raise HTTPException(status_code=404, detail="Paciente não encontrado")

async def get_all_patients() -> list:
    patients = await collection.find().to_list(100)
    for p in patients:
        p["_id"] = str(p["_id"])
    return patients

async def delete_patient(patient_id: str) -> dict:
    result = await collection.delete_one({"_id": ObjectId(patient_id)})
    if result.deleted_count == 1:
        return {"message": "Paciente removido com sucesso"}
    raise HTTPException(status_code=404, detail="Paciente não encontrado")

from typing import List, Optional
from app.models.patient import Patient
from bson import ObjectId

# Supondo que get_collection seja uma função que retorna a coleção do MongoDB
def get_collection(name: str):
    # Implementação para obter a coleção do MongoDB
    pass

async def create_patient(patient_data: dict) -> dict:
    collection = get_collection("patients")
    patient = Patient(**patient_data)
    result = await collection.insert_one(patient.dict(by_alias=True))
    return {**patient.dict(by_alias=True), "_id": result.inserted_id}

async def get_patient_by_id(patient_id: ObjectId) -> Optional[dict]:
    collection = get_collection("patients")
    patient = await collection.find_one({"_id": patient_id})
    return patient

async def update_patient(patient_id: ObjectId, update_data: dict) -> Optional[dict]:
    collection = get_collection("patients")
    await collection.update_one({"_id": patient_id}, {"$set": update_data})
    updated_patient = await collection.find_one({"_id": patient_id})
    return updated_patient

async def delete_patient(patient_id: ObjectId) -> bool:
    collection = get_collection("patients")
    result = await collection.delete_one({"_id": patient_id})
    return result.deleted_count == 1

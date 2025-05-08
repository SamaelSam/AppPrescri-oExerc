from typing import List, Optional
from app.models.patient import Patient
from bson import ObjectId
from motor.motor_asyncio import AsyncIOMotorClient  # Para conexão assíncrona com MongoDB
from app.database import get_database  # Supondo que você tenha uma função que retorna o banco de dados

# Obter coleção do MongoDB
def get_collection(name: str):
    db = get_database()  # Função que retorna o banco de dados
    return db[name]  # Retorna a coleção
async def get_all_patients() -> List[dict]:
    collection = get_collection("patients")
    patients = await collection.find().to_list(length=1000)
    return patients
# Função para criar um paciente
async def create_patient(patient_data: dict) -> dict:
    collection = get_collection("patients")
    patient = Patient(**patient_data)
    result = await collection.insert_one(patient.dict(by_alias=True))
    return {**patient.dict(by_alias=True), "_id": str(result.inserted_id)}

# Função para obter paciente por ID
async def get_patient_by_id(patient_id: str) -> Optional[dict]:  # ID em string
    collection = get_collection("patients")
    patient = await collection.find_one({"_id": ObjectId(patient_id)})
    if patient:
        patient["_id"] = str(patient["_id"])  # Converter ObjectId para string
    return patient

# Função para atualizar paciente
async def update_patient(patient_id: str, update_data: dict) -> Optional[dict]:
    collection = get_collection("patients")
    await collection.update_one({"_id": ObjectId(patient_id)}, {"$set": update_data})
    updated_patient = await collection.find_one({"_id": ObjectId(patient_id)})
    if updated_patient:
        updated_patient["_id"] = str(updated_patient["_id"])  # Converter ObjectId para string
    return updated_patient

# Função para deletar paciente
async def delete_patient(patient_id: str) -> bool:
    collection = get_collection("patients")
    result = await collection.delete_one({"_id": ObjectId(patient_id)})
    return result.deleted_count == 1

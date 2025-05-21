from bson import ObjectId
from fastapi import HTTPException, Query
from app.database import get_collection
from app.models.schedule import Schedule
from typing import List

collection = get_collection("fitness_app.schedules")
patients_collection = get_collection("fitness_app.patients")
schedules_collection = get_collection("fitness_app.schedules")

async def create_schedule(schedule: Schedule) -> dict:
    """
    Cria um novo agendamento a partir do modelo Schedule.
    """
    doc = schedule.dict(by_alias=True, exclude={"id"})
    result = await collection.insert_one(doc)
    doc["_id"] = str(result.inserted_id)
    return doc


async def get_all_schedules() -> list:
    """
    Retorna todos os agendamentos.
    """
    schedules = await collection.find().to_list(length=1000)
    for schedule in schedules:
        schedule["_id"] = str(schedule["_id"])
    return schedules


async def get_schedule_by_id(schedule_id: str) -> dict:
    """
    Retorna um agendamento pelo seu ID.
    """
    schedule = await collection.find_one({"_id": ObjectId(schedule_id)})
    if schedule:
        schedule["_id"] = str(schedule["_id"])
        return schedule
    raise HTTPException(status_code=404, detail="Agendamento não encontrado")


async def get_schedules_by_patient_email(email: str):
    # Buscar paciente pelo e-mail
    patient = await patients_collection.find_one({"email": email})
    if not patient:
        raise HTTPException(status_code=404, detail="Paciente não encontrado com esse e-mail.")

    patient_id = str(patient["_id"])  # já está como string, mas garantimos isso aqui

    # Buscar agendamentos com user_id == patient_id
    cursor = schedules_collection.find({"user_id": patient_id})
    schedules = []
    async for schedule in cursor:
        schedule["_id"] = str(schedule["_id"])
        schedules.append(schedule)

    return schedules

async def delete_schedule(schedule_id: str) -> dict:
    """
    Deleta um agendamento pelo ID.
    """
    result = await collection.delete_one({"_id": ObjectId(schedule_id)})
    if result.deleted_count == 1:
        return {"message": "Agendamento removido com sucesso"}
    raise HTTPException(status_code=404, detail="Agendamento não encontrado")

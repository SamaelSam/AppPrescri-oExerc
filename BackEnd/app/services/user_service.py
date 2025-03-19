from bson import ObjectId
from fastapi import HTTPException
from app.db.connection import get_collection
from app.models.user import User

collection = get_collection("users")

async def get_all_users():
    users = await collection.find().to_list(100)
    for user in users:
        user["_id"] = str(user["_id"])
    return users

async def create_user(user: User):
    result = await collection.insert_one(user.dict())
    return {"id": str(result.inserted_id)}

async def get_user_by_id(user_id: str):
    user = await collection.find_one({"_id": ObjectId(user_id)})
    if user:
        user["_id"] = str(user["_id"])
        return user
    raise HTTPException(status_code=404, detail="Usuário não encontrado")

async def delete_user(user_id: str):
    result = await collection.delete_one({"_id": ObjectId(user_id)})
    if result.deleted_count == 1:
        return {"message": "Usuário removido com sucesso"}
    raise HTTPException(status_code=404, detail="Usuário não encontrado")

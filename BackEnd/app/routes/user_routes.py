from fastapi import APIRouter
from app.models.user import User
from app.services.user_service import (
    get_all_users, 
    create_user, 
    get_user_by_id, 
    delete_user
)

router = APIRouter()

@router.get("/users/")
async def list_users():
    return await get_all_users()

@router.post("/users/")
async def add_user(user: User):
    return await create_user(user)

@router.get("/users/{user_id}")
async def get_user(user_id: str):
    return await get_user_by_id(user_id)

@router.delete("/users/{user_id}")
async def remove_user(user_id: str):
    return await delete_user(user_id)

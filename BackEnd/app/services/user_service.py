from passlib.context import CryptContext
from fastapi import HTTPException
from bson import ObjectId
from app.database import get_collection
from app.models.user import User
from app.utils.security import hash_password, verify_password

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
collection = get_collection("fitness_app.users")

def create_password_hash(password: str) -> str:
    return pwd_context.hash(password)

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)

# Função para testar o hash da senha
def test_password_hashing(password: str) -> bool:
    hashed_password = create_password_hash(password)
    return verify_password(password, hashed_password)

async def create_user(user: User) -> dict:
    """
    Recebe um objeto User (com password em texto puro).
    Gera hash e salva como hashed_password no banco.
    """
    doc = user.dict()
    hashed = hash_password(doc["password"])
    doc["hashed_password"] = hashed
    doc.pop("password")

    # Testando se o hash funciona corretamente
    if not test_password_hashing(doc["password"]):
        raise HTTPException(status_code=500, detail="Erro ao criar o hash da senha")

    collection = get_collection("users")
    result = await collection.insert_one(doc)
    doc["_id"] = str(result.inserted_id)
    return doc

async def get_user_by_username(username: str) -> dict | None:
    collection = get_collection("users")
    user = await collection.find_one({"username": username})
    if user:
        user["_id"] = str(user["_id"])
    return user

async def get_user_by_email(email: str) -> dict | None:
    """
    Busca um usuário pelo email.
    Retorna None se não encontrar.
    """
    collection = get_collection("fitness_app.users")
    user = await collection.find_one({"email": email})
    if user:
        user["_id"] = str(user["_id"])
    return user

async def get_all_users() -> list:
    users = await collection.find().to_list(100)
    for user in users:
        user["_id"] = str(user["_id"])
    return users

async def get_user_by_id(user_id: str) -> dict:
    user = await collection.find_one({"_id": ObjectId(user_id)})
    if user:
        user["_id"] = str(user["_id"])
        return user
    raise HTTPException(status_code=404, detail="Usuário não encontrado")

async def delete_user(user_id: str) -> dict:
    result = await collection.delete_one({"_id": ObjectId(user_id)})
    if result.deleted_count == 1:
        return {"message": "Usuário removido com sucesso"}
    raise HTTPException(status_code=404, detail="Usuário não encontrado")

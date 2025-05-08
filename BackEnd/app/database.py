# app/database.py
import motor.motor_asyncio
import os
from dotenv import load_dotenv
from app.services.auth_service import create_user

load_dotenv()

MONGO_URL = os.getenv("MONGO_URL", "mongodb+srv://fabricio:fabricio99@reciclai.y2she.mongodb.net/")
DATABASE_NAME = os.getenv("DATABASE_NAME", "fitnessAPP")

client = motor.motor_asyncio.AsyncIOMotorClient(MONGO_URL)
database = client[DATABASE_NAME]

def get_database():
    return database
def get_collection(name: str):
    return get_database()[name]
async def create_user_in_db(form_data: dict):
    user_data = create_user(form_data)
    db = get_database()                     # Corrigido
    collection = db["fitness_app.users"]                # Corrigido
    result = await collection.insert_one(user_data)
    return str(result.inserted_id)

import motor.motor_asyncio
import os
from dotenv import load_dotenv

load_dotenv()

MONGO_URL = os.getenv("MONGO_URL", "mongodb://localhost:27017")
DATABASE_NAME = os.getenv("DATABASE_NAME", "fitness_app")

client = motor.motor_asyncio.AsyncIOMotorClient(MONGO_URL)
database = client[DATABASE_NAME]

def get_collection(collection_name: str):
    return database[collection_name]

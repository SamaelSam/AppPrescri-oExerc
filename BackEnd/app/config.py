# app/config.py
import os
from dotenv import load_dotenv

load_dotenv()  # Carregar variáveis de ambiente de um arquivo .env

class Settings:
    MONGO_URI = os.getenv("MONGO_URI", "mongodb://localhost:27017")  # Defina a URI do MongoDB

settings = Settings()

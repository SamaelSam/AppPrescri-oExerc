from datetime import datetime, timedelta
from jose import jwt
from app.utils.security import hash_password, verify_password
from app.models.user import User, Role
from app.db.connection import get_collection

SECRET_KEY = "seu_segredo_super_secreto"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

def create_access_token(data: dict, expires_delta: timedelta = None):
    to_encode = data.copy()
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=15))
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

async def register_user(user: User):
    collection = get_collection("users")
    user.password = hash_password(user.password)
    await collection.insert_one(user.dict())

async def authenticate_user(username: str, password: str):
    collection = get_collection("users")
    user = await collection.find_one({"username": username})
    if not user or not verify_password(password, user["password"]):
        return False
    return user

from passlib.context import CryptContext
from typing import Optional
from datetime import datetime, timedelta
import jwt  # Biblioteca PyJWT, instale com: pip install PyJWT

# Configurações do JWT (substitua pelos valores reais do seu app)
SECRET_KEY = "sua_chave_secreta"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

# Criação do contexto para o hash da senha usando bcrypt
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


# Função para gerar o hash da senha
def create_password_hash(password: str) -> str:
    """
    Recebe uma senha em texto simples e retorna o hash gerado para ela.
    """
    return pwd_context.hash(password)


# Função para verificar se a senha fornecida corresponde ao hash armazenado
def verify_password(plain_password: str, hashed_password: str) -> bool:
    """
    Compara a senha fornecida com o hash da senha armazenada.
    """
    return pwd_context.verify(plain_password, hashed_password)


# Função para criar um token de acesso JWT
def create_access_token(data: dict, expires_delta: Optional[timedelta] = None) -> str:
    """
    Gera um token de acesso JWT contendo os dados do usuário.
    """
    to_encode = data.copy()
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES))
    to_encode.update({"exp": expire})

    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


# Função fictícia para criar um usuário com senha hasheada
def create_user(form_data: dict) -> dict:
    hashed_password = create_password_hash(form_data['password'])
    return {
        "username": form_data['username'],
        "email": form_data['email'],
        "password": hashed_password
    }
    create_user_in_db(form_data)

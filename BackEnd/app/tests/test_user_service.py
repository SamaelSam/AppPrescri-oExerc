import pytest
from app.services.user_service import create_user, get_user_by_username, verify_password
from app.models.user import User

@pytest.mark.asyncio
async def test_create_user(monkeypatch, test_db):
    # Mock do insert_one
    async def mock_insert_one(data):
        class MockInsertResult:
            inserted_id = "fake_id"
        return MockInsertResult()

    monkeypatch.setattr(test_db["users"], "insert_one", mock_insert_one)

    # Dados para o modelo
    user_data = {
        "username": "test_user",
        "email": "test@example.com",
        "password": "mypassword",   # texto puro
        "role": "user"
    }
    # Converte em objeto Pydantic
    user_obj = User(**user_data)

    # Chama a função create_user
    result = await create_user(user_obj)

    # Verifica se o dicionário salvo no banco tem hashed_password
    assert "hashed_password" in result
    # Verifica se não é igual à senha pura
    assert result["hashed_password"] != "mypassword"
    # Garante que o hash corresponde à senha
    assert verify_password("mypassword", result["hashed_password"])
    # Verifica username e role
    assert result["username"] == "test_user"
    assert result["role"] == "user"
    
@pytest.mark.asyncio
async def test_get_user_by_username(monkeypatch, test_db):
    # Mock do find_one
    async def mock_find_one(query):
        if query["username"] == "test_user":
            return {
                "_id": "fake_id",
                "username": "test_user",
                "email": "test@example.com",
                "hashed_password": "somehashed",
                "role": "user"
            }
        return None

    monkeypatch.setattr(test_db["users"], "find_one", mock_find_one)

    from app.services.user_service import get_user_by_username

    user = await get_user_by_username("test_user")
    assert user is not None
    assert user["username"] == "test_user"
    assert verify_password("mypassword", user["hashed_password"])

@pytest.mark.asyncio
async def test_verify_password():
    """
    Testa a função de verificação de senha.
    """

    from app.services.user_service import get_password_hash

    plain_password = "securepassword"
    hashed_password = get_password_hash(plain_password)
    assert await verify_password(plain_password, hashed_password) is True

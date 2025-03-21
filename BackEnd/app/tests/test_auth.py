import pytest
from app.services.auth_service import register_user, authenticate_user
from app.models.user import User, Role
from app.utils.security import hash_password, verify_password

@pytest.mark.asyncio
async def test_create_user(monkeypatch, test_db):
    from app.services.user_service import create_user
    from app.models.user import User, Role

    # Mock insert_one
    async def mock_insert_one(data):
        class MockInsertResult:
            inserted_id = "fake_id"
        return MockInsertResult()

    monkeypatch.setattr(test_db["users"], "insert_one", mock_insert_one)

    # Todos os campos obrigatórios do modelo
    user_data = {
        "username": "test_user",
        "email": "test@example.com",
        "password": "mypassword",
        "role": "user"
    }

    user_obj = User(**user_data)
    result = await create_user(user_obj)

    assert result["username"] == "test_user"
    assert "_id" in result
    assert len(result["_id"]) > 0


@pytest.mark.asyncio
async def test_authenticate_user_success(test_db, monkeypatch):
    async def mock_find_one(query):
        if query["username"] == "user_teste":
            return {
                "username": "user_teste",
                "password": "$2b$12$U3qx7yG7XaBZl1OlJKw4yeZ5pCH.ehZ49TAF6X3FzRH0dMzIzLT5W",  # senha123 hasheada
                "role": "user"
            }
        return None

    monkeypatch.setattr(test_db["users"], "find_one", mock_find_one)

    user = await authenticate_user("user_teste", "senha123")
    assert user is not False

@pytest.mark.asyncio
async def test_authenticate_user_fail(test_db, monkeypatch):
    async def mock_find_one(query):
        return None  # Simula usuário não encontrado

    monkeypatch.setattr(test_db["users"], "find_one", mock_find_one)

    user = await authenticate_user("user_nao_existe", "senha_errada")
    assert user is False

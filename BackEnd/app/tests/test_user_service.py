import pytest
from app.services.user_service import create_user, get_user_by_username, verify_password
from app.models.user import User

@pytest.mark.asyncio
async def test_create_user(test_db, monkeypatch):
    """
    Testa a criação de usuário com banco de dados de teste.
    """

    # 1. Mock de get_collection para usar test_db
    from app.services import user_service
    def mock_get_collection(name: str):
        return test_db[name]
    monkeypatch.setattr(user_service, "get_collection", mock_get_collection)

    # 2. Cria um objeto Pydantic de usuário
    user_obj = User(
        username="test_user",
        hashed_password="testpassword",
        email="test_user@example.com"
    )

    # 3. Chama a função de criação de usuário
    result = await user_service.create_user(user_obj)

    # 4. Verifica o retorno
    assert "username" in result
    assert result["username"] == "test_user"
    assert "_id" in result

@pytest.mark.asyncio
async def test_get_user_by_username(test_db, monkeypatch):
    """
    Testa a busca de usuário por nome de usuário.
    """

    from app.services import user_service
    def mock_get_collection(name: str):
        return test_db[name]
    monkeypatch.setattr(user_service, "get_collection", mock_get_collection)

    # Cria um usuário no banco de teste
    user_obj = User(
        username="sample_user",
        hashed_password="samplepassword",
        email="sample_user@example.com"
    )
    await user_service.create_user(user_obj)

    # Busca pelo username
    found_user = await user_service.get_user_by_username("sample_user")
    assert found_user is not None
    assert found_user["username"] == "sample_user"

@pytest.mark.asyncio
async def test_verify_password():
    """
    Testa a função de verificação de senha.
    """

    from app.services.user_service import get_password_hash

    plain_password = "securepassword"
    hashed_password = get_password_hash(plain_password)
    assert await verify_password(plain_password, hashed_password) is True

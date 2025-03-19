import pytest
from app.services.user_service import (
    create_user, get_user_by_username, verify_password
)

@pytest.mark.asyncio
async def test_create_user():
    user_data = {"username": "test_user", "hashed_password": "testpassword"}
    result = await create_user(user_data)
    assert "username" in result
    assert result["username"] == "test_user"

@pytest.mark.asyncio
async def test_get_user_by_username():
    user_data = {"username": "sample_user", "hashed_password": "samplepassword"}
    await create_user(user_data)
    found_user = await get_user_by_username("sample_user")
    assert found_user is not None
    assert found_user["username"] == "sample_user"

@pytest.mark.asyncio
async def test_verify_password():
    plain_password = "securepassword"
    hashed_password = "$2b$12$CqZUxDpYIYvQo0Z9FwpOaeTf5jRHkDiHsbmDGwbS.mX/NyPT1jNOO"  # Bcrypt hash
    assert await verify_password(plain_password, hashed_password) is True

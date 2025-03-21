import pytest
from fastapi import HTTPException
from app.utils.role_checker import require_role
from app.models.user import Role

@pytest.mark.asyncio
async def test_admin_access():
    from app.utils.role_checker import require_role
    from app.models.user import Role

    # Pegamos a função role_checker
    role_checker = require_role(Role.ADMIN)

    # Chamamos a função role_checker passando mock_user
    mock_user = {"username": "admin_user", "role": "admin"}
    result = await role_checker(mock_user)

    assert result["username"] == "admin_user"

@pytest.mark.asyncio
async def test_user_access_denied():
    mock_user = {"username": "regular_user", "role": "user"}

    with pytest.raises(HTTPException) as exc:
        await require_role(Role.ADMIN)(mock_user)

    assert exc.value.status_code == 403
    assert exc.value.detail == "Permissão negada"

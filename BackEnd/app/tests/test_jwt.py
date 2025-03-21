import pytest
from jose import jwt, JWTError
from datetime import timedelta
from app.services.auth_service import create_access_token, SECRET_KEY, ALGORITHM

def test_create_access_token():
    token = create_access_token({"sub": "user_teste", "role": "admin"})
    payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
    assert payload["sub"] == "user_teste"
    assert payload["role"] == "admin"

def test_token_expired():
    expired_token = create_access_token({"sub": "user_teste"}, expires_delta=timedelta(seconds=-1))
    with pytest.raises(JWTError):
        jwt.decode(expired_token, SECRET_KEY, algorithms=[ALGORITHM])

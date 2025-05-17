from pydantic import BaseModel
from app.models.user import UserDisplay

class LoginResponse(BaseModel):
    access_token: str
    token_type: str
    user: UserDisplay

from fastapi import APIRouter, Depends
from app.utils.role_checker import require_role
from app.models.user import Role

router = APIRouter()

@router.get("/admin-only")
async def admin_dashboard(user=Depends(require_role(Role.ADMIN))):
    return {"message": f"Bem-vindo, {user['username']}! Você tem permissões de administrador."}

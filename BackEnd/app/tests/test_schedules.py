import pytest
from datetime import datetime, timedelta
from app.models.schedule import Schedule
from app.services import schedule_service

@pytest.mark.asyncio
async def test_create_schedule(test_db, monkeypatch):
    """
    Testa a criação de um agendamento.
    """

    # Mock da função get_collection para usar test_db
    def mock_get_collection():
        return test_db["schedules"]
    monkeypatch.setattr(schedule_service, "get_collection", mock_get_collection)

    # Cria um objeto Schedule
    schedule_obj = Schedule(
        user_id="user123",
        exercise_id="exercise456",
        scheduled_time=datetime.now() + timedelta(days=1),
        duration_minutes=60,
        notes="Sessão de treino de força"
    )

    # Chama a função de criação
    result = await schedule_service.create_schedule(schedule_obj)

    # Verifica o retorno
    assert "user_id" in result
    assert result["user_id"] == "user123"
    assert "_id" in result

@pytest.mark.asyncio
async def test_get_schedule_by_id(test_db, monkeypatch):
    """
    Testa a obtenção de um agendamento pelo ID.
    """

    def mock_get_collection():
        return test_db["schedules"]
    monkeypatch.setattr(schedule_service, "get_collection", mock_get_collection)

    # Cria um agendamento no banco de teste
    schedule_obj = Schedule(
        user_id="user789",
        exercise_id="exercise101",
        scheduled_time=datetime.now() + timedelta(days=2),
        duration_minutes=45,
        notes="Sessão de cardio"
    )
    created_schedule = await schedule_service.create_schedule(schedule_obj)
    schedule_id = created_schedule["_id"]

    # Busca pelo ID
    found_schedule = await schedule_service.get_schedule_by_id(schedule_id)
    assert found_schedule is not None
    assert found_schedule["user_id"] == "user789"

@pytest.mark.asyncio
async def test_delete_schedule(test_db, monkeypatch):
    """
    Testa a deleção de um agendamento pelo ID.
    """

    def mock_get_collection():
        return test_db["schedules"]
    monkeypatch.setattr(schedule_service, "get_collection", mock_get_collection)

    # Cria um agendamento
    schedule_obj = Schedule(
        user_id="user456",
        exercise_id="exercise789",
        scheduled_time=datetime.now() + timedelta(days=3),
        duration_minutes=30,
        notes="Sessão de alongamento"
    )
    created_schedule = await schedule_service.create_schedule(schedule_obj)
    schedule_id = created_schedule["_id"]

    # Deleta o agendamento
    result = await schedule_service.delete_schedule(schedule_id)
    assert result["message"] == "Agendamento removido com sucesso"

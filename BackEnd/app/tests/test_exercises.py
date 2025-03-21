import pytest
from app.models.exercise import Exercise
from app.services import exercise_service

@pytest.mark.asyncio
async def test_create_exercise(test_db, monkeypatch):
    """
    Testa a criação de um exercício utilizando o banco de dados de teste.
    """

    # Mock da função get_collection para utilizar test_db
    def mock_get_collection(name: str):
        return test_db[name]
    monkeypatch.setattr(exercise_service, "get_collection", mock_get_collection)

    # Cria um objeto Exercise
    exercise_obj = Exercise(
        name="Agachamento Livre",
        description="Exercício para pernas e glúteos",
        category="Força",
        difficulty="hard"
    )

    # Chama a função de criação
    result = await exercise_service.create_exercise(exercise_obj)

    # Verifica o resultado
    assert "name" in result
    assert result["name"] == "Agachamento Livre"
    assert "_id" in result

@pytest.mark.asyncio
async def test_get_exercise_by_name(test_db, monkeypatch):
    """
    Testa a obtenção de um exercício pelo nome.
    """

    def mock_get_collection(name: str):
        return test_db[name]
    monkeypatch.setattr(exercise_service, "get_collection", mock_get_collection)

    # Cria um exercício no banco de dados de teste
    exercise_obj = Exercise(
        name="Supino Reto",
        description="Exercício para peitoral",
        category="Força",
        difficulty="medium"
    )
    await exercise_service.create_exercise(exercise_obj)

    # Busca o exercício pelo nome
    found_exercise = await exercise_service.get_exercise_by_name("Supino Reto")
    assert found_exercise is not None
    assert found_exercise["name"] == "Supino Reto"

@pytest.mark.asyncio
async def test_delete_exercise(test_db, monkeypatch):
    """
    Testa a deleção de um exercício pelo ID.
    """

    def mock_get_collection(name: str):
        return test_db[name]
    monkeypatch.setattr(exercise_service, "get_collection", mock_get_collection)

    # Cria um exercício
    exercise_obj = Exercise(name="Abdominal", description="Exercício para o core")
    created = await exercise_service.create_exercise(exercise_obj)
    ex_id = created["_id"]

    # Deleta o exercício
    result = await exercise_service.delete_exercise(ex_id)
    assert result["message"] == "Exercício removido com sucesso"

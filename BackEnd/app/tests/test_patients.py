import pytest
from bson import ObjectId
from app.services import patient_service

@pytest.mark.asyncio
async def test_create_patient(monkeypatch):
    """
    Testa a criação de um paciente.
    """
    # 1. Definir uma classe que simule a coleção
    class MockCollection:
        async def insert_one(self, *args, **kwargs):
            # Retorna um objeto simulando o resultado de insert_one
            return type("InsertResult", (), {"inserted_id": ObjectId()})

    # 2. Função que substitui get_collection para retornar nossa MockCollection
    def mock_get_collection(name: str):
        return MockCollection()

    # 3. Substituir patient_service.get_collection pela função mock_get_collection
    monkeypatch.setattr(patient_service, "get_collection", mock_get_collection)

    # 4. Executar a função real de create_patient, que agora usará o mock
    patient_data = {"name": "João Silva", "age": 30, "email": "joao@example.com"}
    result = await patient_service.create_patient(patient_data)

    # 5. Verificar o resultado
    assert "name" in result
    assert result["name"] == "João Silva"
    assert "_id" in result

@pytest.mark.asyncio
async def test_get_patient_by_id(monkeypatch):
    """
    Testa a obtenção de um paciente pelo ID.
    """
    class MockCollection:
        async def find_one(self, *args, **kwargs):
            # Simula encontrar um paciente no banco
            return {
                "_id": ObjectId(),
                "name": "Maria Souza",
                "age": 25,
                "email": "maria@example.com"
            }

    def mock_get_collection(name: str):
        return MockCollection()

    monkeypatch.setattr(patient_service, "get_collection", mock_get_collection)

    # Chama a função real
    patient_id = ObjectId()
    result = await patient_service.get_patient_by_id(patient_id)
    assert result is not None
    assert result["name"] == "Maria Souza"

@pytest.mark.asyncio
async def test_update_patient(monkeypatch):
    """
    Testa a atualização de um paciente.
    """
    class MockCollection:
        async def update_one(self, *args, **kwargs):
            # Normalmente retorna algo como MatchedCount, ModifiedCount
            return type("UpdateResult", (), {"matched_count": 1, "modified_count": 1})

        async def find_one(self, *args, **kwargs):
            # Simula o documento atualizado
            return {
                "_id": ObjectId(),
                "name": "Carlos Lima",
                "age": 41,
                "email": "carlos@example.com"
            }

    def mock_get_collection(name: str):
        return MockCollection()

    monkeypatch.setattr(patient_service, "get_collection", mock_get_collection)

    patient_id = ObjectId()
    update_data = {"age": 41}
    updated_patient = await patient_service.update_patient(patient_id, update_data)

    assert updated_patient is not None
    assert updated_patient["age"] == 41

@pytest.mark.asyncio
async def test_delete_patient(monkeypatch):
    """
    Testa a deleção de um paciente.
    """
    class MockCollection:
        async def delete_one(self, *args, **kwargs):
            return type("DeleteResult", (), {"deleted_count": 1})

    def mock_get_collection(name: str):
        return MockCollection()

    monkeypatch.setattr(patient_service, "get_collection", mock_get_collection)

    patient_id = ObjectId()
    result = await patient_service.delete_patient(patient_id)
    assert result is True

import pytest
import asyncio
from motor.motor_asyncio import AsyncIOMotorClient

@pytest.fixture(scope="session")
def event_loop():
    """
    Cria um loop de eventos para toda a sessão de testes e o fecha no final.
    """
    loop = asyncio.new_event_loop()
    yield loop
    loop.close()

@pytest.fixture(scope="session")
def test_db(event_loop):
    """
    Conecta ao MongoDB usando o loop de sessão.
    Faz drop da base apenas ao final de todos os testes.
    """
    client = AsyncIOMotorClient("mongodb://localhost:27017", io_loop=event_loop)
    db = client["test_db"]
    yield db
    client.drop_database("test_db")

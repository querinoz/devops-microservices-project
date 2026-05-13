from unittest.mock import patch

import pytest
from app import app

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_health_endpoint(client):
    """Test that the health check returns 200"""
    res = client.get('/health')
    assert res.status_code == 200
    assert res.json['status'] == 'UP'

def test_user_products_happy_path(client):
    """Service B is mocked so we always assert a successful cross-service response."""
    mock_payload = {"success": True, "data": [{"id": 1, "name": "Item"}]}
    with patch("app.requests.get") as mock_get:
        mock_resp = mock_get.return_value
        mock_resp.status_code = 200
        mock_resp.json.return_value = mock_payload
        mock_resp.raise_for_status = lambda: None
        res = client.get("/api/users/1/products")
    assert res.status_code == 200
    body = res.get_json()
    assert body["user"]["id"] == 1
    assert body["products"] == mock_payload["data"]


def test_user_products_when_service_b_fails(client):
    """Errors surface as 503 when the downstream call fails."""
    with patch("app.requests.get", side_effect=RuntimeError("connection refused")):
        res = client.get("/api/users/1/products")
    assert res.status_code == 503
    assert "error" in res.get_json()
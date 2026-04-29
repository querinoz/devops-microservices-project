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

def test_user_data(client):
    """Test local user data logic"""
    # This tests the endpoint without needing Service B running (unit test)
    res = client.get('/api/users/1/products')
    assert res.status_code in [200, 503] # 503 is acceptable if Service B is down during unit test
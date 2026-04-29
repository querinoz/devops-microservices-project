"""
Unit and Integration Tests for Service B
"""
import pytest
import json
import sys
import os

# Add parent directory to path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app import app

@pytest.fixture
def client():
    """Create test client"""
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

class TestHealthEndpoints:
    """Test health check endpoints"""
    
    def test_home_endpoint(self, client):
        """Test home endpoint returns healthy status"""
        response = client.get('/')
        assert response.status_code == 200
        data = json.loads(response.data)
        assert data['status'] == 'healthy'
        assert data['service'] == 'Service B - Product API'
    
    def test_health_endpoint(self, client):
        """Test health endpoint"""
        response = client.get('/health')
        assert response.status_code == 200
        data = json.loads(response.data)
        assert data['status'] == 'UP'
        assert data['service'] == 'service-b'

class TestProductEndpoints:
    """Test product management endpoints"""
    
    def test_get_all_products(self, client):
        """Test GET /api/products returns all products"""
        response = client.get('/api/products')
        assert response.status_code == 200
        data = json.loads(response.data)
        assert data['success'] is True
        assert 'data' in data
        assert len(data['data']) > 0
        assert data['count'] == len(data['data'])
    
    def test_get_products_by_category(self, client):
        """Test GET /api/products with category filter"""
        response = client.get('/api/products?category=Electronics')
        assert response.status_code == 200
        data = json.loads(response.data)
        assert data['success'] is True
        assert 'filter' in data
        assert data['filter']['category'] == 'Electronics'
        for product in data['data']:
            assert product['category'] == 'Electronics'
    
    def test_get_product_by_id_success(self, client):
        """Test GET /api/products/<id> with valid ID"""
        response = client.get('/api/products/1')
        assert response.status_code == 200
        data = json.loads(response.data)
        assert data['success'] is True
        assert data['data']['id'] == 1
        assert 'name' in data['data']
        assert 'price' in data['data']
    
    def test_get_product_by_id_not_found(self, client):
        """Test GET /api/products/<id> with invalid ID"""
        response = client.get('/api/products/999')
        assert response.status_code == 404
        data = json.loads(response.data)
        assert data['success'] is False
        assert 'error' in data
    
    def test_create_product_success(self, client):
        """Test POST /api/products with valid data"""
        new_product = {
            'name': 'Test Product',
            'price': 99.99,
            'category': 'Test',
            'stock': 10
        }
        response = client.post(
            '/api/products',
            data=json.dumps(new_product),
            content_type='application/json'
        )
        assert response.status_code == 201
        data = json.loads(response.data)
        assert data['success'] is True
        assert data['data']['name'] == new_product['name']
        assert data['data']['price'] == new_product['price']
    
    def test_create_product_missing_fields(self, client):
        """Test POST /api/products with missing required fields"""
        incomplete_product = {'name': 'Test Product'}
        response = client.post(
            '/api/products',
            data=json.dumps(incomplete_product),
            content_type='application/json'
        )
        assert response.status_code == 400
        data = json.loads(response.data)
        assert data['success'] is False
        assert 'error' in data
    
    def test_update_product_success(self, client):
        """Test PUT /api/products/<id> with valid data"""
        update_data = {
            'name': 'Updated Product',
            'price': 149.99,
            'stock': 20
        }
        response = client.put(
            '/api/products/1',
            data=json.dumps(update_data),
            content_type='application/json'
        )
        assert response.status_code == 200
        data = json.loads(response.data)
        assert data['success'] is True
        assert data['data']['name'] == update_data['name']
    
    def test_update_product_not_found(self, client):
        """Test PUT /api/products/<id> with invalid ID"""
        update_data = {'name': 'Updated Product'}
        response = client.put(
            '/api/products/999',
            data=json.dumps(update_data),
            content_type='application/json'
        )
        assert response.status_code == 404
        data = json.loads(response.data)
        assert data['success'] is False
    
    def test_delete_product_success(self, client):
        """Test DELETE /api/products/<id> with valid ID"""
        response = client.delete('/api/products/1')
        assert response.status_code == 200
        data = json.loads(response.data)
        assert data['success'] is True
        
        # Verify product is deleted
        get_response = client.get('/api/products/1')
        assert get_response.status_code == 404
    
    def test_delete_product_not_found(self, client):
        """Test DELETE /api/products/<id> with invalid ID"""
        response = client.delete('/api/products/999')
        assert response.status_code == 404
        data = json.loads(response.data)
        assert data['success'] is False

class TestUtilityEndpoints:
    """Test utility endpoints"""
    
    def test_get_categories(self, client):
        """Test GET /api/categories"""
        response = client.get('/api/categories')
        assert response.status_code == 200
        data = json.loads(response.data)
        assert data['success'] is True
        assert 'data' in data
        assert isinstance(data['data'], list)
        assert len(data['data']) > 0
    
    def test_get_stats(self, client):
        """Test GET /api/stats"""
        response = client.get('/api/stats')
        assert response.status_code == 200
        data = json.loads(response.data)
        assert data['success'] is True
        assert 'data' in data
        assert 'total_products' in data['data']
        assert 'total_stock' in data['data']
        assert 'categories_count' in data['data']

class TestErrorHandling:
    """Test error handling"""
    
    def test_404_handler(self, client):
        """Test 404 error handler"""
        response = client.get('/api/nonexistent')
        assert response.status_code == 404
        data = json.loads(response.data)
        assert data['success'] is False
        assert 'error' in data

if __name__ == '__main__':
    pytest.main([__file__, '-v', '--cov=app', '--cov-report=html'])

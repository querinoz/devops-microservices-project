"""
Service B - Product API
Provides product catalog endpoints
"""
from flask import Flask, jsonify, request
from flask_cors import CORS
from jaeger_client import Config
from flask_opentracing import FlaskTracing
import logging
import os

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)
CORS(app)

# Jaeger Configuration
def init_jaeger_tracer(service_name='service-b'):
    """Initialize Jaeger tracer for distributed tracing"""
    config = Config(
        config={
            'sampler': {
                'type': 'const',
                'param': 1,
            },
            'logging': True,
            'reporter_batch_size': 1,
        },
        service_name=service_name,
        validate=True,
    )
    return config.initialize_tracer()

# Initialize Jaeger tracer
tracer = init_jaeger_tracer()
tracing = FlaskTracing(tracer, True, app)

# In-memory product database
products_db = [
    {
        "id": 1,
        "name": "Laptop Dell XPS 15",
        "price": 8999.99,
        "category": "Electronics",
        "stock": 15
    },
    {
        "id": 2,
        "name": "Mouse Logitech MX Master",
        "price": 349.90,
        "category": "Accessories",
        "stock": 50
    },
    {
        "id": 3,
        "name": "Teclado Mecânico Keychron K2",
        "price": 599.00,
        "category": "Accessories",
        "stock": 30
    },
    {
        "id": 4,
        "name": "Monitor LG 27 UltraWide",
        "price": 2499.00,
        "category": "Electronics",
        "stock": 8
    },
    {
        "id": 5,
        "name": "Webcam Logitech C920",
        "price": 459.90,
        "category": "Accessories",
        "stock": 25
    }
]

@app.route('/')
def home():
    """Health check endpoint"""
    return jsonify({
        "service": "Service B - Product API",
        "status": "healthy",
        "version": "1.0.0"
    }), 200

@app.route('/health')
def health():
    """Detailed health check"""
    return jsonify({
        "status": "UP",
        "service": "service-b",
        "port": 8002
    }), 200

@app.route('/api/products', methods=['GET'])
def get_products():
    """Get all products with optional filtering"""
    logger.info("Fetching all products")
    with tracer.start_span('get-products') as span:
        span.set_tag('http.method', 'GET')
        span.set_tag('http.url', '/api/products')
        
        # Optional filtering by category
        category = request.args.get('category')
        if category:
            filtered_products = [p for p in products_db if p['category'].lower() == category.lower()]
            span.set_tag('filter.category', category)
            return jsonify({
                "success": True,
                "data": filtered_products,
                "count": len(filtered_products),
                "filter": {"category": category}
            }), 200
        
        return jsonify({
            "success": True,
            "data": products_db,
            "count": len(products_db)
        }), 200

@app.route('/api/products/<int:product_id>', methods=['GET'])
def get_product(product_id):
    """Get product by ID"""
    logger.info(f"Fetching product with ID: {product_id}")
    with tracer.start_span('get-product-by-id') as span:
        span.set_tag('product.id', product_id)
        product = next((p for p in products_db if p["id"] == product_id), None)
        if product:
            return jsonify({
                "success": True,
                "data": product
            }), 200
        else:
            span.set_tag('error', True)
            return jsonify({
                "success": False,
                "error": "Product not found"
            }), 404

@app.route('/api/products', methods=['POST'])
def create_product():
    """Create a new product"""
    logger.info("Creating new product")
    with tracer.start_span('create-product') as span:
        data = request.get_json()
        
        required_fields = ['name', 'price', 'category']
        if not data or not all(field in data for field in required_fields):
            span.set_tag('error', True)
            return jsonify({
                "success": False,
                "error": f"Missing required fields: {', '.join(required_fields)}"
            }), 400
        
        new_id = max([p["id"] for p in products_db]) + 1 if products_db else 1
        new_product = {
            "id": new_id,
            "name": data['name'],
            "price": float(data['price']),
            "category": data['category'],
            "stock": data.get('stock', 0)
        }
        products_db.append(new_product)
        
        span.set_tag('product.id', new_id)
        return jsonify({
            "success": True,
            "data": new_product,
            "message": "Product created successfully"
        }), 201

@app.route('/api/products/<int:product_id>', methods=['PUT'])
def update_product(product_id):
    """Update an existing product"""
    logger.info(f"Updating product with ID: {product_id}")
    with tracer.start_span('update-product') as span:
        span.set_tag('product.id', product_id)
        
        product = next((p for p in products_db if p["id"] == product_id), None)
        if not product:
            span.set_tag('error', True)
            return jsonify({
                "success": False,
                "error": "Product not found"
            }), 404
        
        data = request.get_json()
        if 'name' in data:
            product['name'] = data['name']
        if 'price' in data:
            product['price'] = float(data['price'])
        if 'category' in data:
            product['category'] = data['category']
        if 'stock' in data:
            product['stock'] = int(data['stock'])
        
        return jsonify({
            "success": True,
            "data": product,
            "message": "Product updated successfully"
        }), 200

@app.route('/api/products/<int:product_id>', methods=['DELETE'])
def delete_product(product_id):
    """Delete a product"""
    logger.info(f"Deleting product with ID: {product_id}")
    with tracer.start_span('delete-product') as span:
        span.set_tag('product.id', product_id)
        
        global products_db
        initial_length = len(products_db)
        products_db = [p for p in products_db if p["id"] != product_id]
        
        if len(products_db) < initial_length:
            return jsonify({
                "success": True,
                "message": "Product deleted successfully"
            }), 200
        else:
            span.set_tag('error', True)
            return jsonify({
                "success": False,
                "error": "Product not found"
            }), 404

@app.route('/api/categories', methods=['GET'])
def get_categories():
    """Get all unique product categories"""
    logger.info("Fetching all categories")
    with tracer.start_span('get-categories') as span:
        categories = list(set([p['category'] for p in products_db]))
        return jsonify({
            "success": True,
            "data": categories,
            "count": len(categories)
        }), 200

@app.route('/api/stats', methods=['GET'])
def get_stats():
    """Get product statistics"""
    logger.info("Fetching product statistics")
    with tracer.start_span('get-stats') as span:
        total_products = len(products_db)
        total_stock = sum([p['stock'] for p in products_db])
        categories = list(set([p['category'] for p in products_db]))
        
        return jsonify({
            "success": True,
            "data": {
                "total_products": total_products,
                "total_stock": total_stock,
                "categories_count": len(categories),
                "categories": categories
            }
        }), 200

@app.errorhandler(404)
def not_found(error):
    """Handle 404 errors"""
    return jsonify({
        "success": False,
        "error": "Endpoint not found"
    }), 404

@app.errorhandler(500)
def internal_error(error):
    """Handle 500 errors"""
    logger.error(f"Internal error: {str(error)}")
    return jsonify({
        "success": False,
        "error": "Internal server error"
    }), 500

if __name__ == '__main__':
    port = int(os.getenv('PORT', 8002))
    logger.info(f"Starting Service B on port {port}")
    app.run(host='0.0.0.0', port=port, debug=False)

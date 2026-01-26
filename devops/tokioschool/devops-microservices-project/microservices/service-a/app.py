from flask import Flask, jsonify, request
from flask_cors import CORS
from jaeger_client import Config
from flask_opentracing import FlaskTracing
import requests
import os

app = Flask(__name__)
CORS(app)

def init_tracer(service):
    config = Config(
        config={'sampler': {'type': 'const', 'param': 1}, 'logging': True},
        service_name=service,
        validate=True,
    )
    return config.initialize_tracer()

tracer = init_tracer('service-a')
tracing = FlaskTracing(tracer, True, app)

SERVICE_B_URL = os.getenv('SERVICE_B_URL', 'http://service-b:8002')

users_db = [{"id": 1, "name": "Alice Silva", "role": "admin"}]

@app.route('/health')
def health():
    return jsonify({"status": "UP", "service": "service-a"}), 200

@app.route('/api/users/1/products')
def get_user_products():
    with tracer.start_span('call-service-b') as span:
        try:
            response = requests.get(f"{SERVICE_B_URL}/api/products", timeout=5)
            return jsonify({
                "user": users_db[0],
                "products": response.json().get("data", [])
            }), 200
        except Exception as e:
            return jsonify({"error": str(e)}), 503

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8001)
# API Request Examples

Este arquivo contém exemplos práticos de requisições para testar as APIs.

## Service A - User API (Port 8001)

### 1. Health Check
```bash
curl http://localhost:8001/health
```

**Resposta esperada:**
```json
{
  "status": "UP",
  "service": "service-a",
  "port": 8001
}
```

---

### 2. Listar Todos os Usuários
```bash
curl http://localhost:8001/api/users
```

**Resposta esperada:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Alice Silva",
      "email": "alice@example.com",
      "role": "admin"
    },
    {
      "id": 2,
      "name": "Bob Santos",
      "email": "bob@example.com",
      "role": "user"
    }
  ],
  "count": 2
}
```

---

### 3. Buscar Usuário por ID
```bash
curl http://localhost:8001/api/users/1
```

---

### 4. Criar Novo Usuário
```bash
curl -X POST http://localhost:8001/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Maria Oliveira",
    "email": "maria@example.com",
    "role": "user"
  }'
```

**Resposta esperada:**
```json
{
  "success": true,
  "data": {
    "id": 4,
    "name": "Maria Oliveira",
    "email": "maria@example.com",
    "role": "user"
  },
  "message": "User created successfully"
}
```

---

### 5. Buscar Produtos de um Usuário (Inter-Service Call)
```bash
curl http://localhost:8001/api/users/1/products
```

**Resposta esperada:**
```json
{
  "success": true,
  "user": {
    "id": 1,
    "name": "Alice Silva",
    "email": "alice@example.com",
    "role": "admin"
  },
  "products": [
    {
      "id": 1,
      "name": "Laptop Dell XPS 15",
      "price": 8999.99,
      "category": "Electronics",
      "stock": 15
    }
  ]
}
```

---

### 6. Testar Conexão com Service B
```bash
curl http://localhost:8001/api/test-connection
```

---

## Service B - Product API (Port 8002)

### 1. Health Check
```bash
curl http://localhost:8002/health
```

---

### 2. Listar Todos os Produtos
```bash
curl http://localhost:8002/api/products
```

---

### 3. Listar Produtos por Categoria
```bash
curl "http://localhost:8002/api/products?category=Electronics"
```

---

### 4. Buscar Produto por ID
```bash
curl http://localhost:8002/api/products/1
```

---

### 5. Criar Novo Produto
```bash
curl -X POST http://localhost:8002/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Mouse Gamer RGB",
    "price": 249.90,
    "category": "Accessories",
    "stock": 40
  }'
```

---

### 6. Atualizar Produto
```bash
curl -X PUT http://localhost:8002/api/products/1 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Laptop Dell XPS 15 - Updated",
    "price": 7999.99,
    "stock": 20
  }'
```

---

### 7. Deletar Produto
```bash
curl -X DELETE http://localhost:8002/api/products/5
```

---

### 8. Listar Categorias
```bash
curl http://localhost:8002/api/categories
```

**Resposta esperada:**
```json
{
  "success": true,
  "data": [
    "Electronics",
    "Accessories"
  ],
  "count": 2
}
```

---

### 9. Obter Estatísticas
```bash
curl http://localhost:8002/api/stats
```

**Resposta esperada:**
```json
{
  "success": true,
  "data": {
    "total_products": 5,
    "total_stock": 128,
    "categories_count": 2,
    "categories": ["Electronics", "Accessories"]
  }
}
```

---

## Testes de Integração

### Fluxo Completo: Criar Usuário e Buscar seus Produtos

**1. Criar usuário:**
```bash
USER_RESPONSE=$(curl -s -X POST http://localhost:8001/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "role": "user"
  }')

USER_ID=$(echo $USER_RESPONSE | jq -r '.data.id')
echo "Created user with ID: $USER_ID"
```

**2. Buscar produtos do usuário:**
```bash
curl http://localhost:8001/api/users/$USER_ID/products
```

---

## Testes com HTTPie (Alternativa mais legível)

Se você tiver o HTTPie instalado (`pip install httpie`):

### Service A
```bash
# GET
http GET :8001/api/users

# POST
http POST :8001/api/users name="João Silva" email="joao@example.com" role="user"
```

### Service B
```bash
# GET
http GET :8002/api/products

# POST
http POST :8002/api/products name="Produto Teste" price:=99.99 category="Test" stock:=10

# PUT
http PUT :8002/api/products/1 price:=8499.99

# DELETE
http DELETE :8002/api/products/5
```

---

## Testes de Performance com Apache Bench

### Teste de carga no Service A
```bash
ab -n 1000 -c 10 http://localhost:8001/api/users
```

### Teste de carga no Service B
```bash
ab -n 1000 -c 10 http://localhost:8002/api/products
```

**Parâmetros:**
- `-n 1000`: Total de 1000 requisições
- `-c 10`: 10 requisições concorrentes

---

## Monitoramento com Jaeger

Após fazer algumas requisições, acesse:
- **Jaeger UI:** http://localhost:16686

**Como usar:**
1. Selecione o serviço (service-a ou service-b)
2. Clique em "Find Traces"
3. Explore os traces para ver:
   - Latência de cada operação
   - Comunicação entre serviços
   - Erros capturados

---

## Scripts de Teste Automatizado

### Bash Script para Teste Completo
```bash
#!/bin/bash

echo "Testing Service A..."
curl -f http://localhost:8001/health || exit 1

echo "Testing Service B..."
curl -f http://localhost:8002/health || exit 1

echo "Testing inter-service communication..."
curl -f http://localhost:8001/api/test-connection || exit 1

echo "All tests passed! ✅"
```

Salve como `test-api.sh` e execute:
```bash
chmod +x test-api.sh
./test-api.sh
```

---

## Exportar Collection para Postman/Insomnia

Você pode importar os exemplos acima no Postman ou Insomnia criando uma collection com todos os endpoints.

### Estrutura Sugerida:
```
DevOps Microservices
├── Service A
│   ├── Health Check
│   ├── List Users
│   ├── Get User by ID
│   ├── Create User
│   └── Get User Products
└── Service B
    ├── Health Check
    ├── List Products
    ├── Get Product by ID
    ├── Create Product
    ├── Update Product
    ├── Delete Product
    ├── List Categories
    └── Get Stats
```

---

## Troubleshooting

### Erro: Connection Refused
```bash
# Verificar se os serviços estão rodando
docker-compose ps

# Ver logs
docker-compose logs service-a
docker-compose logs service-b
```

### Erro: Service B Unavailable
```bash
# Testar conectividade entre containers
docker exec service-a ping service-b

# Verificar network
docker network inspect microservices-network
```

---

**Happy Testing! 🚀**

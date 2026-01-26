# Quick Start Guide - DevOps Microservices Project

Este guia rápido vai te ajudar a ter o projeto rodando em minutos!

## 🚀 Início Rápido (3 minutos)

### Passo 1: Clone o Repositório
```bash
git clone <seu-repositorio>
cd devops-microservices-project
```

### Passo 2: Execute o Setup Automático
```bash
chmod +x setup.sh
./setup.sh
```

Pronto! Os serviços já estão rodando. 🎉

### Passo 3: Teste os Serviços

**Teste Service A:**
```bash
curl http://localhost:8001/health
curl http://localhost:8001/api/users
```

**Teste Service B:**
```bash
curl http://localhost:8002/health
curl http://localhost:8002/api/products
```

**Acesse Jaeger UI:**
Abra no navegador: http://localhost:16686

---

## 🧪 Executar Testes

### Opção 1: Script Automatizado (Recomendado)
```bash
./run-tests.sh
```

### Opção 2: Manual
```bash
# Service A
cd microservices/service-a
source venv/bin/activate
pytest test_app.py -v --cov=app

# Service B
cd microservices/service-b
source venv/bin/activate
pytest test_app.py -v --cov=app
```

---

## 📊 Ver Logs

```bash
# Todos os serviços
docker-compose logs -f

# Service A apenas
docker-compose logs -f service-a

# Service B apenas
docker-compose logs -f service-b
```

---

## 🛑 Parar os Serviços

```bash
docker-compose down
```

---

## 🔄 Reiniciar os Serviços

```bash
docker-compose restart
```

---

## 🧹 Limpar Tudo

```bash
docker-compose down -v
docker system prune -a
```

---

## 📝 Comandos Úteis

### Verificar Status dos Containers
```bash
docker-compose ps
```

### Ver Recursos Utilizados
```bash
docker stats
```

### Executar Comando em um Container
```bash
docker exec -it service-a bash
docker exec -it service-b bash
```

### Rebuild Completo
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

---

## 🔍 Endpoints Principais

### Service A (User API)
- Health: `GET http://localhost:8001/health`
- Listar usuários: `GET http://localhost:8001/api/users`
- Buscar usuário: `GET http://localhost:8001/api/users/1`
- Criar usuário: `POST http://localhost:8001/api/users`
- Produtos do usuário: `GET http://localhost:8001/api/users/1/products`

### Service B (Product API)
- Health: `GET http://localhost:8002/health`
- Listar produtos: `GET http://localhost:8002/api/products`
- Buscar produto: `GET http://localhost:8002/api/products/1`
- Criar produto: `POST http://localhost:8002/api/products`
- Categorias: `GET http://localhost:8002/api/categories`
- Estatísticas: `GET http://localhost:8002/api/stats`

---

## 🐛 Problemas Comuns

### Porta já em uso
```bash
# Linux/Mac
lsof -i :8001
lsof -i :8002

# Matar processo
kill -9 <PID>
```

### Container não inicia
```bash
# Ver logs detalhados
docker-compose logs service-a
docker-compose logs service-b

# Rebuild
docker-compose up -d --build
```

### Erro ao executar testes
```bash
# Verificar ambiente virtual
cd microservices/service-a
ls -la venv/

# Se não existir, criar
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

---

## 📚 Próximos Passos

1. ✅ Ler o [README.md](README.md) completo
2. ✅ Explorar o diagrama em `docs/AAAAMMDD-HLD-ProjetoFinal-DevOps.drawio`
3. ✅ Configurar Jenkins para CI/CD
4. ✅ Explorar Jaeger UI para ver traces

---

## 💡 Dicas

- Use `docker-compose -f docker-compose.dev.yml up` para modo desenvolvimento com hot-reload
- Execute testes antes de cada commit
- Monitore o Jaeger para identificar gargalos de performance
- Mantenha os ambientes isolados (DEV, STG, PRD)

---

**Divirta-se construindo! 🚀**

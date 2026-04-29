# DevOps Microservices Project — CI/CD Pipeline
## Projeto Final de Conclusão de Curso · DevOps Engineering · Tokio School · 2026

![Arquitetura do Sistema](docs/20260429-HLD-ProjetoFinal-DevOps.drawio.png)

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen)]()
[![Coverage Service A](https://img.shields.io/badge/coverage%20A-90%25-brightgreen)]()
[![Coverage Service B](https://img.shields.io/badge/coverage%20B-95%25-brightgreen)]()
[![Docker](https://img.shields.io/badge/docker-WSL2-blue)]()
[![Python](https://img.shields.io/badge/python-3.11-blue)]()
[![Jenkins](https://img.shields.io/badge/pipeline-DEV--STG--PRD-orange)]()
[![License](https://img.shields.io/badge/license-MIT-green)]()

---

## 📋 Índice

1. [Visão Geral](#-visão-geral)
2. [Arquitetura](#-arquitetura)
3. [Tecnologias Utilizadas](#-tecnologias-utilizadas)
4. [Pré-requisitos](#-pré-requisitos)
5. [Instalação e Configuração](#-instalação-e-configuração)
6. [Pipeline CI/CD](#-pipeline-cicd)
7. [Ambientes](#-ambientes)
8. [Testes e Qualidade](#-testes-e-qualidade)
9. [Monitoramento](#-monitoramento)
10. [Documentação da API](#-documentação-da-api)
11. [Troubleshooting](#-troubleshooting)
12. [Paragem e Limpeza do Ambiente](#-paragem-e-limpeza-do-ambiente)
13. [Conclusão](#-conclusão)

---

## 🎯 Visão Geral

Este projeto implementa uma **arquitetura completa de microsserviços com pipeline CI/CD automatizado**, desenvolvido como Projeto Final do Curso de DevOps Engineering. O sistema demonstra boas práticas de desenvolvimento, testes, deploy e monitoramento em ambientes containerizados, com foco em observabilidade, testabilidade e resiliência do deploy em múltiplos ambientes (DEV, STG, PRD).

### Objetivos do Projeto

✅ Implementar arquitetura de microsserviços escalável  
✅ Automatizar processo de CI/CD com Jenkins  
✅ Containerizar aplicações com Docker (nativo via WSL2)  
✅ Implementar testes automatizados (Unit, Integration, E2E)  
✅ Monitorar aplicações com distributed tracing (Jaeger)  
✅ Gerir ambientes isolados (DEV, STG, PRD)  
✅ Seguir best practices de DevOps e SRE  

---

## 🏗️ Arquitetura

O diagrama completo da infraestrutura, fluxo CI/CD e comunicação entre serviços está disponível em:

**📁 `docs/20260429-HLD-ProjetoFinal-DevOps.drawio`**

Para visualizar, aceda a [draw.io](https://app.diagrams.net/) e abra o ficheiro acima.

### Decisão de Design

Optou-se pelo uso de **Docker Engine nativo via WSL2** em vez do Docker Desktop para otimizar o consumo de recursos e simular um ambiente de produção Linux real.

### Componentes Principais

#### 🔷 Service A — User API
- **Porta:** 8001
- **Responsabilidade:** Gestão de utilizadores e orquestração de chamadas inter-serviços
- **Endpoints:** CRUD de utilizadores, integração com Service B
- **Tecnologia:** Flask + Python 3.11

#### 🔷 Service B — Product API
- **Porta:** 8002
- **Responsabilidade:** Catálogo de produtos e lógica de inventário
- **Endpoints:** CRUD de produtos, categorias e estatísticas
- **Tecnologia:** Flask + Python 3.11

#### 🔷 Jaeger — Distributed Tracing
- **Portas:** 16686 (UI), 6831 (Agent)
- **Responsabilidade:** Rastreamento distribuído de transações entre microsserviços
- **Funcionalidades:** Error tracking, análise de latência, monitoramento de performance

#### 🔷 Jenkins — CI/CD
- **Responsabilidade:** Automação de build, test e deploy
- **Ambientes:** DEV, STG, PRD
- **Integração:** GitHub, Docker, frameworks de testes

---

## 🛠️ Tecnologias Utilizadas

| Camada | Tecnologia | Versão |
|--------|-----------|--------|
| Linguagem | Python | 3.11 |
| Framework Web | Flask | 3.0.0 |
| WSGI Server | Gunicorn | 21.2.0 |
| Containerização | Docker + Docker Compose | 29.4.1 / v5.1.3 |
| CI/CD | Jenkins | 2.400+ |
| Controlo de Versão | GitHub | — |
| Testes | pytest + pytest-flask + pytest-cov | 7.4.3+ |
| Tracing | Jaeger | 1.51 |
| Instrumentação | Flask-OpenTracing | 1.1.0 |

### Dependências Python (requirements.txt)

```
Flask==3.0.0
flask-cors==4.0.0
flask-opentracing==1.1.0
jaeger-client==4.8.0
requests==2.31.0
pytest==7.4.3
pytest-flask==1.3.0
pytest-cov==4.1.0
gunicorn==21.2.0
```

---

## 📦 Pré-requisitos

### Software Necessário

| Software | Versão Mínima | Verificar |
|----------|---------------|-----------|
| Python | 3.11+ | `python --version` |
| Docker | 20.10+ | `docker --version` |
| Docker Compose | 2.0+ | `docker compose version` |
| Git | 2.30+ | `git --version` |
| Jenkins | 2.400+ | Acesso via browser |

### Recursos do Sistema

- **CPU:** 2+ cores · **RAM:** 4 GB mínimo (8 GB recomendado) · **Disco:** 10 GB livres
- **SO:** Linux, macOS, ou Windows com WSL2

---

## 🚀 Instalação e Configuração

### 1. Clonar o Repositório

```bash
git clone https://github.com/your-username/devops-microservices-project.git
cd devops-microservices-project
```

### 2. Configurar Ambiente Python (por serviço)

```bash
# Service A
cd microservices/service-a
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt

# Service B
cd ../service-b
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt
```

### 3. Build e Arranque dos Containers

```bash
# A partir da raiz do projeto
docker compose up -d --build

# Verificar estado
docker compose ps
```

### 4. Validar Serviços

```bash
curl http://localhost:8001/health   # Service A
curl http://localhost:8002/health   # Service B
# Jaeger UI: http://localhost:16686
```

**Output esperado:**
```json
// Service A
{ "service": "service-a", "status": "UP" }

// Service B
{ "port": 8002, "service": "service-b", "status": "UP" }
```

---

## 🔄 Pipeline CI/CD

### Configuração do Jenkins

```bash
# Iniciar Jenkins via Docker
docker run -d -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  --name jenkins jenkins/jenkins:lts
```

Após o arranque:
1. Aceder a `http://localhost:8080`
2. Obter senha inicial: `docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword`
3. Instalar plugins sugeridos + **Docker Pipeline**, **GitHub Integration**, **JUnit**, **HTML Publisher**
4. Criar job do tipo Pipeline apontando para o `Jenkinsfile` no repositório

### Estratégia de Branches

```
main    → PRD (aprovação manual dupla)
develop → STG (aprovação manual)
feature/* → DEV (deploy automático)
```

### Stages do Pipeline

| # | Stage | Descrição |
|---|-------|-----------|
| 1 | Checkout | Clona o código do repositório |
| 2 | Setup Python Environment | Cria virtual environment |
| 3 | Install Dependencies | `pip install` em ambos os serviços |
| 4 | Unit Tests | `pytest` com relatórios JUnit e coverage HTML |
| 5 | Build Docker Images | `service-a:${BUILD_NUMBER}` e `service-b:${BUILD_NUMBER}` |
| 6 | Deploy to DEV | Deploy automático + health checks |
| 7 | Integration Tests — DEV | Testa endpoints e comunicação inter-serviços |
| 8 | Deploy to STG *(develop)* | Aprovação manual · ambiente isolado |
| 9 | E2E Tests — STG | Fluxos completos de utilizador |
| 10 | Deploy to PRD *(main)* | Aprovação manual dupla · zero-downtime |
| 11 | Smoke Tests — PRD | Validação de disponibilidade crítica |
| 12 | Cleanup | Remove imagens antigas, limpa workspace |

---

## 🌍 Ambientes

| Característica | DEV | STG | PRD |
|----------------|-----|-----|-----|
| Deploy | Automático | Manual (aprovação) | Manual (dupla aprovação) |
| Testes | Unit + Integration | E2E + Load | Smoke Tests |
| Dados | Mock/Seed | Semelhante a PRD | Produção real |
| Monitoramento | Básico | Completo | 24/7 com alertas |
| HTTPS | Não | Opcional | Obrigatório |

**Acessos locais:**
- Service A: `http://localhost:8001`
- Service B: `http://localhost:8002`
- Jaeger UI: `http://localhost:16686`

---

## 🧪 Testes e Qualidade

### Estrutura de Testes

```
microservices/
├── service-a/test_app.py   # TestHealthEndpoints, TestUserEndpoints, TestErrorHandling
└── service-b/test_app.py   # TestHealthEndpoints, TestProductEndpoints, TestUtilityEndpoints, TestErrorHandling
```

### Executar Testes (dentro dos containers)

```bash
# Service A
docker exec dev-service-a pytest -v --cov=app

# Service B
docker exec dev-service-b pytest -v --cov=app
```

### Resultados Obtidos

**Service A — 2 testes · Cobertura: 90%**

```
test_app.py::test_health_endpoint PASSED                                 [ 50%]
test_app.py::test_user_data PASSED                                       [100%]
========================= 2 passed, 1 warning in 0.99s =========================

Name     Stmts   Miss  Cover
----------------------------
app.py      31      3    90%
```

**Service B — 15 testes · Cobertura: 95%**

```
test_app.py::TestHealthEndpoints::test_health_endpoint PASSED            [ 13%]
test_app.py::TestProductEndpoints::test_get_all_products PASSED          [ 20%]
test_app.py::TestProductEndpoints::test_get_products_by_category PASSED  [ 26%]
test_app.py::TestProductEndpoints::test_get_product_by_id_success PASSED [ 33%]
test_app.py::TestProductEndpoints::test_get_product_by_id_not_found PASSED [ 40%]
test_app.py::TestProductEndpoints::test_create_product_success PASSED    [ 46%]
test_app.py::TestProductEndpoints::test_create_product_missing_fields PASSED [ 53%]
test_app.py::TestProductEndpoints::test_update_product_success PASSED    [ 60%]
test_app.py::TestProductEndpoints::test_update_product_not_found PASSED  [ 66%]
test_app.py::TestProductEndpoints::test_delete_product_success PASSED    [ 73%]
test_app.py::TestProductEndpoints::test_delete_product_not_found PASSED  [ 80%]
test_app.py::TestUtilityEndpoints::test_get_categories PASSED            [ 86%]
test_app.py::TestUtilityEndpoints::test_get_stats PASSED                 [ 93%]
test_app.py::TestErrorHandling::test_404_handler PASSED                  [100%]
======================== 15 passed, 1 warning in 0.80s ========================

Name     Stmts   Miss  Cover
----------------------------
app.py     113      6    95%
```

> **Target de cobertura:** ≥ 80% · **Resultado:** ✅ Superado em ambos os serviços

### Teste de Integração (End-to-End)

Validação da comunicação real entre Service A e Service B via rede interna Docker:

```bash
curl http://localhost:8001/api/users/1/products
```

```json
{
  "user": { "id": 1, "name": "Alice Silva", "role": "admin" },
  "products": [
    { "id": 1, "name": "Laptop Dell XPS 15",          "price": 8999.99, "category": "Electronics",  "stock": 15 },
    { "id": 2, "name": "Mouse Logitech MX Master",     "price": 349.90,  "category": "Accessories",  "stock": 50 },
    { "id": 3, "name": "Teclado Mecânico Keychron K2", "price": 599.00,  "category": "Accessories",  "stock": 30 },
    { "id": 4, "name": "Monitor LG 27 UltraWide",      "price": 2499.00, "category": "Electronics",  "stock": 8  },
    { "id": 5, "name": "Webcam Logitech C920",         "price": 459.90,  "category": "Accessories",  "stock": 25 }
  ]
}
```

✅ O Service A consumiu os dados do Service B com sucesso via rede interna do Docker.

---

## 📊 Monitoramento

### Jaeger — Distributed Tracing

Acesso à UI: `http://localhost:16686`

Após as chamadas de API, os traces são propagados corretamente do Service A para o Service B, permitindo visualizar a latência e o fluxo completo da requisição.

**Exemplo de trace — Fluxo normal:**
```
GET /api/users/1/products
├── Service A: get-user-products (50ms)
│   ├── Database query (10ms)
│   └── Call Service B (35ms)
│       └── Service B: get-products (30ms)
└── Total: 95ms
```

**Exemplo de trace — Fluxo com erro:**
```
GET /api/users/999/products
├── Service A: get-user-products (5ms)
│   └── ERROR: User not found (404)
└── Total: 5ms
```

**Métricas disponíveis:** Request Rate · Error Rate · Latency P50/P95/P99 · Throughput por endpoint

---

## 📚 Documentação da API

### Service A — User API · `http://localhost:8001`

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/health` | Health check |
| GET | `/api/users` | Listar todos os utilizadores |
| GET | `/api/users/{id}` | Buscar utilizador por ID |
| POST | `/api/users` | Criar utilizador |
| GET | `/api/users/{id}/products` | Produtos associados ao utilizador |
| GET | `/api/test-connection` | Testar conectividade com Service B |

**Exemplo — Criar utilizador:**
```http
POST /api/users
Content-Type: application/json

{ "name": "Novo Utilizador", "email": "novo@example.com", "role": "user" }
```
```json
{ "success": true, "data": { ... }, "message": "User created successfully" }
```

### Service B — Product API · `http://localhost:8002`

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/health` | Health check |
| GET | `/api/products` | Listar produtos (suporta `?category=`) |
| GET | `/api/products/{id}` | Buscar produto por ID |
| POST | `/api/products` | Criar produto |
| PUT | `/api/products/{id}` | Atualizar produto |
| DELETE | `/api/products/{id}` | Eliminar produto |
| GET | `/api/categories` | Listar categorias |
| GET | `/api/stats` | Estatísticas do catálogo |

**Exemplo — Estatísticas:**
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

## 🔧 Troubleshooting

### Problemas Reais Enfrentados Durante o Desenvolvimento

**1. Conflito de Binários Docker (CLI Plugin V2)**
- **Problema:** O comando `docker-compose` não era reconhecido — o sistema encontrava-se na transição para Docker Compose V2 (CLI plugin nativo).
- **Solução:** Migração de todos os scripts para `docker compose` (sem hífen), compatível com Docker Engine moderno.

**2. Dependências Corrompidas no WSL2**
- **Problema:** Conflito entre `containerd.io` e pacotes padrão do Ubuntu durante a instalação do Docker Engine.
- **Solução:** Limpeza profunda do repositório de pacotes, instalação manual do Docker Engine oficial com configuração correta do GPG Keyring e do PATH do sistema.

**3. Permissões de Socket Docker**
- **Problema:** O utilizador Jenkins não conseguia aceder ao socket do Docker (`/var/run/docker.sock`).
- **Solução:** `sudo usermod -aG docker $USER` seguido de novo login para aplicar as permissões de grupo.

**4. Dependências de Testes em Falta**
- **Problema:** Erro de importação ao executar `pytest` — módulos como `pytest-flask` e `six` não estavam declarados no `requirements.txt`.
- **Solução:** Atualização dos ficheiros `requirements.txt` em ambos os serviços e recriação dos ambientes virtuais.

**5. Isolamento de Rede entre Containers**
- **Problema:** O Service A tentava resolver `localhost:8002`, sem perceber o isolamento do Docker.
- **Solução:** Criação de uma bridge network (`microservices-network`) no `docker-compose.yml` e configuração da variável `SERVICE_B_URL=http://service-b:8002`.

### Comandos de Diagnóstico Rápido

```bash
# Ver logs de um serviço
docker compose logs service-a

# Verificar portas em uso
lsof -i :8001 && lsof -i :8002

# Testar conectividade entre containers
docker exec dev-service-a ping service-b

# Inspecionar rede
docker network inspect dev-network

# Reconstruir do zero
docker compose down && docker compose up -d --build
```

---

## 🧹 Paragem e Limpeza do Ambiente

Para garantir que não ficam recursos a consumir memória ou portas bloqueadas:

```bash
# Parar e remover containers, redes e volumes
docker compose down -v

# Remover as imagens construídas (opcional, para libertar espaço em disco)
docker rmi service-a:latest service-b:latest
```

---

## 🎓 Conclusão

### Objetivos Alcançados

✅ **Arquitetura de Microsserviços** — Implementada com Flask, Docker e Docker Compose  
✅ **CI/CD Automatizado** — Pipeline completo com Jenkins em 3 ambientes (DEV/STG/PRD)  
✅ **Testes Abrangentes** — Unit, Integration e E2E com cobertura ≥ 90%  
✅ **Observabilidade** — Distributed tracing com Jaeger validado em runtime  
✅ **Documentação** — README completo com evidências reais de execução  

### Aprendizados Principais

1. **DevOps Culture** — Integração efetiva entre desenvolvimento e operações
2. **Automation First** — CI/CD reduz erros humanos e acelera a entrega
3. **Observability** — Monitoramento e tracing são essenciais para diagnóstico em produção
4. **Test Coverage** — Testes automatizados são a rede de segurança do pipeline
5. **Containerization** — Docker garante paridade entre ambientes de desenvolvimento e produção

### Melhorias Futuras

- [ ] Kubernetes para orquestração avançada
- [ ] API Gateway (Kong ou Nginx)
- [ ] Autenticação com OAuth2/JWT
- [ ] Base de dados persistente (PostgreSQL)
- [ ] Logging centralizado (ELK Stack)
- [ ] Métricas com Prometheus + Grafana
- [ ] Service Mesh (Istio)
- [ ] GitOps com ArgoCD

---

### Estrutura Final do Projeto

```
devops-microservices-project/
├── microservices/
│   ├── service-a/
│   │   ├── app.py · test_app.py · Dockerfile · requirements.txt
│   └── service-b/
│       ├── app.py · test_app.py · Dockerfile · requirements.txt
├── infrastructure/
│   ├── docker/ · jenkins/ · monitoring/
├── docs/
│   └── 20260429-HLD-ProjetoFinal-DevOps.drawio
├── docker-compose.yml
├── Jenkinsfile
└── README.md
```

---

**Projeto:** DevOps Microservices — CI/CD Pipeline · **Autor:** [Eduardo Querino] · **Instituição:** Tokio School · **Ano:** 2026  
**Licença:** MIT — Livre para uso como referência académica.
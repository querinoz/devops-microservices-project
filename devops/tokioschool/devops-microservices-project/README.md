# DevOps Microservices Project - CI/CD Pipeline
## Projeto Final de Conclusão de Curso - DevOps

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen)]()
[![Docker](https://img.shields.io/badge/docker-ready-blue)]()
[![Python](https://img.shields.io/badge/python-3.11-blue)]()
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
8. [Testes](#-testes)
9. [Monitoramento](#-monitoramento)
10. [Documentação da API](#-documentação-da-api)
11. [Troubleshooting](#-troubleshooting)
12. [Conclusão](#-conclusão)

---

## 🎯 Visão Geral

Este projeto implementa uma arquitetura completa de **microsserviços com pipeline CI/CD automatizado**, desenvolvido como Projeto Final do curso de DevOps. O sistema demonstra as melhores práticas de desenvolvimento, testes, deploy e monitoramento em ambientes containerizados.

### Objetivos do Projeto

✅ Implementar arquitetura de microsserviços escalável  
✅ Automatizar processo de CI/CD com Jenkins  
✅ Containerizar aplicações com Docker  
✅ Implementar testes automatizados (Unit, Integration, E2E)  
✅ Monitorar aplicações com distributed tracing (Jaeger)  
✅ Gerenciar ambientes isolados (DEV, STG, PRD)  
✅ Seguir best practices de DevOps e SRE  

---

## 🏗 Arquitetura

### Diagrama de Arquitetura

O diagrama completo da arquitetura implementada está disponível no arquivo:

**📁 `docs/AAAAMMDD-HLD-ProjetoFinal-DevOps.drawio`**

Para visualizar:
1. Acesse [draw.io](https://app.diagrams.net/)
2. Abra o arquivo `.drawio` localizado na pasta `docs/`
3. O diagrama mostra toda a infraestrutura, fluxo CI/CD e comunicação entre serviços

### Componentes Principais

#### 🔷 Service A - User API
- **Porta:** 8001
- **Responsabilidade:** Gerenciamento de usuários
- **Endpoints:** CRUD de usuários, integração com Service B
- **Tecnologia:** Flask + Python 3.11

#### 🔷 Service B - Product API
- **Porta:** 8002
- **Responsabilidade:** Catálogo de produtos
- **Endpoints:** CRUD de produtos, estatísticas
- **Tecnologia:** Flask + Python 3.11

#### 🔷 Jaeger - Distributed Tracing
- **Porta:** 16686 (UI), 6831 (Agent)
- **Responsabilidade:** Rastreamento de transações entre microsserviços
- **Funcionalidades:** Error tracking, performance monitoring

#### 🔷 Jenkins CI/CD
- **Responsabilidade:** Automação de build, test e deploy
- **Ambientes:** DEV, STG, PRD
- **Integração:** GitHub, Docker, Testing frameworks

---

## 🛠 Tecnologias Utilizadas

### Backend & APIs
- **Python 3.11** - Linguagem principal
- **Flask 3.0.0** - Framework web
- **Gunicorn** - WSGI server para produção

### Containerização
- **Docker** - Containerização de aplicações
- **Docker Compose** - Orquestração de containers

### CI/CD
- **Jenkins** - Automação de pipeline
- **GitHub** - Controle de versão e source code

### Testes
- **pytest 7.4.3** - Framework de testes
- **pytest-flask** - Testes específicos para Flask
- **pytest-cov** - Code coverage

### Monitoramento
- **Jaeger 1.51** - Distributed tracing
- **Flask-OpenTracing** - Instrumentação de traces

### Bibliotecas Python
```txt
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

| Software | Versão Mínima | Verificar Instalação |
|----------|---------------|----------------------|
| Python | 3.11+ | `python --version` |
| Docker | 20.10+ | `docker --version` |
| Docker Compose | 2.0+ | `docker-compose --version` |
| Git | 2.30+ | `git --version` |
| Jenkins | 2.400+ | Acesso via navegador |

### Recursos do Sistema

- **CPU:** 2+ cores
- **RAM:** 4GB mínimo (8GB recomendado)
- **Disco:** 10GB espaço livre
- **SO:** Linux, macOS, ou Windows com WSL2

---

## 🚀 Instalação e Configuração

### 1. Clone do Repositório

```bash
# Clone o projeto
git clone https://github.com/your-username/devops-microservices-project.git
cd devops-microservices-project
```

### 2. Configuração do GitHub

```bash
# Configure repositório local
git init
git remote add origin https://github.com/your-username/devops-microservices-project.git

# Configure suas credenciais
git config user.name "Seu Nome"
git config user.email "seu@email.com"
```

### 3. Configuração do Ambiente Python

#### Service A

```bash
cd microservices/service-a

# Criar ambiente virtual
python -m venv venv

# Ativar ambiente virtual
# Linux/Mac:
source venv/bin/activate
# Windows:
venv\Scripts\activate

# Instalar dependências
pip install -r requirements.txt
```

#### Service B

```bash
cd microservices/service-b

# Criar ambiente virtual
python -m venv venv

# Ativar ambiente virtual
source venv/bin/activate

# Instalar dependências
pip install -r requirements.txt
```

### 4. Build dos Containers Docker

```bash
# Voltar para raiz do projeto
cd ../../

# Build das imagens
docker build -t service-a:latest ./microservices/service-a
docker build -t service-b:latest ./microservices/service-b

# Verificar imagens criadas
docker images | grep service
```

### 5. Iniciar Aplicação com Docker Compose

```bash
# Iniciar todos os serviços
docker-compose up -d

# Verificar status dos containers
docker-compose ps

# Ver logs
docker-compose logs -f
```

### 6. Verificar Serviços

```bash
# Service A Health Check
curl http://localhost:8001/health

# Service B Health Check
curl http://localhost:8002/health

# Jaeger UI
# Acessar http://localhost:16686 no navegador
```

---

## 🔄 Pipeline CI/CD

### Configuração do Jenkins

#### 1. Instalação do Jenkins

```bash
# Docker (recomendado)
docker run -d -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  --name jenkins \
  jenkins/jenkins:lts
```

#### 2. Configuração Inicial

1. Acesse `http://localhost:8080`
2. Obtenha senha inicial: `docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword`
3. Instale plugins sugeridos
4. Crie usuário admin

#### 3. Plugins Necessários

- **Docker Pipeline**
- **GitHub Integration**
- **Pipeline**
- **JUnit**
- **HTML Publisher**
- **Blue Ocean** (opcional, para UI melhorada)

#### 4. Criar Pipeline Job

1. New Item → Pipeline
2. Configure SCM: GitHub repository
3. Pipeline script from SCM
4. Script Path: `Jenkinsfile`

### Fluxos do Pipeline

#### Branch Strategy

```
main (PRD)
  ↑
develop (STG)
  ↑
feature/* (DEV)
```

### Stages do Pipeline

#### 1️⃣ **Checkout**
```groovy
- Clona código do repositório GitHub
- Verifica branch atual
```

#### 2️⃣ **Setup Python Environment**
```groovy
- Cria virtual environment (venv)
- Atualiza pip
```

#### 3️⃣ **Install Dependencies**
```groovy
- Service A: pip install -r requirements.txt
- Service B: pip install -r requirements.txt
```

#### 4️⃣ **Unit Tests**
```groovy
- Executa pytest em ambos os serviços
- Gera relatórios XML e HTML
- Calcula code coverage
```

**Evidências dos Testes:**
- Relatórios JUnit: `test-results-service-{a,b}.xml`
- Coverage HTML: `htmlcov/index.html`
- Métricas de cobertura em formato XML

#### 5️⃣ **Build Docker Images**
```groovy
- Build service-a:${BUILD_NUMBER}
- Build service-b:${BUILD_NUMBER}
- Tag latest
```

#### 6️⃣ **Deploy to DEV**
```groovy
- docker-compose down (ambiente DEV)
- docker-compose up -d (deploy automático)
- Health checks
```

**Validações DEV:**
- ✅ Containers inicializados
- ✅ Health endpoints respondendo
- ✅ Comunicação entre serviços OK

#### 7️⃣ **Integration Tests - DEV**
```groovy
- Testa endpoints individuais
- Testa comunicação inter-serviços
- Valida respostas JSON
```

#### 8️⃣ **Deploy to STG** *(branch: develop)*
```groovy
- Aprovação manual necessária
- Deploy em ambiente de staging
- Isolamento de dados
```

#### 9️⃣ **E2E Tests - STG**
```groovy
- Testes end-to-end completos
- Fluxos de usuário reais
- Validação de integração completa
```

#### 🔟 **Deploy to PRD** *(branch: main)*
```groovy
- Aprovação manual obrigatória
- Deploy em produção
- Zero-downtime deployment
```

**Evidências PRD:**
- Smoke tests executados
- Monitoramento ativo (Jaeger)
- Logs de deployment

#### 1️⃣1️⃣ **Smoke Tests - PRD**
```groovy
- Validação de serviços críticos
- Verificação de disponibilidade
- Alert em caso de falha
```

#### 1️⃣2️⃣ **Cleanup**
```groovy
- Remove imagens antigas
- Libera recursos
- Limpa workspace
```

---

## 🌍 Ambientes

### DEV - Desenvolvimento

**Objetivo:** Desenvolvimento e testes iniciais

| Característica | Valor |
|----------------|-------|
| Deploy | Automático em cada push |
| Testes | Unit + Integration |
| Dados | Mock/Seed data |
| Monitoramento | Básico |

**Acesso:**
- Service A: http://localhost:8001
- Service B: http://localhost:8002

### STG - Staging

**Objetivo:** Validação pré-produção

| Característica | Valor |
|----------------|-------|
| Deploy | Manual (após aprovação) |
| Testes | E2E + Load Tests |
| Dados | Similaridade com PRD |
| Monitoramento | Completo |

**Acesso:**
- Mesmas portas (ambiente isolado via docker-compose project)

### PRD - Produção

**Objetivo:** Ambiente de produção

| Característica | Valor |
|----------------|-------|
| Deploy | Manual (dupla aprovação) |
| Testes | Smoke tests |
| Dados | Produção real |
| Monitoramento | 24/7 com alertas |
| HTTPS | Obrigatório |

**Segurança PRD:**
- ✅ HTTPS habilitado
- ✅ Rate limiting
- ✅ Authentication/Authorization
- ✅ Secrets management

---

## 🧪 Testes

### Estrutura de Testes

```
microservices/
├── service-a/
│   └── test_app.py          # Tests Service A
└── service-b/
    └── test_app.py          # Tests Service B
```

### Tipos de Testes Implementados

#### 1. **Unit Tests**

**Service A - test_app.py:**
```python
class TestHealthEndpoints
class TestUserEndpoints
class TestServiceIntegration
class TestErrorHandling
```

**Service B - test_app.py:**
```python
class TestHealthEndpoints
class TestProductEndpoints
class TestUtilityEndpoints
class TestErrorHandling
```

#### 2. **Integration Tests**

Testam comunicação entre Service A ↔ Service B:
```bash
# Exemplo de teste de integração
curl http://localhost:8001/api/users/1/products
```

#### 3. **E2E Tests**

Fluxos completos de usuário:
1. Criar usuário em Service A
2. Buscar produtos em Service B
3. Associar produtos ao usuário
4. Validar resposta completa

### Executar Testes Localmente

#### Service A

```bash
cd microservices/service-a
source venv/bin/activate

# Executar todos os testes
pytest test_app.py -v

# Com coverage
pytest test_app.py -v --cov=app --cov-report=html

# Ver relatório
open htmlcov/index.html
```

#### Service B

```bash
cd microservices/service-b
source venv/bin/activate

pytest test_app.py -v --cov=app --cov-report=html
```

### Métricas de Cobertura

**Target de Cobertura:** ≥ 80%

**Evidências:**
- ✅ Test results em formato JUnit XML
- ✅ Coverage reports em HTML
- ✅ Relatórios publicados no Jenkins

### Evidências de Testes

**Ambiente Local:**
```bash
# Service A
microservices/service-a/test-results-service-a.xml
microservices/service-a/htmlcov/

# Service B
microservices/service-b/test-results-service-b.xml
microservices/service-b/htmlcov/
```

**Jenkins:**
- JUnit test results
- HTML coverage reports
- Test trends e histórico

---

## 📊 Monitoramento

### Jaeger - Distributed Tracing

**Acesso:** http://localhost:16686

#### Funcionalidades

1. **Trace Visualization**
   - Visualização completa de requests entre serviços
   - Latência de cada span
   - Identificação de gargalos

2. **Error Tracking**
   - Erros capturados automaticamente
   - Stack traces completos
   - Context de cada erro

3. **Performance Monitoring**
   - Tempo de resposta por endpoint
   - Identificação de serviços lentos
   - Análise de dependências

#### Exemplos de Traces

**Fluxo Normal:**
```
GET /api/users/1/products
├── Service A: get-user-products (50ms)
│   ├── Database query (10ms)
│   └── Call Service B (35ms)
│       └── Service B: get-products (30ms)
│           └── Database query (25ms)
Total: 95ms
```

**Fluxo com Erro:**
```
GET /api/users/999/products
├── Service A: get-user-products (5ms)
│   └── ERROR: User not found
Total: 5ms (404 Error)
```

### Métricas Disponíveis

- **Request Rate:** Requisições por segundo
- **Error Rate:** Taxa de erro (%)
- **Latency:** P50, P95, P99
- **Throughput:** Requests/s por endpoint

---

## 📚 Documentação da API

### Service A - User API

**Base URL:** `http://localhost:8001`

#### Endpoints

##### Health Check
```http
GET /health
Response: 200 OK
{
  "status": "UP",
  "service": "service-a",
  "port": 8001
}
```

##### Listar Usuários
```http
GET /api/users
Response: 200 OK
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Alice Silva",
      "email": "alice@example.com",
      "role": "admin"
    }
  ],
  "count": 3
}
```

##### Buscar Usuário por ID
```http
GET /api/users/{id}
Response: 200 OK / 404 Not Found
{
  "success": true,
  "data": {
    "id": 1,
    "name": "Alice Silva",
    "email": "alice@example.com",
    "role": "admin"
  }
}
```

##### Criar Usuário
```http
POST /api/users
Content-Type: application/json

{
  "name": "Novo Usuário",
  "email": "novo@example.com",
  "role": "user"
}

Response: 201 Created
{
  "success": true,
  "data": { ... },
  "message": "User created successfully"
}
```

##### Buscar Produtos do Usuário
```http
GET /api/users/{id}/products
Response: 200 OK
{
  "success": true,
  "user": { ... },
  "products": [ ... ]
}
```

##### Testar Conexão com Service B
```http
GET /api/test-connection
Response: 200 OK / 503 Service Unavailable
```

### Service B - Product API

**Base URL:** `http://localhost:8002`

#### Endpoints

##### Health Check
```http
GET /health
Response: 200 OK
```

##### Listar Produtos
```http
GET /api/products
GET /api/products?category=Electronics

Response: 200 OK
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Laptop Dell XPS 15",
      "price": 8999.99,
      "category": "Electronics",
      "stock": 15
    }
  ],
  "count": 5
}
```

##### Buscar Produto por ID
```http
GET /api/products/{id}
Response: 200 OK / 404 Not Found
```

##### Criar Produto
```http
POST /api/products
Content-Type: application/json

{
  "name": "Novo Produto",
  "price": 99.99,
  "category": "Test",
  "stock": 10
}

Response: 201 Created
```

##### Atualizar Produto
```http
PUT /api/products/{id}
Content-Type: application/json

{
  "name": "Nome Atualizado",
  "price": 149.99
}

Response: 200 OK
```

##### Deletar Produto
```http
DELETE /api/products/{id}
Response: 200 OK / 404 Not Found
```

##### Listar Categorias
```http
GET /api/categories
Response: 200 OK
```

##### Estatísticas
```http
GET /api/stats
Response: 200 OK
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

### Problemas Comuns

#### 1. Container não inicia

```bash
# Ver logs
docker-compose logs service-a
docker-compose logs service-b

# Recriar containers
docker-compose down
docker-compose up -d --build
```

#### 2. Erro de porta em uso

```bash
# Verificar portas em uso
lsof -i :8001
lsof -i :8002

# Parar processo
kill -9 <PID>
```

#### 3. Testes falhando

```bash
# Verificar ambiente virtual
which python
pip list

# Reinstalar dependências
pip install -r requirements.txt --force-reinstall
```

#### 4. Service B inacessível

```bash
# Verificar network
docker network ls
docker network inspect microservices-network

# Testar conectividade
docker exec service-a ping service-b
```

#### 5. Jaeger não carrega traces

```bash
# Verificar configuração de ambiente
docker-compose logs jaeger

# Reiniciar Jaeger
docker-compose restart jaeger
```

### Comandos Úteis

```bash
# Parar todos os containers
docker-compose down

# Remover volumes
docker-compose down -v

# Rebuild completo
docker-compose build --no-cache

# Ver recursos utilizados
docker stats

# Limpar sistema Docker
docker system prune -a
```

---

## 🎓 Conclusão

### Objetivos Alcançados

✅ **Arquitetura de Microsserviços:** Implementado com sucesso usando Flask e Docker  
✅ **CI/CD Automatizado:** Pipeline completo com Jenkins em 3 ambientes  
✅ **Testes Abrangentes:** Unit, Integration e E2E tests com >80% coverage  
✅ **Containerização:** Docker e Docker Compose para orquestração  
✅ **Monitoramento:** Jaeger para distributed tracing e error tracking  
✅ **Documentação Completa:** README detalhado com todas as instruções  

### Aprendizados Principais

1. **DevOps Culture:** Integração entre Dev e Ops
2. **Automation:** CI/CD reduz erros humanos
3. **Observability:** Monitoring é crucial para produção
4. **Testing:** Testes automatizados garantem qualidade
5. **Containerization:** Docker facilita deployment consistente

### Melhorias Futuras

- [ ] Implementar Kubernetes para orquestração avançada
- [ ] Adicionar API Gateway (Kong/Nginx)
- [ ] Implementar autenticação com OAuth2/JWT
- [ ] Database persistente (PostgreSQL)
- [ ] Logging centralizado (ELK Stack)
- [ ] Métricas com Prometheus + Grafana
- [ ] Service Mesh (Istio)
- [ ] GitOps com ArgoCD

### Estrutura Final do Projeto

```
devops-microservices-project/
├── microservices/
│   ├── service-a/
│   │   ├── app.py
│   │   ├── test_app.py
│   │   ├── Dockerfile
│   │   ├── requirements.txt
│   │   └── venv/
│   └── service-b/
│       ├── app.py
│       ├── test_app.py
│       ├── Dockerfile
│       ├── requirements.txt
│       └── venv/
├── infrastructure/
│   ├── docker/
│   ├── jenkins/
│   └── monitoring/
├── docs/
│   └── AAAAMMDD-HLD-ProjetoFinal-DevOps.drawio
├── docker-compose.yml
├── Jenkinsfile
└── README.md
```

---

## 📝 Informações do Projeto

**Projeto:** DevOps Microservices - CI/CD Pipeline  
**Curso:** DevOps Engineering  
**Ano:** 2026  
**Autor:** [Seu Nome]  
**Instituição:** Tokio School  

---

## 📄 Licença

MIT License - Sinta-se livre para usar este projeto como referência.

---

## 🙏 Agradecimentos

Agradecimentos especiais aos instrutores do curso de DevOps e à comunidade open-source pelas ferramentas incríveis utilizadas neste projeto.

---

**🎉 Projeto concluído com sucesso! Este sistema está pronto para produção e demonstra proficiência completa em práticas DevOps modernas.**

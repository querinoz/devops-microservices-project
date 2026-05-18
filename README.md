# Projeto Final DevOps — Microsserviços Python e Entrega Contínua

![Diagrama de arquitetura do projeto final DevOps](docs/20260518-HLD-ProjetoFinal-DevOps.drawio.png)

Projeto composto por dois microsserviços Flask (`service-a` e `service-b`), organizados em ambientes `DEV`, `STG` e `PRD` com Docker Compose, integração contínua via CircleCI e observabilidade distribuída com Jaeger/OpenTelemetry.

---

# 📋 Resumo do Projeto

## ✔️ Funcionalidades Implementadas

- Microsserviços Flask com comunicação HTTP/JSON
- Docker Compose com ambientes DEV/STG/PRD
- Pipeline CI/CD automatizada no CircleCI
- Testes automatizados com `pytest`
- Observabilidade distribuída com Jaeger
- Makefile completo para automação DevOps
- Build e execução isolada via Docker
- Estrutura pronta para execução local e CI/CD

---

# 🏗️ Arquitetura e Tecnologias

| Tecnologia | Finalidade |
|---|---|
| Python 3 + venv | Ambiente isolado |
| Flask | Microsserviços |
| Pytest | Testes automatizados |
| Docker | Containers |
| Docker Compose | Orquestração |
| CircleCI | CI/CD |
| Jaeger + OpenTelemetry | Observabilidade |

---

# 📁 Estrutura do Projeto

```text
devops-microservices-project/

├── .circleci/config.yml
├── docker-compose.yml
├── Makefile
├── requirements.txt
├── docs/
│   ├── 20260518-HLD-ProjetoFinal-DevOps.drawio
│   └── 20260518-HLD-ProjetoFinal-DevOps.drawio.png
└── microservices/
    ├── service-a/
    └── service-b/
```

---

# ⚙️ Automação DevOps com Makefile

O projeto utiliza um **Makefile avançado** para simplificar e acelerar toda a operação da infraestrutura DevOps.

A ideia principal foi centralizar todos os comandos importantes do projeto em uma única interface simples, reduzindo comandos longos de Docker/Docker Compose e aumentando produtividade, padronização e agilidade operacional.

## ✅ Benefícios do Makefile

- Automação da infraestrutura
- Inicialização rápida dos ambientes
- Execução simplificada de testes
- Simulação local da pipeline CI/CD
- Gerenciamento centralizado dos containers
- Facilidade de uso para qualquer desenvolvedor
- Melhor produtividade operacional

---

# 🚀 Comandos do Makefile

| Comando | Função |
|---|---|
| `make start` | Sobe toda a infraestrutura DEV/STG/PRD |
| `make stop` | Para todos os containers |
| `make restart` | Reinicia toda a infraestrutura |
| `make clean` | Remove containers, volumes e imagens |
| `make build` | Executa build dos microsserviços |
| `make status` | Exibe status dos containers |
| `make logs` | Mostra logs centralizados |
| `make test` | Executa todos os testes automatizados |
| `make health` | Realiza health checks dos serviços |
| `make pipeline` | Executa pipeline DevOps local completa |

---

# 🔍 O que cada comando faz

| Comando | Descrição |
|---|---|
| `make start` | Inicializa microsserviços, Docker Compose, ambientes DEV/STG/PRD e Jaeger |
| `make stop` | Encerra toda a infraestrutura em execução |
| `make clean` | Limpa completamente o ambiente Docker |
| `make restart` | Executa `stop` + `start` automaticamente |
| `make build` | Reconstrói as imagens Docker |
| `make test` | Executa testes do `service-a` e `service-b` com Pytest |
| `make logs` | Exibe logs da infraestrutura e containers |
| `make status` | Mostra status dos ambientes e containers |
| `make health` | Verifica endpoints e saúde dos serviços |
| `make pipeline` | Simula localmente toda a pipeline CI/CD |

---

# 🌐 Ambientes Disponíveis

| Ambiente | Service A | Service B | Jaeger |
|---|---|---|---|
| DEV | `localhost:8001` | `localhost:8002` | `localhost:16686` |
| STG | `localhost:9001` | `localhost:9002` | `localhost:16687` |
| PRD | `localhost:10001` | `localhost:10002` | `localhost:16688` |

---

# 🐳 Como Executar

## 1. Criar ambiente virtual

```bash
python -m venv venv
```

Linux / WSL:

```bash
source venv/bin/activate
```

Windows Git Bash:

```bash
source venv/Scripts/activate
```

---

## 2. Instalar dependências

```bash
pip install -r requirements.txt
```

---

## 3. Subir infraestrutura

```bash
make start
```

---

## 4. Validar ambiente

```bash
make status
```

---

## 5. Executar testes

```bash
make test
```

---

## 6. Executar pipeline local

```bash
make pipeline
```

---

## 7. Finalizar ambiente

```bash
make stop
```

---

# 🔍 Observabilidade

O projeto utiliza Jaeger/OpenTelemetry para tracing distribuído entre:

- `service-a`
- `service-b`

Permitindo:

- Rastreamento ponta a ponta
- Diagnóstico de falhas
- Análise de latência
- Monitoramento distribuído

---

# 🧪 Estratégia de Testes

Testes automatizados utilizando `pytest`:

- Testes unitários
- Testes HTTP/JSON
- Testes de integração
- Validação entre microsserviços

---

# 📊 Evidências de Validação

## Comandos executados com sucesso

```bash
make clean
make start
make status
make build
make test
make pipeline
```

## Resultado dos testes

| Serviço | Resultado |
|---|---|
| service-a | `3 passed` |
| service-b | `15 passed` |

Executado com sucesso em:

- DEV
- STG
- PRD

---

# ☁️ Pipeline Remota CircleCI

Pipeline disponível em:

- https://app.circleci.com/pipelines/github/querinoz

---

# 🎯 Objetivos DevOps Atendidos

- Infraestrutura como Código (IaC)
- Containers Docker
- Orquestração Multiambiente
- Integração Contínua
- Entrega Contínua
- Observabilidade Distribuída
- Automação Operacional
- Pipeline DevOps Completa

---

# ✅ Conclusão

O projeto implementa uma arquitetura moderna baseada em microsserviços Python utilizando práticas reais de DevOps, incluindo:

- Docker
- Docker Compose
- CircleCI
- Jaeger/OpenTelemetry
- Pytest
- Automação completa via Makefile

Toda a infraestrutura foi estruturada para simular um fluxo profissional de desenvolvimento, integração contínua, observabilidade e entrega automatizada.
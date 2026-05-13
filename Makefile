SHELL := /bin/bash
.DEFAULT_GOAL := help

COMPOSE_FILE := docker-compose.yml
DC := $(shell if command -v docker-compose >/dev/null 2>&1; then printf 'docker-compose'; else printf 'docker compose'; fi)

RED := \033[0;31m
GREEN := \033[0;32m
NC := \033[0m

.PHONY: help check-docker start stop status build test pipeline clean logs

help:
	@echo "DevOps Microservices Project - Makefile Help"
	@echo ""
	@echo "Recommended environment: Ubuntu WSL or Git Bash"
	@echo ""
	@echo "Available commands:"
	@echo "  make start      - Start local microservices"
	@echo "  make stop       - Stop all containers"
	@echo "  make status     - Show compose service status"
	@echo "  make build      - Build Docker images"
	@echo "  make test       - Run DEV/STG/PRD tests like CircleCI"
	@echo "  make pipeline   - Run build + tests locally"
	@echo "  make clean      - Remove containers, images and build cache"
	@echo "  make logs       - Stream service logs"
	@echo "  make help       - Show this help"

check-docker:
	@command -v docker >/dev/null 2>&1 || { printf "%b\n" "$(RED)Error: docker not found in PATH.$(NC)"; exit 1; }
	@docker info >/dev/null 2>&1 || { printf "%b\n" "$(RED)Error: Docker daemon is not running.$(NC)"; exit 1; }

start: check-docker
	@echo "==> Starting local microservices..."
	@$(DC) -f $(COMPOSE_FILE) up -d --build
	@echo "Services started successfully."
	@echo ""
	@echo "Endpoints:"
	@echo "  DEV Service A:  http://localhost:8001"
	@echo "  DEV Service B:  http://localhost:8002"
	@echo "  DEV Jaeger:     http://localhost:16686"
	@echo "  STG Service A:  http://localhost:9001"
	@echo "  STG Service B:  http://localhost:9002"
	@echo "  STG Jaeger:     http://localhost:16687"
	@echo "  PRD Service A:  http://localhost:10001"
	@echo "  PRD Service B:  http://localhost:10002"
	@echo "  PRD Jaeger:     http://localhost:16688"

stop: check-docker
	@echo "==> Stopping containers..."
	@$(DC) -f $(COMPOSE_FILE) down -v --remove-orphans
	@echo "Containers stopped."

status: check-docker
	@echo "==> Compose service status"
	@$(DC) -f $(COMPOSE_FILE) ps
	@echo ""
	@echo "Endpoints:"
	@echo "  http://localhost:8001  http://localhost:8002"
	@echo "  http://localhost:9001  http://localhost:9002"
	@echo "  http://localhost:10001 http://localhost:10002"

build: check-docker
	@echo "==> Building Docker images..."
	@if $(DC) -f $(COMPOSE_FILE) build --pull; then \
		printf "%b\n" "$(GREEN)Build completed successfully.$(NC)"; \
	else \
		printf "%b\n" "$(RED)Build failed.$(NC)"; \
		exit 1; \
	fi

test: check-docker
	@echo "==> Running tests for DEV, STG and PRD..."
	@$(DC) -f $(COMPOSE_FILE) run --rm --no-deps dev-service-a pytest -q
	@$(DC) -f $(COMPOSE_FILE) run --rm --no-deps dev-service-b pytest -q
	@$(DC) -f $(COMPOSE_FILE) run --rm --no-deps stg-service-a pytest -q
	@$(DC) -f $(COMPOSE_FILE) run --rm --no-deps stg-service-b pytest -q
	@$(DC) -f $(COMPOSE_FILE) run --rm --no-deps prd-service-a pytest -q
	@$(DC) -f $(COMPOSE_FILE) run --rm --no-deps prd-service-b pytest -q
	@echo "Tests completed successfully."

pipeline: check-docker
	@echo "==> Running local pipeline (build + test)..."
	@if $(MAKE) build && $(MAKE) test; then \
		printf "%b\n" "$(GREEN)Local pipeline completed successfully.$(NC)"; \
	else \
		printf "%b\n" "$(RED)Local pipeline failed.$(NC)"; \
		exit 1; \
	fi

clean: check-docker
	@echo "==> Cleaning Docker environment..."
	@$(DC) -f $(COMPOSE_FILE) down -v --remove-orphans
	@docker image prune -f
	@docker builder prune -f
	@echo "Cleanup completed."

logs: check-docker
	@echo "==> Streaming compose logs"
	@$(DC) -f $(COMPOSE_FILE) logs -f

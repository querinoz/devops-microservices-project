SHELL := /bin/bash
.DEFAULT_GOAL := help

# ============================================================
# CONFIGURATION
# ============================================================

COMPOSE_FILE := docker-compose.yml

DC := $(shell \
	if command -v docker-compose >/dev/null 2>&1; then \
		printf 'docker-compose'; \
	else \
		printf 'docker compose'; \
	fi \
)

# ============================================================
# STATUS COLORS
# ============================================================

RED   := \033[0;31m
GREEN := \033[0;32m
NC    := \033[0m

# ============================================================
# PHONY TARGETS
# ============================================================

.PHONY: \
	help \
	check-docker \
	start \
	stop \
	status \
	build \
	test \
	pipeline \
	clean \
	logs

# ============================================================
# HELP
# ============================================================

help:
	@echo "DevOps Microservices Project"
	@echo ""
	@echo "Recommended Environment:"
	@echo "  Ubuntu WSL or Git Bash"
	@echo ""
	@echo "Available Commands:"
	@echo ""
	@echo "  make start       Start local microservices"
	@echo "  make stop        Stop all containers"
	@echo "  make status      Show compose service status"
	@echo "  make build       Build Docker images"
	@echo "  make test        Run DEV/STG/PRD tests"
	@echo "  make pipeline    Run build and tests locally"
	@echo "  make clean       Remove containers and cache"
	@echo "  make logs        Stream compose logs"
	@echo "  make help        Show this help"

# ============================================================
# VALIDATIONS
# ============================================================

check-docker:
	@command -v docker >/dev/null 2>&1 || { \
		printf "%b\n" "$(RED)[ERROR] Docker not found in PATH.$(NC)"; \
		exit 1; \
	}

	@docker info >/dev/null 2>&1 || { \
		printf "%b\n" "$(RED)[ERROR] Docker daemon is not running.$(NC)"; \
		exit 1; \
	}

# ============================================================
# ENVIRONMENT
# ============================================================

start: check-docker
	@echo "[INFO] Starting local microservices..."
	@$(DC) -f $(COMPOSE_FILE) up -d --build

	@printf "%b\n" "$(GREEN)[SUCCESS] Services started successfully.$(NC)"

	@echo ""
	@echo "Available Endpoints:"
	@echo ""
	@echo "  DEV"
	@echo "    Service A : http://localhost:8001"
	@echo "    Service B : http://localhost:8002"
	@echo "    Jaeger    : http://localhost:16686"
	@echo ""
	@echo "  STG"
	@echo "    Service A : http://localhost:9001"
	@echo "    Service B : http://localhost:9002"
	@echo "    Jaeger    : http://localhost:16687"
	@echo ""
	@echo "  PRD"
	@echo "    Service A : http://localhost:10001"
	@echo "    Service B : http://localhost:10002"
	@echo "    Jaeger    : http://localhost:16688"

stop: check-docker
	@echo "[INFO] Stopping containers..."
	@$(DC) -f $(COMPOSE_FILE) down -v --remove-orphans

	@printf "%b\n" "$(GREEN)[SUCCESS] Containers stopped successfully.$(NC)"

status: check-docker
	@echo "[INFO] Compose service status"
	@$(DC) -f $(COMPOSE_FILE) ps

	@echo ""
	@echo "Endpoints:"
	@echo ""
	@echo "  DEV"
	@echo "    http://localhost:8001"
	@echo "    http://localhost:8002"
	@echo ""
	@echo "  STG"
	@echo "    http://localhost:9001"
	@echo "    http://localhost:9002"
	@echo ""
	@echo "  PRD"
	@echo "    http://localhost:10001"
	@echo "    http://localhost:10002"

# ============================================================
# BUILD
# ============================================================

build: check-docker
	@echo "[INFO] Building Docker images..."

	@if $(DC) -f $(COMPOSE_FILE) build --pull; then \
		printf "%b\n" "$(GREEN)[SUCCESS] Build completed successfully.$(NC)"; \
	else \
		printf "%b\n" "$(RED)[ERROR] Build failed.$(NC)"; \
		exit 1; \
	fi

# ============================================================
# TESTS
# ============================================================

test: check-docker
	@echo "[INFO] Running tests for DEV, STG and PRD..."

	@$(DC) -f $(COMPOSE_FILE) run --rm --no-deps dev-service-a pytest -q
	@$(DC) -f $(COMPOSE_FILE) run --rm --no-deps dev-service-b pytest -q

	@$(DC) -f $(COMPOSE_FILE) run --rm --no-deps stg-service-a pytest -q
	@$(DC) -f $(COMPOSE_FILE) run --rm --no-deps stg-service-b pytest -q

	@$(DC) -f $(COMPOSE_FILE) run --rm --no-deps prd-service-a pytest -q
	@$(DC) -f $(COMPOSE_FILE) run --rm --no-deps prd-service-b pytest -q

	@printf "%b\n" "$(GREEN)[SUCCESS] Tests completed successfully.$(NC)"

# ============================================================
# PIPELINE
# ============================================================

pipeline: check-docker
	@echo "[INFO] Running local pipeline..."

	@if $(MAKE) build && $(MAKE) test; then \
		printf "%b\n" "$(GREEN)[SUCCESS] Local pipeline completed successfully.$(NC)"; \
	else \
		printf "%b\n" "$(RED)[ERROR] Local pipeline failed.$(NC)"; \
		exit 1; \
	fi

# ============================================================
# CLEANUP
# ============================================================

clean: check-docker
	@echo "[INFO] Cleaning Docker environment..."

	@$(DC) -f $(COMPOSE_FILE) down -v --remove-orphans
	@docker image prune -f
	@docker builder prune -f

	@printf "%b\n" "$(GREEN)[SUCCESS] Cleanup completed.$(NC)"

# ============================================================
# LOGS
# ============================================================

logs: check-docker
	@echo "[INFO] Streaming compose logs..."
	@$(DC) -f $(COMPOSE_FILE) logs -f
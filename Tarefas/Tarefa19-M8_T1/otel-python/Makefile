.PHONY: start stop clean

start:
	docker buildx create --name otelbuilder 2>/dev/null || true
	docker buildx use otelbuilder
	docker buildx build user
	docker buildx build todo
	docker-compose up -d
	@echo "Jaeger UI:    http://localhost:16686"
	@echo "User service: http://localhost:5000"
	@echo "Todo service: http://localhost:5001"

stop:
	docker-compose stop

clean:
	docker-compose down
	docker buildx rm otelbuilder 2>/dev/null || true
	docker buildx prune -f
	docker stop $$(docker ps -qa) 2>/dev/null || true
	docker system prune -af --volumes
	docker network prune -f
	docker volume prune -af
	docker builder prune -af
	docker system df

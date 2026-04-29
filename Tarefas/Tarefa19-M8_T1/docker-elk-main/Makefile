
# from: https://github.com/deviantony/docker-elk
elk_start:
	docker-compose up setup
	docker-compose up -d
	@echo open browser at: http://localhost:5601
	@sleep 5 && curl http://localhost:9200 -u elastic:Tokio123
elk_stop:
	docker-compose down

elk_logs:
	docker-compose logs -f

elk_health:
	@docker inspect --format "{{json .State }}" $$(docker ps -q)
	@docker inspect $$(docker ps -q) | cat > elk-status.json

clean:
	docker stop $$(docker ps -qa) || true
	docker system prune -af --volumes
	docker network prune -f
	docker volume prune -af
	docker network prune -f
	docker builder prune -af
	docker system df

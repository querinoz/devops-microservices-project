
# Parar o Jenkins: make stop_jenkins
stop_jenkins:
	docker stop jenkins-blueocean

# Instalar e Inicializar o Jenkins
start_jenkins:
# https://www.jenkins.io/doc/book/installing/docker/ # 2. +4.a +4.b +5
	@echo ""
	@echo "Creating Docker network: jenkins"
	docker network create jenkins

	@echo ""
	@echo "Building Docker: Dockerfile.jenkins"
	docker build -t myjenkins-blueocean:latest -f Dockerfile.jenkins .
	
	@echo ""
	@echo "Starting Docker: jenkins-blueocean"
	docker run \
		--name jenkins-blueocean \
		--restart=on-failure \
		--detach \
		--network jenkins \
		--env DOCKER_HOST=tcp://docker:2376 \
		--env DOCKER_CERT_PATH=/certs/client \
		--env DOCKER_TLS_VERIFY=1 \
		--publish 8080:8080 \
		--publish 50000:50000 \
		--volume jenkins-data:/var/jenkins_home \
		--volume jenkins-docker-certs:/certs/client:ro \
		myjenkins-blueocean:latest

	@echo ""
	@echo "Success... Docker Process Started:"
	@docker ps

	@echo ""

	@echo "InitialAdminPassword (User: admin):"
	@docker exec -it jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword
	@echo ""
	@echo "Use the above credentials login into your Jenkins: http://127.0.0.1:8080"

restart_jenkins:
	docker stop jenkins-blueocean
	docker start jenkins-blueocean
	docker ps

clean:
	docker stop $$(docker ps -qa) || true
	docker system prune -af --volumes
	docker volume prune -af
	docker network prune -f
	docker builder prune -af
	docker system df

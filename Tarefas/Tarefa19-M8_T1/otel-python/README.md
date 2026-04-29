
# (optional)
# Networking IPv6 fix issue socket: address family not supported by protocol
# ADD Custom DNSs to /etc/systemd/resolved.conf
sudo bash -c 'echo "DNS=8.8.8.8"         >> /etc/systemd/resolved.conf'
sudo bash -c 'echo "FallbackDNS=8.8.4.4" >> /etc/systemd/resolved.conf'
cat /etc/systemd/resolved.conf
sudo systemctl restart systemd-resolved.service
resolvectl status

# (optional)
# Ubuntu Compose FIX:
sudo snap refresh docker --channel=latest/edge

# Build and Run:
# (optional) delete builder: docker rm /buildx_buildkit_otelbuilder0
# Create buildx Context:
docker buildx create --name otelbuilder
docker buildx use otelbuilder
docker buildx build user
docker buildx build todo
docker ps
docker-compose up -d
docker-compose ps

# Destroy and Cleanup:
docker-compose down
docker buildx rm otelbuilder
docker buildx prune -f
docker stop $$(docker ps -qa) || true
docker system prune -af --volumes
docker network prune -f
docker volume prune -af
docker network prune -f
docker builder prune -af
docker system df

# Compose Show Logs:
docker-compose logs -f

# Step1 : Generate metrics opening "User" app:
http://localhost:5000/user/profile
http://localhost:5000/user/profile/5

# Step2 : Generate metrics opening "Todo" app:
http://localhost:5001/todo
http://localhost:5001/todo/1
http://localhost:5001/todo/5  # Generate 'Todo app' trace error 

# Step3 : Open Yaeger to look at trace metrics and errors
http://localhost:16686

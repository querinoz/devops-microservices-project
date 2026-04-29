
# Build/Start Puppet Master Server
start_puppet_server:
# https://www.puppet.com/blog/puppet-docker
# https://github.com/voxpupuli/crafty/blob/main/puppet/oss/.env
# https://github.com/voxpupuli/crafty/blob/main/puppet/oss/compose.yaml
	REGISTRY_PATH="ghcr.io/voxpupuli" \
	POSTGRES_USER=puppetdb \
	POSTGRES_PASSWORD=puppetdb \
	POSTGRES_DB=puppetdb \
	docker-compose -f compose_puppet.yaml up -d
	@echo ""
	@docker ps
	@echo ""
	@echo open puppetboard: http://127.0.0.1:8088
	@echo open puppetdb: https://127.0.0.1:8081

# Stop Puppet Master Server
stop_puppet_server:
	REGISTRY_PATH="ghcr.io/voxpupuli" \
	POSTGRES_USER=puppetdb \
	POSTGRES_PASSWORD=puppetdb \
	POSTGRES_DB=puppetdb \
	docker-compose -f compose_puppet.yaml down

# Build/Start Puppet Agent Server
start_puppet_agent:
	docker run --name puppet_agent -it -d --network crafty-oss --platform linux/amd64 ghcr.io/betadots/pdc:latest sh -c 'while [ 1 ];do sleep 30;done;'
	@echo ""
	@docker ps
	@echo ""

# Stop Puppet Agent Server
stop_puppet_agent:
	docker stop puppet_agent

# Restart Puppet Agent Server
restart_puppet_agent:
	docker stop puppet_agent
	docker start puppet_agent

# Run PuppetAgent test and exit, node will be created/updated once, on each execution, for debugging purposes
add_test_agent:
	docker exec -it puppet_agent puppet agent -t --debug
	docker exec -it puppet_agent ps -eaf

# Launch PuppetAgent Daemon and exit, node will be created/updated, each 30mins
add_agent_daemon:
	docker exec -it puppet_agent puppet agent -D
	docker exec -it puppet_agent ps -eaf

# Kill PuppetAgent Daemon 
kill_agent_daemon:
	docker exec -it puppet_agent pkill "puppet" || true
	docker exec -it puppet_agent ps -eaf

# PuppetAgent (query)-> Delete Node in Pupper Master 
del_node:
	@certname=`curl -ks -X GET https://localhost:8081/pdb/query/v4/nodes | python3 -m json.tool | grep certname | sed -e 's/^[ ]*\"certname\": \"\(.*\)\".*$$/\1/' )` \
	; docker exec -it puppet_agent puppet node deactivate --verbose $$certname

# GET Master (query)-> List Nodes
list_nodes:
	curl -ks -X GET https://localhost:8081/pdb/query/v4/nodes | python3 -m json.tool

# GET Master (query)-> List Node Names
list_node_names:
	@curl -ks -X GET https://localhost:8081/pdb/query/v4/nodes | python3 -m json.tool | grep certname

# PuppetAgent: Print Config
printcfg_agent:
	docker exec -it puppet_agent puppet config print

# PuppetAgent (query)-> Dump Node Info in Pupper Master 
dump_nodes:
	docker exec -it puppet_agent puppet node find |/bin/cat 2>&1 > output.json

clean:
	make stop_puppet_server
	docker stop $$(docker ps -qa) || true
	docker system prune -af --volumes
	docker volume prune -af
	docker network prune -f
	docker builder prune -af
	docker system df

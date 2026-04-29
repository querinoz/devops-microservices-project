
## MOTO Server ##

start_moto:
	docker-compose -f docker-compose.yml up --detach

moto_status:
	docker-compose ps

stop_moto:
	docker-compose down

moto_reset:
	@curl -X POST http://localhost:5000/moto-api/reset
	@echo 

moto_dashboard:
	@x-www-browser http://localhost:5000/moto-api/ > /dev/null 2>&1 &

bash_aws_autocomplete:
	bash -c "complete -C /usr/local/bin/aws_completer aws"

bash_tf_autocomplete:
	bash -c "complete -C /snap/terraform/current/terraform terraform"

## AWS ##

aws_init:
	aws organizations create-organization

aws_status:
	@aws sts get-caller-identity
	@aws organizations list-accounts
	@aws organizations describe-organization

aws_cfg:
	ls -la ~/.aws/*
	aws configure list

aws_survey:
	aws sts get-caller-identity
	aws organizations list-accounts
	aws organizations describe-organization
	aws dynamodb list-tables
	aws dynamodb describe-table --table-name tf-notes-table

aws_ami_list_ubuntu:
	aws ec2 describe-images --filters "Name=name,Values=*ubuntu*"

aws_create_instance:
	aws ec2 run-instances --image-id ami-1e749f67

clean:
	make moto_reset
	docker stop $$(docker ps -qa) || true
	docker system prune -af --volumes
	docker network prune -f
	docker volume prune -af
	docker network prune -f
	docker builder prune -af
	docker system df

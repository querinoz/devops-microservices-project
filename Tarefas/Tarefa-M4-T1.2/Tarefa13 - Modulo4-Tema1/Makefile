
ansible_list:
	ansible-inventory -i inventory.ini --list

ansible_test:
	ansible all -m ping -i inventory.ini
	ansible myhosts -m ping -i inventory.ini

ansible_run:
	ansible-playbook linux_run_script.yml -i inventory.ini

test:
	echo "teste"
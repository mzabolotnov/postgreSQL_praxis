#!/bin/bash
terraform apply -auto-approve
# terraform output | grep external_ip_address |awk '{print $3}' | tr -d '"' > ../ansible/inventory
cd ../ansible/
ansible-playbook  postgres_install.yml
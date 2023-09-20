#!/bin/bash
terraform apply -auto-approve
cd ../ansible/
ansible-playbook  postgres_install.yml
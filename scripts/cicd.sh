#!/bin/bash
#ansible-playbook playbooks/07-bootstrap.yml --ask-vault-pass
ansible-playbook playbooks/07-bootstrap.yml

kubectl get svc -n traefik-system
curl http://registry.local/v2/


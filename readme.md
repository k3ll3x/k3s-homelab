# Quick Start

## Clone repo
git clone <repo> k3s-homelab

## Create vault files
ansible-vault create -y group_vars/secrets.yml  # Enter password twice
ansible-vault create -y group_vars/vault.yml

## Edit your values
ansible-vault edit group_vars/secrets.yml
ansible-vault edit group_vars/vault.yml

## Deploy
ansible-playbook playbooks/07-bootstrap.yml

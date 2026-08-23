#!/bin/bash
# 1. Create vault files
ansible-vault create group_vars/secrets.yml
ansible-vault create group_vars/vault.yml

# 2. Edit with vault
ansible-vault edit group_vars/secrets.yml
ansible-vault edit group_vars/vault.yml

# 3. Local deployment
echo "your-vault-password" > vault_pass.txt
ansible-playbook playbooks/07-bootstrap.yml

# 4. GitHub Actions deployment (no local secrets needed)
git push  # Triggers bootstrap.yml with repo secrets

# 5. View encrypted files
ansible-vault view group_vars/secrets.yml

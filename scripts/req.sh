#!/bin/bash
# 1. Install ALL dependencies
ansible-galaxy install -r requirements.yml

# 2. Update to latest versions
ansible-galaxy install -r requirements.yml --force

# 3. Install with roles path (project local)
ansible-galaxy install -r requirements.yml -p ./roles

# 4. Verify installation
ansible-galaxy collection list | grep kubernetes
ansible-galaxy role list | grep k3s


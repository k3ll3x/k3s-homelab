#!/bin/bash
# 1. Test connectivity
ansible-playbook playbooks/01-prereqs.yml --check

# 2. Deploy infrastructure
ansible-playbook playbooks/01-prereqs.yml
ansible-playbook playbooks/02-k3s-cluster.yml

# 3. Export kubeconfig
export KUBECONFIG=kubeconfig/admin.conf
kubectl get nodes

# 4. Configure registries
ansible-playbook playbooks/03-registries.yml

# 5. Deploy apps via Helm
ansible-playbook playbooks/04-apps.yml

# 6. Verify
kubectl get pods -n registry
curl -k http://registry.local/v2/


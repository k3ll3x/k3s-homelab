#!/bin/bash
# Minimal mode: keep only k3s + traefik + minecraft, drop heavy stack.
# Run on timemachine (or via ssh).

K="sudo KUBECONFIG=/etc/rancher/k3s/k3s.yaml helm"
KUBE="sudo k3s kubectl"

$K uninstall monitoring -n monitoring 2>/dev/null
$K uninstall argocd -n argocd 2>/dev/null
$K uninstall admin-dev -n admin 2>/dev/null
$KUBE scale deploy minecraft-server -n games --replicas=1
$KUBE set env deployment/minecraft-server -n games MEMORY=1G MAX_MEMORY=1G
$KUBE rollout restart deployment/minecraft-server -n games

# Add swap if missing (prevents OOM thrash)
if [ "$(sudo swapon --show | wc -l)" = "0" ]; then
  sudo fallocate -l 4G /swapfile && sudo chmod 600 /swapfile
  sudo mkswap /swapfile && sudo swapon /swapfile
  echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
fi

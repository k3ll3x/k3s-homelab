#!/bin/bash
# Scale deployments to zero / requested count (scale-to-zero economy mode)
# Usage: ./scripts/scale.sh <namespace/deployment> <replicas>
#        ./scripts/scale.sh games/minecraft-server 1

KUBE="sudo k3s kubectl"
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <ns/deploy> <replicas>"
  exit 1
fi
NS=$(echo "$1" | cut -d/ -f1)
DEP=$(echo "$1" | cut -d/ -f2)
$KUBE scale deployment "$DEP" -n "$NS" --replicas="$2"

# On-demand helpers
case "$2" in
  0) echo "$1 -> stopped (saved RAM)" ;;
  *) echo "$1 -> scaled to $2" ;;
esac

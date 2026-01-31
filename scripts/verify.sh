#!/bin/bash
# 1. Check Traefik pods
kubectl get pods -n traefik-system

# 2. Verify dashboard accessible
curl -k https://traefik.local/dashboard/api/version

# 3. Check Traefik routes
kubectl get ingressroute -n traefik-system

# 4. Port-forward for initial testing
kubectl port-forward -n traefik-system svc/traefik 9000:80
# Then: http://localhost:9000/dashboard/

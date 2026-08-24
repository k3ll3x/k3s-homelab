# Homelab: k3s Cluster Access & Apps

## Architecture
- **Master** `timemachine` - 192.168.2.94 (Debian/Bunsenlabs, control-plane, sudo)
- **Worker** `retropad` - 192.168.2.95 (Alpine diskless, doas, /var/lib/rancher bind-mount to /media/sda2)
- **Ingress**: k3s builtin Traefik v3 (kube-system). Uses **IngressRoute (CRD)** only - the kubernetesIngress provider is broken in this build. All app routes are CRD IngressRoutes in `manifests/`.
- **SSH**: key-only, password auth disabled. `~/.ssh/timemachine` & `~/.ssh/retropad`. PQ warning silenced in `~/.ssh/config` (`KexAlgorithms -sntrup761x25519-sha512@openssh.com`).

## DNS / Hosts
Add to workstation `/etc/hosts` (or router DNS override):
```
192.168.2.94 traefik.local grafana.local prometheus.local argocd.local dev.local
```

## App Access
| App | URL | Credentials |
|---|---|---|
| Traefik dashboard | http://traefik.local | - |
| Grafana | http://grafana.local | admin / homelab123 |
| Prometheus | http://prometheus.local | - |
| ArgoCD | http://argocd.local | admin / argocdStrongPass123! |
| Dev container (webtop XFCE) | http://dev.local | abc / abc (VNC: devpass123) |
| Minecraft | 192.168.2.94:25565 | offline mode, whitelist nuvhandra (op) |

## Fixes Applied (historical)
- Traefik: kubernetesIngress provider broken -> CRD IngressRoutes (`manifests/app-ingresses.yaml`, `manifests/traefik-dashboard.yaml`).
- Duplicate helm traefik (traefik-system) removed; single builtin controller.
- Minecraft offline mode: `OVERRIDE_*` env ignored by image -> initContainer writes `whitelist.json`/`ops.json` with offline UUID (`manifests/minecraft.yaml`).
- kasmweb images private -> linuxserver/webtop arch-xfce.
- Dev-container chart fixed: `_helpers.tpl` added, ConfigMap dropped (binary/name-collision) -> hostPath config mount, privileged on container level.

## Security (see security-policy.md)
- SSH: key-only, no passwords.
- Future: VLAN 20 isolation, Traefik IPAllowList for admin apps.

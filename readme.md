# Homelab Replication Guide (k3s cluster on laptops)

Reproduce the whole homelab on new hardware. Order matters.

## 1. Hardware Prep (every laptop)
- **BIOS**: enable "Restore on AC Power" (auto power-on), disable secure boot (or enroll keys), UEFI mode.
- **Master**: single OS (Debian/Bunsenlabs). Remove dead OS entries:
  ```bash
  sudo efibootmgr -o <debian-num>,3003,2001,2002 && sudo efibootmgr -b <ubuntu-num> -B
  ```
- **GRUB** (master, if default kernel fails): edit `/etc/default/grub`:
  ```
  GRUB_DISABLE_OS_PROBER=true
  GRUB_DEFAULT="1>2"   # Advanced options -> known-good kernel
  ```
  then `sudo update-grub`.

## 2. Worker (Alpine diskless, e.g. retropad)
- Install Alpine to RAM (`none` for disk), store configs on disk partition (sda1).
- Persistent mounts in `/etc/fstab`: `/media/sda2` -> `/var/lib/rancher` (k3s data) and `/home`.
- **After EVERY change**: `sudo lbu include /etc/rancher /usr/local/bin /lib/modules && sudo lbu commit` (diskless wipes /etc otherwise!).
- **doas** (Alpine has no sudo): `echo 'permit nopass :wheel' > /etc/doas.d/doas.conf`
- **kube-proxy MUST use nftables** (Alpine lts kernel has no ip_tables module):
  `/etc/init.d/k3s-agent` command_args: `agent --kube-proxy-arg proxy-mode=nftables --node-ip <ip>`
- Join: `K3S_TOKEN=<token> K3S_URL=https://<master>:6443 sh k3s-install.sh agent --node-ip <ip>`
  (token: `/var/lib/rancher/k3s/server/token` on master)
- If node rejected (old registration): on master `kubectl delete node <name>` + delete entry from `/var/lib/rancher/k3s/server/cred/node-passwd`, remove `/etc/rancher/node/password` on worker, restart agent.

## 3. Ansible bootstrap
```bash
# inventory: copy hosts.yml.example -> hosts.yml, set IPs/keys/become_method (sudo|doas)
ansible-playbook -i inventory/hosts.yml playbooks/01-prereqs.yml
ansible-playbook -i inventory/hosts.yml playbooks/02-k3s-cluster.yml   # installs k3s server+agents
ansible-playbook -i inventory/hosts.yml playbooks/03-registries.yml
```

## 4. Minimal stack (RAM-light)
```bash
ssh nuvhandra@<master> "bash -s" < scripts/minimal-mode.sh   # drops monitoring/argocd/dev, keeps traefik+minecraft, adds swap
```

## 5. Minecraft + plugin
- `manifests/minecraft.yaml`: offline mode, whitelist off, `capacity=high` nodeSelector, hostPath `/var/lib/minecraft`, initContainer writes ops.json (admin `nuvhandra`).
- Build plugin (k8s Job, no host installs): `minecraft-store/plugin/` -> maven image Job copies jar to `/var/lib/minecraft/plugins/`.
- In-game: `/credits`, `/buy <item>` (shop in plugin config.yml).

## 6. Store (payments: XRP, no bank)
- Webstore: `minecraft-store/webstore/` (Flask) - copy to `/home/nuvhandra/webstore` on master, deploy as python pod (hostPath code mount). Service+IngressRoute in `manifests/webstore.yaml`.
- Set seller wallet: `kubectl set env deployment/webstore -n store XRP_ADDRESS=r...`
- Flow: username -> pay XRP (ledger verify) -> whitelist + 100 credits -> `paid_until` +30d -> hourly expiry auto-revokes (subscriptions.json).

## 7. TLS / certs
- Internal CA + wildcard `*.local` cert (master: `/etc/traefik-certs/`):
  `kubectl -n kube-system create secret tls traefik-default-cert --cert=server.crt --key=server.key`
- Every IngressRoute: `tls: {secretName: traefik-default-cert}`.
- Trust CA on clients (install ca.crt). Later: Let's Encrypt via Traefik certresolver (same route structure).

## 8. Access (add to /etc/hosts)
```
192.168.2.94 traefik.local dev.local store.local
```
- store.local (store), dev.local (webtop XFCE desktop), traefik.local (dashboard).
- SSH: key-only, `~/.ssh/timemachine` / `~/.ssh/retropad`; PQ warning silenced in `~/.ssh/config`.

## Known pitfalls
- Alpine diskless: everything in /etc lost on reboot unless `lbu commit`.
- Traefik kubernetesIngress provider broken in this build -> use IngressRoute (CRD) only.
- kasmweb images are private -> use linuxserver/webtop.
- Minecraft offline mode + free launchers: UUID from `MD5("OfflinePlayer:"+name)`; whitelist OFF, gate via plugin.

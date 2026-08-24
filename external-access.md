# Homelab DNS & External Access (Port Forwarding) Guide

## 1. Local DNS Setup (LAN)
To resolve `.local` or custom domain names across your home network:
- **Option A: Router DNS / Static Leases / Host Overrides** (Recommended)
  - If your router runs OpenWrt, pfSense, or Pi-hole/AdGuard Home:
    - Add **Host Overrides / Custom DNS Entries**:
      - `traefik.local` -> `192.168.2.94`
      - `grafana.local` -> `192.168.2.94`
      - `argocd.local` -> `192.168.2.94`
- **Option B: Workstation `/etc/hosts`**
  - On your laptop/PC, edit `/etc/hosts` (Linux/macOS) or `C:\Windows\System32\drivers\etc\hosts` (Windows):
    ```text
    192.168.2.94 traefik.local grafana.local prometheus.local argocd.local app.local
    ```

---

## 2. External Access & Port Forwarding (For Colleague)
To allow your colleague to securely access services from outside your home network:

### A. Router Port Forwarding
In your home router settings, set up port forwarding rules pointing external traffic to your master node (`192.168.2.94`):
- **HTTP (Port 80)** -> Forward to `192.168.2.94:80` (Traefik web)
- **HTTPS (Port 443)** -> Forward to `192.168.2.94:443` (Traefik secure)
- **Minecraft (Port 25565)** -> Forward to `192.168.2.94:25565` (Minecraft server)

### B. Public DNS / Dynamic DNS (DDNS)
1. **Domain Name**: Register a free or cheap domain (e.g., via Cloudflare, DuckDNS, No-IP).
2. **Wildcard DNS Record**: Create an `A` record or wildcard (`*.yourdomain.com`) pointing to your public home IP address.
3. **Dynamic DNS Updater**: Run a lightweight DDNS client (like Cloudflare DDNS or DuckDNS client) in your cluster or router if your home IP changes dynamically.

### C. SSL / TLS Certificates (Let's Encrypt)
- Configure Traefik with a **CertResolver (Let's Encrypt HTTP/DNS challenge)** in `helm/traefik/values.yaml` so your colleague accesses services securely via HTTPS without browser security warnings.

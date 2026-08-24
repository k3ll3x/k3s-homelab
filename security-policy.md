# Homelab Security & Network Isolation Policy

## 1. Incident Root Cause & Prevention
- **Root Cause**: Previous Ansible tasks managed user creation and overwrote existing system user passwords.
- **Rule**: Ansible roles will **never** manage system user passwords or overwrite existing user accounts. All authentication must rely solely on pre-configured SSH keys managed manually or via authorized keys without modifying system user passwords.

---

## 2. Manual SSH Configuration & Hardening Guide
SSH configuration and key management are strictly handled manually to prevent automated misconfigurations:
1. **Disable Password Authentication**: Edit `/etc/ssh/sshd_config`:
   ```sshd
   PasswordAuthentication no
   PermitRootLogin prohibit-password
   ```
2. **Strict Client Whitelisting**: Restrict SSH access in `/etc/ssh/sshd_config` or `/etc/hosts.allow`:
   ```sshd
   AllowUsers nuvhandra@192.168.2.93
   ```
3. **Key Permissions**: Ensure private keys are `0600` and `authorized_keys` are `0600`.


---

## 3. Application Access Whitelist (Ingress / Traefik)
To allow broader access to deployed apps while keeping backend services restricted:
- Configure Traefik middleware (`IPAllowList`) in Kubernetes:
  ```yaml
  apiVersion: traefik.io/v1alpha1
  kind: Middleware
  metadata:
    name: trusted-ips
    namespace: kube-system
  spec:
    ipAllowList:
      sourceRange:
        - "192.168.2.0/24"
        - "10.42.0.0/16"
  ```

---

## 4. VLAN Implementation Guide for Homelab
Separating your homelab into a dedicated VLAN prevents compromised devices from accessing your main network.

### Steps:
1. **Router Configuration (e.g., OpenWrt / pfSense / UniFi)**:
   - Create a new VLAN (e.g., **VLAN 20**, Tag `20`, Subnet `192.168.20.0/24`).
   - Enable DHCP server for VLAN 20.
   - Configure firewall rules:
     - **Allow** VLAN 20 to access Internet.
     - **Allow** Main Network (VLAN 10 / Polaris `192.168.2.93`) to access VLAN 20 (SSH & K3s ports).
     - **Block** VLAN 20 from initiating connections back to Main Network.

2. **Switch & Access Point Configuration**:
   - Trunk port to nodes/router carrying VLAN 20 tags.
   - Access ports on switches dedicated to homelab hardware assigned to VLAN 20.

3. **Node Network Configuration (Alpine / Debian)**:
   - Configure tagged VLAN interface (e.g., `eth0.20`) on nodes if using managed trunk ports, or let the switch port handle untagged VLAN 20 access directly.

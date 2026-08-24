# Homelab Security & Network Isolation Policy

## 1. Incident Root Cause Analysis (Password Reset)
During initial setup tasks (`roles/common/tasks/main.yml`), the Ansible user creation task ran:
```yaml
- name: Create consistent users
  user:
    name: "{{ item.name }}"
    groups: "{{ item.groups }}"
    shell: /bin/bash
    append: yes
    password: "{{ 'password' | password_hash('sha512') }}"
```
Because the user `nuvhandra` already existed on the laptop (`timemachine`), Ansible's `user` module overwrote the existing system password with the literal hash of `"password"`, locking out your original password. 

---

## 2. Strict SSH Access Control (Client Whitelist)
To ensure SSH access is allowed **only** from this control workstation (`polaris`):
1. On each node (`timemachine`, `retropad`), edit `/etc/ssh/sshd_config`:
   ```sshd
   AllowUsers nuvhandra@<POLARIS_IP>
   ```
2. Or use `/etc/hosts.allow` and `/etc/hosts.deny`:
   - `/etc/hosts.deny`:
     ```text
     sshd: ALL
     ```
   - `/etc/hosts.allow`:
     ```text
     sshd: 192.168.2.93
     ```

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

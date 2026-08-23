# Homelab Setup: Old Laptops + ESP32

## Hardware Prerequisites
- Old laptops (Linux installed)
- ESP32 + Relay module
- Network connectivity

## Setup Steps

### 1. Hardware/Power (ESP32)
1. Flash ESP32 with minimal HTTP API (`/node/<id>?state=on|off`).
2. Connect Relay to laptop power pins or WOL (Wake-on-LAN).

### 2. Configuration
1. Clone repo.
2. Setup Ansible secrets (`ansible-vault`):
   - `group_vars/secrets.yml`: Add `esp32_ip`.
3. Inventory: Add laptops to `inventory/hosts.yml` (group by `arm_nodes`, `x86_nodes`).

### 3. Deploy
1. Run bootstrap:
   `ansible-playbook playbooks/07-bootstrap.yml`
2. Label Ollama nodes:
   `kubectl label nodes <node_name> llm-ready=true`
3. Deploy LLM:
   `helm install ollama ./helm/ollama`


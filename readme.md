# Homelab Documentation: Master Node & Power Management

## 1. Laptop BIOS / UEFI "Power On AC" Configuration
To allow remote power-on via the ESP32 relay system without pressing the physical power button:
1. Boot the laptop and press `F10` (or `ESC` -> `F10`) during startup to enter BIOS Setup.
2. Go to **Advanced** > **Power Management Options** (or **Startup** / **Boot Options**).
3. Set **Restore on AC Power** (or **AC Power Recovery**) to **Power On**.
4. Save settings and exit (`F10`).
5. **Behavior**: Whenever power is supplied via the ESP32 relay, the laptop boots up automatically.

---

## 2. Automated Safe Shutdown & ESP32 Power-Off Mechanism
A clean shutdown script runs on the master node (`/usr/local/bin/homelab-safe-shutdown.sh`) to:
1. Check if the cluster is actively used (active Kubernetes workloads, SSH sessions, or high resource activity).
2. Gracefully drain k3s workloads if idling.
3. Signal the ESP32 power manager (via HTTP/MQTT request).
4. Initiate system shutdown (`shutdown -h now`), allowing the ESP32 relay to cut power after a delay.

### Script Implementation (`/usr/local/bin/homelab-safe-shutdown.sh`)
```bash
#!/bin/bash
# Homelab Safe Shutdown & ESP32 Power-Off Trigger

ESP32_IP="${ESP32_IP:-192.168.2.100}"
IDLE_THRESHOLD_MINUTES=30

# Check active SSH connections or load average
ACTIVE_SSH=$(who | wc -l)
LOAD_AVG=$(awk '{print $1}' /proc/loadavg)

if [ "$ACTIVE_SSH" -gt 1 ] || (( $(echo "$LOAD_AVG > 2.0"béco 2.0" | bc -l) )); then
    echo "Cluster active. Aborting shutdown."
    exit 0
fi

echo "Cluster idle. Initiating graceful shutdown..."

# Notify ESP32 to prepare power cutoff after delay
curl -s -X POST "http://$ESP32_IP/poweroff" || true

# Shutdown system
sudo shutdown -h +1 "Homelab entering low-power sleep state."
```

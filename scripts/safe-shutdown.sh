#!/bin/bash
# Homelab Safe Shutdown & ESP32 Power-Off Trigger

ESP32_IP="${ESP32_IP:-192.168.2.100}"
IDLE_THRESHOLD_MINUTES=30

# Check active SSH connections or load average
ACTIVE_SSH=$(who | wc -l)
LOAD_AVG=$(awk '{print $1}' /proc/loadavg)

if [ "$ACTIVE_SSH" -gt 1 ] || (( $(echo "$LOAD_AVG > 2.0" | bc -l) )); then
    echo "Cluster active. Aborting shutdown."
    exit 0
fi

echo "Cluster idle. Initiating graceful shutdown..."

# Notify ESP32 to prepare power cutoff after delay
curl -s -X POST "http://$ESP32_IP/poweroff" || true

# Shutdown system
sudo shutdown -h +1 "Homelab entering low-power sleep state."

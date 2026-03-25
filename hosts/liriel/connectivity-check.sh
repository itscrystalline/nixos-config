#!/usr/bin/env bash

set -euo pipefail

STATE_DIR="/var/lib/connectivity-check"
STATE_FILE="$STATE_DIR/failure_count"

mkdir -p "$STATE_DIR"

if [[ ! -f "$STATE_FILE" ]]; then
    echo "0" > "$STATE_FILE"
fi

FAILURE_COUNT=$(cat "$STATE_FILE")

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | logger -t connectivity-check -s
}

check_connectivity() {
    for endpoint in "1.1.1.1" "8.8.8.8" "9.9.9.9"; do
        if ping -c 1 -W 2 "$endpoint" &> /dev/null; then
            return 0
        fi
    done
    return 1
}

restart_network_services() {
    log "Restarting network services..."
    systemctl restart tailscaled || log "Warning: Failed to restart tailscaled"
    systemctl restart NetworkManager || log "Warning: Failed to restart NetworkManager"
    
    sleep 5
}

handle_failure() {
    FAILURE_COUNT=$((FAILURE_COUNT + 1))
    echo "$FAILURE_COUNT" > "$STATE_FILE"
    
    log "Connectivity check failed. Failure count: $FAILURE_COUNT"
    
    if [[ $FAILURE_COUNT -eq 1 ]]; then
        log "first connectivity failure"
        restart_network_services
    elif [[ $FAILURE_COUNT -eq 2 ]]; then
        log "second connectivity failure - restarting tailscale and networkmanager again"
        restart_network_services
    elif [[ $FAILURE_COUNT -ge 3 ]]; then
        log "third consecutive connectivity failure, rebootting"
        shutdown -r +10 &
    fi
}

handle_success() {
    if [[ $FAILURE_COUNT -gt 0 ]]; then
        log "network is back, resetting failure count"
    fi
    echo "0" > "$STATE_FILE"
}

# Main logic
if check_connectivity; then
    log "Connectivity check passed"
    handle_success
    exit 0
else
    log "Connectivity check failed"
    handle_failure
    exit 1
fi

#!/bin/bash
# ==========================================================================
# FALUKÉP360 - 24/7 KEEP ALIVE DAEMON SCRIPT
# ==========================================================================

PORT=8092
PROJECT_DIR="/Users/macintosh/.gemini/antigravity/scratch/web_projects/falukep360_website"
LOG_FILE="/tmp/falukep360_daemon.log"

echo "[$(date)] Starting Falukép360 Keep-Alive Server Daemon..." >> "$LOG_FILE"

while true; do
  # Check if HTTP server on port 8092 is running
  if ! pgrep -f "http.server $PORT" > /dev/null; then
    echo "[$(date)] HTTP Server stopped. Restarting on port $PORT..." >> "$LOG_FILE"
    nohup python3 -m http.server $PORT --directory "$PROJECT_DIR" >> "$LOG_FILE" 2>&1 &
    sleep 2
  fi

  # Check if SSH tunnel is running
  if ! pgrep -f "80:localhost:$PORT" > /dev/null; then
    echo "[$(date)] HTTPS Tunnel stopped. Re-establishing connection..." >> "$LOG_FILE"
    nohup ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=20 -R 80:localhost:$PORT nokey@localhost.run >> /tmp/falukep360_online.log 2>&1 &
    sleep 4
  fi

  sleep 15
done

#!/bin/bash
set -e

echo "Starting deployment to staging..."

APP_PORT=3001
PID_FILE="staging.pid"
LOG_FILE="staging.log"

# Stop the previous staging application, if it exists.
if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE")

    if kill -0 "$OLD_PID" 2>/dev/null; then
        kill "$OLD_PID"
        echo "Previous staging application stopped."
    fi

    rm -f "$PID_FILE"
fi

# Start Node.js as a detached process.
# These variables prevent Jenkins from killing the application.
nohup env \
    JENKINS_NODE_COOKIE=dontKillMe \
    BUILD_ID=dontKillMe \
    PORT="$APP_PORT" \
    node app.js > "$LOG_FILE" 2>&1 &

APP_PID=$!
echo "$APP_PID" > "$PID_FILE"

echo "Staging application started with PID: $APP_PID"

# Wait for the application to become healthy.
for i in {1..15}; do
    if curl -fsS "http://127.0.0.1:$APP_PORT/health"; then
        echo
        echo "Staging deployment successful."
        exit 0
    fi

    sleep 2
done

echo "ERROR: Staging health check failed."
cat "$LOG_FILE"
exit 1

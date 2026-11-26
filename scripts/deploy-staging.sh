
#!/bin/bash

set -e

echo "Starting deployment to staging..."

APP_PORT=3001
PID_FILE="staging.pid"
LOG_FILE="staging.log"

# Stop the previous staging application, if it is running
if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE")

    if kill -0 "$OLD_PID" 2>/dev/null; then
        kill "$OLD_PID"
        echo "Previous staging application stopped."
    fi

    rm -f "$PID_FILE"
fi

# Start the application on port 3001
PORT=$APP_PORT nohup node app.js > "$LOG_FILE" 2>&1 &
echo $! > "$PID_FILE"

echo "Waiting for the staging application..."

# Check the application health endpoint
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

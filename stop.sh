#!/bin/bash

# Deactivate the virtual environment if it's active
if [[ "$VIRTUAL_ENV" != "" ]]; then
    deactivate
    echo "Virtual environment deactivated."
fi

# Stop Python processes
pkill -f "python3 backend/app.py"
pkill -f "python3 backend/websocket.py"
echo "Backend stopped"

# Stop the npm process
pkill -f "npm --prefix frontend/ run start"
echo "Frontend stopped"
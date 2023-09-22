#!/bin/bash

# Set the path to your Python virtual environment directory
VENV_DIR="/backend/env"

# Check if the virtual environment directory exists
if [ -d "$VENV_DIR" ]; then
    echo "Virtual environment already exists. Activating..."
    source "$VENV_DIR/bin/activate"
else
    echo "Creating a new virtual environment..."
    python3 -m venv "$VENV_DIR"
    source "$VENV_DIR/bin/activate"
fi

# Install dependencies
pip install -r requirements.txt
npm --prefix frontend/ i 
# Start the application
python backend/app.py &
python backend/websocket.py &
npm --prefix frontend/ run server


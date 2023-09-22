#!/bin/bash

# Set the path to your Python virtual environment directory
VENV_DIR="backend/env"
export FLASK_APP=backend/app.py
export FLASK_ENV=development

DB_URI='sqlite:///messages.db'

# Function to open a new terminal window with the specified command
open_terminal() {
    local command_to_run="$1"

    if command -v x-terminal-emulator &>/dev/null; then
        x-terminal-emulator -e "$command_to_run"
    elif command -v gnome-terminal &>/dev/null; then
        gnome-terminal -- bash -c "$command_to_run"
    elif command -v xterm &>/dev/null; then
        xterm -e "$command_to_run"
    elif command -v konsole &>/dev/null; then
        konsole --hold -e "$command_to_run"
    else
        echo "Error: Could not find a suitable terminal emulator. Please install a compatible terminal emulator."
    fi
}
check_database_exists() {
    flask db current
    return $?
}
# Function to handle SIGINT (Ctrl+C) signal
handle_sigint() {
    echo "Ctrl+C pressed. Stopping processes..."
    
    # Execute the stop.sh script
    ./stop.sh
    
    echo "Processes stopped."
    exit 0
}

# Trap the SIGINT signal and call the handle_sigint function
trap handle_sigint SIGINT

# Function to check if a Python package is installed
package_installed() {
    package_name="$1"
    if pip3 show "$package_name" >/dev/null 2>&1; then
        return 0  # Package is installed
    else
        return 1  # Package is not installed
    fi
}

# Check if the virtual environment directory exists
if [ -d "$VENV_DIR" ]; then
    echo "Virtual environment already exists. Activating..."
    source "$VENV_DIR/bin/activate"
else
    echo "Creating a new virtual environment..."
    python3 -m venv "$VENV_DIR"
    source "$VENV_DIR/bin/activate"
fi

# Read and install packages from requirements.txt
if [ -e "requirements.txt" ]; then
    while read -r package; do
        package_name=$(echo "$package" | awk -F'[=<>]' '{print $1}' | xargs)
        if ! package_installed "$package_name"; then
            echo "$package_name is not installed. Installing..."
            pip3 install "$package"
        fi
    done < "requirements.txt"
else
    echo "requirements.txt not found. Skipping package installation."
fi

# Install dependencies
npm --prefix frontend/ i 

# Check if database exists
if check_database_exists; then
    echo "Database exists. No need to initialize migrations."
else
    echo "Database does not exist. Initializing migrations..."
    flask db init
    flask db migrate -m "Initial migration"
    flask db upgrade
fi

# Start the application
open_terminal "python3 backend/app.py" &
open_terminal "python3 backend/websocket.py "&
open_terminal "npm --prefix frontend/ run start"

wait
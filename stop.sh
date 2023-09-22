#!/bin/bash

pkill -f "python3 backend/app.py"
pkill -f "python3 backend/websocket.py"
echo "Backend stopped"
pkill -f "npm --prefix frontend/ run start"
echo "Frontend stopped"
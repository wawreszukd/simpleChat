#!/bin/bash

export DATABASE_URI="sqlite:///messages.db"
export FLASK_APP="app.py"
export FLASK_ENV="development"
cd backend
check_database_exists() {
    flask db current
    return $?
}
if check_database_exists; then
    echo "Database exists. No need to initialize migrations."
else
    
    echo "Database does not exist. Initializing migrations..."

    flask db init
    flask db migrate -m "Initial migration"
    flask db upgrade
    
fi
cd ..
export DATABASE_URI="sqlite:///backend/instance/messages.db"

#!/bin/bash

# Azure App Service startup script for Django backend
echo "Starting AgriTrace Backend on Azure App Service..."

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --noinput

# Run database migrations
echo "Running database migrations..."
python manage.py migrate

# Start Gunicorn server
echo "Starting Gunicorn server..."
gunicorn --bind=0.0.0.0:8000 --timeout 600 --workers 2 agritrace_project.wsgi:application

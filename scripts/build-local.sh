#!/bin/bash

# Local Build Script for AgriTrace
# This script builds Docker images locally for testing

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Build backend image
build_backend() {
    log_info "Building backend Docker image..."
    docker build -t agritrace-backend:latest ./backend
    log_success "Backend image built successfully"
}

# Build frontend image
build_frontend() {
    log_info "Building frontend Docker image..."
    docker build -t agritrace-frontend:latest ./frontend
    log_success "Frontend image built successfully"
}

# Main function
main() {
    log_info "Starting local build process..."
    
    build_backend
    build_frontend
    
    log_success "All images built successfully! 🎉"
    log_info "You can now run 'docker-compose up' to start the application"
}

# Run main function
main "$@"

#!/bin/bash

# Geometry Jump Local Development Script
# This script helps run the game locally using Docker Compose

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
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

# Help function
show_help() {
    cat << EOF
Geometry Jump Local Development Script

Usage: $0 [OPTION]

Options:
    build          Build Docker image
    up             Start local development environment
    down           Stop local development environment
    logs           Show application logs
    status         Show deployment status
    clean          Clean up Docker resources
    help           Show this help message

Examples:
    $0 build       # Build Docker image
    $0 up          # Start local development
    $0 down        # Stop local development
    $0 logs        # Show logs
    $0 clean       # Clean up resources

EOF
}

# Build Docker image
build_image() {
    log_info "Building Geometry Jump Docker image..."

    # Get version from package.json
    VERSION=$(node -p "require('./package.json').version" 2>/dev/null || echo "latest")
    export VERSION

    # Build with version
    cd deploy
    docker build --build-arg VERSION="$VERSION" -t geometry-jump:"$VERSION" -t geometry-jump:latest -f Dockerfile ..
    cd ..

    log_success "Docker image built successfully! Version: $VERSION"
}

# Start local development environment
start_local() {
    log_info "Starting Geometry Jump local development environment..."

    # Create logs directory
    mkdir -p logs

    # Start with docker-compose
    cd deploy
    VERSION=${VERSION:-$(node -p "require('../package.json').version" 2>/dev/null || echo "latest")} docker-compose up -d
    cd ..

    log_success "Local development environment started!"
    log_info "Game available at: http://localhost:8080"
}

# Stop local development environment
stop_local() {
    log_info "Stopping Geometry Jump local development environment..."

    cd deploy
    docker-compose down
    cd ..

    log_success "Local development environment stopped!"
}

# Show logs
show_logs() {
    cd deploy
    if docker-compose ps | grep -q geometry-jump-game; then
        log_info "Showing Docker logs..."
        docker-compose logs -f geometry-jump
    else
        log_warning "No running deployment found"
        log_info "Start the local environment with: $0 up"
    fi
    cd ..
}

# Show status
show_status() {
    log_info "=== Local Development Status ==="
    cd deploy
    if docker-compose ps | grep -q geometry-jump-game; then
        docker-compose ps
        echo
        log_info "Game URL: http://localhost:8080"
    else
        log_warning "Local development environment not running"
        log_info "Start with: $0 up"
    fi
    cd ..

    # Show version info
    echo
    log_info "=== Version Info ==="
    VERSION=$(node -p "require('./package.json').version" 2>/dev/null || echo "unknown")
    echo "Current version: $VERSION"
}

# Clean up
clean_up() {
    log_info "Cleaning up Geometry Jump local development resources..."

    # Docker cleanup
    cd deploy
    if docker-compose ps | grep -q geometry-jump-game; then
        docker-compose down
        log_success "Docker containers stopped"
    fi
    cd ..

    # Optional: Remove Docker images
    read -p "Remove Docker images? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        VERSION=$(node -p "require('./package.json').version" 2>/dev/null || echo "latest")
        docker rmi geometry-jump:"$VERSION" 2>/dev/null || true
        docker rmi geometry-jump:latest 2>/dev/null || true
        docker rmi nginx:alpine 2>/dev/null || true
        log_success "Docker images removed"
    fi
}

# Main script logic
case "${1:-help}" in
    build)
        build_image
        ;;
    up)
        start_local
        ;;
    down)
        stop_local
        ;;
    logs)
        show_logs
        ;;
    status)
        show_status
        ;;
    clean)
        clean_up
        ;;
    help|*)
        show_help
        ;;
esac

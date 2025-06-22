#!/bin/bash

# Geometry Jump Deployment Script
# This script helps deploy the game using Docker or Kubernetes

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
Geometry Jump Deployment Script

Usage: $0 [OPTION]

Options:
    docker          Deploy using Docker Compose
    k8s            Deploy to Kubernetes
    build          Build Docker image only
    clean          Clean up Docker resources
    logs           Show application logs
    status         Show deployment status
    help           Show this help message

Examples:
    $0 docker      # Deploy with Docker Compose
    $0 k8s         # Deploy to Kubernetes
    $0 build       # Build Docker image
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

# Docker deployment
deploy_docker() {
    log_info "Deploying Geometry Jump with Docker Compose..."
    
    # Create network if it doesn't exist
    if ! docker network ls | grep -q traefik-network; then
        log_info "Creating traefik-network..."
        docker network create traefik-network
    fi
    
    # Create logs directory
    mkdir -p logs
    
    # Deploy with docker-compose
    cd deploy
    VERSION=${VERSION:-$(node -p "require('../package.json').version" 2>/dev/null || echo "latest")} docker-compose up -d
    cd ..
    
    log_success "Deployment complete!"
    log_info "Game available at:"
    log_info "  - Direct access: http://localhost:8080"
    log_info "  - Via Traefik: http://geometry.local (if DNS configured)"
    log_info "  - Traefik dashboard: http://localhost:8090"
}

# Kubernetes deployment
deploy_k8s() {
    log_info "Deploying Geometry Jump to Kubernetes..."
    
    # Check if kubectl is available
    if ! command -v kubectl &> /dev/null; then
        log_error "kubectl is not installed or not in PATH"
        exit 1
    fi
    
    # Build image first
    build_image
    
    # Apply Kubernetes manifests
    log_info "Applying Kubernetes manifests..."
    cd deploy
    kubectl apply -f k8s-deployment.yaml
    kubectl apply -f k8s-traefik-middleware.yaml
    cd ..
    
    # Wait for deployment
    log_info "Waiting for deployment to be ready..."
    kubectl wait --for=condition=available --timeout=300s deployment/geometry-jump
    
    log_success "Kubernetes deployment complete!"
    log_info "Check status with: kubectl get pods,svc,ingress"
}

# Show logs
show_logs() {
    cd deploy
    if docker-compose ps | grep -q geometry-jump-game; then
        log_info "Showing Docker logs..."
        docker-compose logs -f geometry-jump
    elif kubectl get pods | grep -q geometry-jump; then
        log_info "Showing Kubernetes logs..."
        kubectl logs -f deployment/geometry-jump
    else
        log_warning "No running deployment found"
    fi
    cd ..
}

# Show status
show_status() {
    log_info "=== Docker Status ==="
    cd deploy
    if docker-compose ps | grep -q geometry-jump-game; then
        docker-compose ps
        echo
        log_info "Game URL: http://localhost:8080"
    else
        log_warning "Docker deployment not running"
    fi
    cd ..
    
    echo
    log_info "=== Kubernetes Status ==="
    if kubectl get pods 2>/dev/null | grep -q geometry-jump; then
        kubectl get pods,svc,ingress -l app=geometry-jump
    else
        log_warning "Kubernetes deployment not found"
    fi
    
    # Show version info
    echo
    log_info "=== Version Info ==="
    VERSION=$(node -p "require('./package.json').version" 2>/dev/null || echo "unknown")
    echo "Current version: $VERSION"
}

# Clean up
clean_up() {
    log_info "Cleaning up Geometry Jump resources..."
    
    # Docker cleanup
    cd deploy
    if docker-compose ps | grep -q geometry-jump-game; then
        docker-compose down
        log_success "Docker containers stopped"
    fi
    cd ..
    
    # Kubernetes cleanup
    if kubectl get deployment geometry-jump 2>/dev/null; then
        cd deploy
        kubectl delete -f k8s-deployment.yaml
        kubectl delete -f k8s-traefik-middleware.yaml
        cd ..
        log_success "Kubernetes resources deleted"
    fi
    
    # Optional: Remove Docker image
    read -p "Remove Docker image? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker rmi geometry-jump:latest 2>/dev/null || true
        VERSION=$(node -p "require('./package.json').version" 2>/dev/null || echo "latest")
        docker rmi geometry-jump:"$VERSION" 2>/dev/null || true
        log_success "Docker images removed"
    fi
}

# Main script logic
case "${1:-help}" in
    docker)
        build_image
        deploy_docker
        ;;
    k8s)
        deploy_k8s
        ;;
    build)
        build_image
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

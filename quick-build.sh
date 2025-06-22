#!/bin/bash

# Quick development build script for Geometry Jump
# This script ensures you always get the latest changes when building locally

set -e

echo "🚀 Building Geometry Jump with latest changes..."

# Get current directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT"

# Get version
VERSION=$(node -p "require('./package.json').version" 2>/dev/null || echo "dev")
TIMESTAMP=$(date +%s)

echo "📦 Version: $VERSION"
echo "⏰ Build timestamp: $TIMESTAMP"

# Force remove existing images to ensure clean build
echo "🧹 Cleaning existing images..."
docker rmi geometry-jump:$VERSION 2>/dev/null || true
docker rmi geometry-jump:latest 2>/dev/null || true

# Build with no cache to ensure latest changes
echo "🔨 Building Docker image..."
cd deploy
docker build \
    --no-cache \
    --pull \
    --build-arg VERSION="$VERSION" \
    --build-arg CACHEBUST="$TIMESTAMP" \
    -t geometry-jump:$VERSION \
    -t geometry-jump:latest \
    -f Dockerfile ..

echo "✅ Build completed successfully!"
echo "🎮 Run 'cd deploy && docker-compose up' to start the game"
echo "🌐 Game will be available at: http://localhost:8080"

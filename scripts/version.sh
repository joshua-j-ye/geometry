#!/bin/bash

# Version management script for Geometry Jump
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get current version from package.json
get_version() {
    node -p "require('./package.json').version" 2>/dev/null || echo "1.0.0"
}

# Update version in source files
update_version() {
    local version=$1
    echo -e "${BLUE}[INFO]${NC} Updating version to $version in source files..."
    
    # Update version in HTML (fallback)
    sed -i "s|<div class=\"version\" id=\"version\">v.*</div>|<div class=\"version\" id=\"version\">v$version</div>|g" src/index.html
    
    # Update version in game.js (fallback)
    sed -i "s|this.version = '.*';|this.version = '$version';|g" src/game.js
}

case "${1:-get}" in
    get)
        get_version
        ;;
    update)
        VERSION=$(get_version)
        update_version "$VERSION"
        echo -e "${GREEN}[SUCCESS]${NC} Updated source files to version $VERSION"
        ;;
    *)
        echo "Usage: $0 [get|update]"
        echo "  get    - Get current version"
        echo "  update - Update version in source files"
        ;;
esac

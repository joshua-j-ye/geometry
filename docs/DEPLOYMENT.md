# Deployment Guide for Geometry Jump

## Overview

This repository supports both:
1. **Automated Docker Image Building**: GitHub Actions automatically builds and publishes Docker images
2. **Local Development**: Docker Compose setup for local testing and development

## Quick Start

### Local Development with Docker Compose
```bash
# Build Docker image locally
./deploy/deploy.sh build

# Start local development environment
./deploy/deploy.sh up

# Access the game at http://localhost:8080

# Stop the environment
./deploy/deploy.sh down

# View logs
./deploy/deploy.sh logs

# Check status
./deploy/deploy.sh status

# Clean up resources
./deploy/deploy.sh clean
```

## Automated Docker Image Building

### GitHub Actions Pipeline
When you push changes to the `main` branch in these directories:
- `src/` - Game source files
- `deploy/` - Deployment configuration
- `package.json` - Project metadata

The pipeline automatically:
1. **Tests** the game files
2. **Bumps** the version number
3. **Builds** a Docker image with the new version
4. **Publishes** to GitHub Container Registry
5. **Creates** a GitHub release
6. **Updates** deployment files

### Using Published Images
```bash
# Pull latest image
docker pull ghcr.io/joshua-j-ye/geometry/geometry-jump:latest

# Run specific version
docker run -p 8080:80 ghcr.io/joshua-j-ye/geometry/geometry-jump:v1.0.1
```

## Detailed Instructions

### Prerequisites

- Docker and Docker Compose installed
- Port 8080 available (or modify docker-compose.yml)
- Node.js (for local version management)

### Local Development Setup

The deployment script automatically:
1. Creates logs directory for debugging
2. Builds the Docker image with current version
3. Starts nginx serving the game files
4. Configures health checks and logging

### Docker Image Building

#### Local Build:
```bash
# Build image with current version from package.json
./deploy/deploy.sh build

# Build with specific version
VERSION=1.2.3 ./deploy/deploy.sh build
```

#### Automatic Build (CI/CD):
Push changes to trigger automatic building:
```bash
git add src/
git commit -m "✨ Add new game feature"
git push origin main
```

### Configuration

#### Custom Ports
Edit `docker-compose.yml` to change the port:
- Game: Change `"8080:80"` to your preferred port mapping

### Deployment Commands

```bash
# Build Docker image
./deploy/deploy.sh build

# Start local development
./deploy/deploy.sh up

# Stop local development
./deploy/deploy.sh down

# Show status
./deploy/deploy.sh status

# View logs
./deploy/deploy.sh logs

# Clean up everything
./deploy/deploy.sh clean
```

### Architecture

#### Docker Image:
- **Base**: nginx:alpine for lightweight serving
- **Build Args**: VERSION for image versioning
- **Health Checks**: Built-in health endpoint monitoring
- **Multi-arch**: Compatible with different platforms
- **Optimization**: Gzip compression and static asset caching

#### Local Development Setup:
- **Docker Compose**: Simple single-service setup
- **Health Checks**: Monitors application health
- **Logging**: Logs available in `./logs/` directory
- **Direct Access**: Simple http://localhost:8080 access

### Monitoring & Troubleshooting

#### Check Container Health:
```bash
# Check status
./deploy/deploy.sh status

# View logs
./deploy/deploy.sh logs

# Manual Docker commands
docker-compose -f deploy/docker-compose.yml ps
docker-compose -f deploy/docker-compose.yml logs geometry-jump
```

#### Common Issues:
1. **Port conflicts**: Change port mapping in `deploy/docker-compose.yml`
2. **Permission issues**: Ensure Docker has access to the source files
3. **Build failures**: Check Dockerfile syntax and dependencies
4. **Container not starting**: Check logs with `./deploy/deploy.sh logs`

### Performance Optimization

#### Nginx Configuration:
- Gzip compression enabled for better performance
- Static asset caching optimized
- Security headers included
- Health check endpoint at `/health`

#### File Serving:
- Direct mounting of source files for development
- No build step required
- Real-time changes reflected immediately

### Security Features

#### Headers Applied:
- X-Frame-Options: SAMEORIGIN
- X-Content-Type-Options: nosniff
- X-XSS-Protection: 1; mode=block
- Referrer-Policy: no-referrer-when-downgrade

#### Network Security:
- Isolated Docker network (`traefik-network`)
- Local development only (no external exposure by default)

### Development Workflow

1. **Direct Development**: Edit files in `src/` directory
2. **Test Locally**: Open `src/index.html` in browser
3. **Test with Docker**: `./deploy/deploy.sh up`
4. **Monitor**: Check status and logs with deployment script
5. **Cleanup**: `./deploy/deploy.sh clean` when done

### URLs After Deployment

#### Available URLs:
- **Game (Direct)**: http://localhost:8080
- **Game (Traefik)**: http://geometry.local (requires `/etc/hosts` entry)
- **Traefik Dashboard**: http://localhost:8090

### URLs After Deployment

The game will be available at: **http://localhost:8080**

### File Structure

```
deploy/
├── deploy.sh           # Main deployment script
├── docker-compose.yml  # Docker services configuration
├── Dockerfile         # Docker image definition
├── nginx.conf         # Nginx configuration
└── logs/              # Application logs
```

### Notes

- This setup is optimized for simple local development
- For production deployment, use a separate deployment repository
- Kubernetes files have been removed from this repo
- Docker images are automatically built via CI/CD
- Direct access via localhost:8080 - no proxy needed

---

## Next Steps

1. **Build**: `./deploy/deploy.sh build`
2. **Deploy**: `./deploy/deploy.sh up`
3. **Test**: Open http://localhost:8080
4. **Develop**: Edit files in `src/` and rebuild as needed
5. **Publish**: Push changes to trigger automatic image building

Have fun playing with Joshua! 🎮

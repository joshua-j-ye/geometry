# Geometry Jump 🎮

[![Build and Deploy](https://github.com/joshua-j-ye/geometry/actions/workflows/build-and-deploy.yml/badge.svg)](https://github.com/joshua-j-ye/geometry/actions/workflows/build-and-deploy.yml)
[![Docker Image](https://ghcr.io/joshua-j-ye/geometry/geometry-jump:latest)](https://ghcr.io/joshua-j-ye/geometry/geometry-jump)

A simple and fun Geometry Dash-style game built with HTML, CSS, and JavaScript for Joshua and Dad!

## 🚀 Quick Start

### Play Locally
```bash
# Open directly in browser
open src/index.html

# Or serve with Node.js
npm install
npm start
```

### Deploy with Docker
```bash
# Build and run
./deploy/deploy.sh docker

# Access at http://localhost:8080
```

### Deploy to Kubernetes
```bash
# Deploy to K8s with Traefik
./deploy/deploy.sh k8s
```

## 📁 Project Structure

```
geometry-jump/
├── src/                    # Game source code
│   ├── index.html         # Main HTML file
│   ├── style.css          # Game styling
│   └── game.js            # Game logic
├── deploy/                # Deployment files
│   ├── Dockerfile         # Container definition
│   ├── docker-compose.yml # Docker Compose setup
│   ├── k8s-*.yaml        # Kubernetes manifests
│   ├── nginx.conf         # Web server config
│   └── deploy.sh          # Deployment script
├── docs/                  # Documentation
│   ├── README.md          # Game documentation
│   ├── DEVELOPMENT_LOG.md # Development history
│   └── DEPLOYMENT.md      # Deployment guide
├── scripts/               # Utility scripts
│   └── version.sh         # Version management
├── .github/workflows/     # CI/CD pipelines
│   └── build-and-deploy.yml
└── package.json           # Project metadata
```

## 🎮 Game Features

- **Simple Controls**: Press SPACE or click to jump
- **Progressive Difficulty**: Speed increases over time
- **Score System**: Points for surviving obstacles
- **High Score Tracking**: Persistent local storage
- **Mobile Friendly**: Responsive design for all devices
- **Version Display**: Shows current game version

## 🔄 Automated CI/CD

The project includes a GitHub Actions workflow that:

1. **🧪 Tests**: Validates HTML/CSS/JS syntax
2. **📦 Builds**: Creates Docker image with version tag
3. **🚀 Deploys**: Publishes to GitHub Container Registry
4. **📋 Releases**: Creates GitHub releases automatically
5. **🔄 Updates**: Bumps version numbers automatically

### Trigger Deployment
Just push changes to the `main` branch in the `src/` or `deploy/` directories!

```bash
git add src/
git commit -m "✨ Add new game feature"
git push origin main
```

## 🏗️ Development Workflow

### Local Development
```bash
# Install dependencies
npm install

# Start development server
npm start

# Build Docker image
npm run build
```

### Version Management
```bash
# Get current version
./scripts/version.sh get

# Update version in source files
./scripts/version.sh update

# Bump version (patch)
npm run version:patch

# Bump version (minor)
npm run version:minor
```

### Deployment Commands
```bash
# Docker deployment
./deploy/deploy.sh docker

# Kubernetes deployment
./deploy/deploy.sh k8s

# Check status
./deploy/deploy.sh status

# View logs
./deploy/deploy.sh logs

# Clean up
./deploy/deploy.sh clean
```

## 🐳 Docker Images

Images are automatically built and published to GitHub Container Registry:

```bash
# Pull latest
docker pull ghcr.io/joshua-j-ye/geometry/geometry-jump:latest

# Run specific version
docker run -p 8080:80 ghcr.io/joshua-j-ye/geometry/geometry-jump:v1.0.1
```

## 📊 Monitoring

### Health Checks
- Container health endpoint: `/health`
- Version information: `/version.json`
- Application logs via Docker/Kubernetes

### Performance
- Nginx with gzip compression
- Static asset caching
- Minimal resource usage (64Mi RAM)

## 🛡️ Security Features

- Security headers (XSS, CSRF protection)
- HTTPS with automatic certificates
- Read-only filesystem
- Non-root container execution

## 🎯 Future Enhancements

- [ ] 🎵 Sound effects and music
- [ ] 🌟 Power-ups and abilities
- [ ] 🎨 Multiple character skins
- [ ] 🏅 Achievement system
- [ ] 🌍 Different levels
- [ ] 👥 Multiplayer features
- [ ] 📊 Analytics dashboard

## 📈 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes in `src/`
4. Test locally with `npm start`
5. Push to trigger automatic build
6. Create a pull request

## 📄 License

MIT License - Built with ❤️ for Joshua & Dad

## 🔗 Links

- **Documentation**: [docs/README.md](docs/README.md)
- **Deployment Guide**: [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md)
- **Development Log**: [docs/DEVELOPMENT_LOG.md](docs/DEVELOPMENT_LOG.md)
- **Container Registry**: [GitHub Packages](https://ghcr.io/joshua-j-ye/geometry)

---

*Made with ❤️ by Dad for Joshua - Happy Gaming! 🎮*

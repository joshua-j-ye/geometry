# Geometry Jump 🎮

[![Build and Deploy](https://github.com/jos## 🔄 Automated CI/CD

The project includes a GitHub Actions workflow that automatically:

1. **🧪 Tests**: Validates HTML/CSS/JS syntax
2. **📈 Versions**: Auto-bumps version numbers
3. **📦 Builds**: Creates Docker image with version tag
4. **🚀 Publishes**: Pushes to GitHub Container Registry
5. **📋 Releases**: Creates GitHub releases automatically
6. **🔄 Updates**: Updates deployment files

### Trigger Automated Build
Push changes to the `main` branch in `src/`, `deploy/`, or `package.json`:

```bash
git add src/
git commit -m "✨ Add new game feature"
git push origin main
```

### Using Published Images
```bash
# Pull latest image
docker pull ghcr.io/joshua-j-ye/geometry/geometry-jump:latest

# Run specific version
docker run -p 8080:80 ghcr.io/joshua-j-ye/geometry/geometry-jump:v1.0.1
```/actions/workflows/build-and-deploy.yml/badge.svg)](https://github.com/joshua-j-ye/geometry/actions/workflows/build-and-deploy.yml)
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

### Deploy for Local Development
```bash
# Build and start local development environment
./deploy/deploy.sh build
./deploy/deploy.sh up

# Access at http://localhost:8080
```

## 📁 Project Structure

```
geometry-jump/
├── src/                    # Game source code
│   ├── index.html         # Main HTML file
│   ├── style.css          # Game styling
│   └── game.js            # Game logic
├── deploy/                # Deployment files
│   ├── Dockerfile         # Docker image definition
│   ├── docker-compose.yml # Docker Compose setup
│   ├── nginx.conf         # Web server config
│   ├── deploy.sh          # Deployment script
│   ├── logs/              # Application logs
│   └── letsencrypt/       # SSL certificates
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

## 🔄 Local Development

The project includes a simple local development setup:

1. **📂 Direct**: Open `src/index.html` in your browser
2. **� Docker**: Use Docker Compose for containerized development
3. **� Live Editing**: Files are served directly from source directory
4. **� Monitoring**: Built-in Traefik dashboard and health checks

### Start Local Development
Just run the deployment script:

```bash
./deploy/deploy.sh up
```

Access the game at http://localhost:8080 or http://geometry.local (with DNS setup).

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

### Local Development Commands
```bash
# Build Docker image
./deploy/deploy.sh build

# Start local development
./deploy/deploy.sh up

# Stop local development
./deploy/deploy.sh down

# Check status
./deploy/deploy.sh status

# View logs
./deploy/deploy.sh logs

# Clean up
./deploy/deploy.sh clean
```

# Clean up
./deploy/deploy.sh clean
```

## 🐳 Docker Images

Images are automatically built and published to GitHub Container Registry:

```bash
# Pull latest image
docker pull ghcr.io/joshua-j-ye/geometry/geometry-jump:latest

# Run specific version
docker run -p 8080:80 ghcr.io/joshua-j-ye/geometry/geometry-jump:v1.0.1

# Build locally
./deploy/deploy.sh build
```

## 📊 Monitoring & Development

### Local Development Features
- Docker image building with versioning
- Container health checks at `/health`
- Version information at `/version.json`
- Application logs in `deploy/logs/`
- Simple direct access via localhost

### Performance
- Nginx with gzip compression
- Static asset caching
- Optimized Docker image
- Fast startup times

## 🛡️ Security Features

- Security headers (XSS, CSRF protection)
- Isolated Docker network
- Health check endpoints
- Read-only file serving

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
4. Test locally with `./deploy/deploy.sh build && ./deploy/deploy.sh up`
5. Push to trigger automatic build and publish
6. Submit a pull request

## 📄 License

MIT License - Built with ❤️ for Joshua & Dad

## 🔗 Links

- **Documentation**: [docs/README.md](docs/README.md)
- **Deployment Guide**: [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md)
- **Development Log**: [docs/DEVELOPMENT_LOG.md](docs/DEVELOPMENT_LOG.md)
- **Container Registry**: [GitHub Packages](https://ghcr.io/joshua-j-ye/geometry)

---

*Made with ❤️ by Dad for Joshua - Happy Gaming! 🎮*

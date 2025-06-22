# Deployment Guide for Geometry Jump

## Quick Start

### Option 1: Docker Compose (Recommended for Home Server)
```bash
# Build and deploy with one command
./deploy.sh docker

# Access the game
# Direct: http://localhost:8080
# Via Traefik: http://geometry.local (configure DNS)
```

### Option 2: Kubernetes
```bash
# Deploy to K8s cluster
./deploy.sh k8s

# Check status
kubectl get pods,svc,ingress -l app=geometry-jump
```

## Detailed Instructions

### Prerequisites

#### For Docker:
- Docker and Docker Compose installed
- Port 8080 available (or modify docker-compose.yml)

#### For Kubernetes:
- kubectl configured with cluster access
- Traefik ingress controller installed
- (Optional) cert-manager for SSL certificates

### Configuration

#### Domain Setup
Edit these files to match your domain:
- `docker-compose.yml`: Change `geometry.yourdomain.com`
- `k8s-deployment.yaml`: Update host names in Ingress
- `k8s-traefik-middleware.yaml`: Update IngressRoute hosts

#### SSL/HTTPS Setup
1. **Docker**: Update email in docker-compose.yml for Let's Encrypt
2. **Kubernetes**: Ensure cert-manager is configured

### Deployment Commands

```bash
# Build Docker image only
./deploy.sh build

# Deploy with Docker Compose
./deploy.sh docker

# Deploy to Kubernetes  
./deploy.sh k8s

# Show deployment status
./deploy.sh status

# View logs
./deploy.sh logs

# Clean up everything
./deploy.sh clean
```

### Architecture

#### Docker Setup:
- **Nginx**: Serves static files with optimization
- **Traefik**: Reverse proxy with automatic HTTPS
- **Health Checks**: Monitors application health
- **Logging**: Centralized log collection

#### Kubernetes Setup:
- **Deployment**: 2 replicas with auto-scaling
- **Service**: ClusterIP for internal communication
- **Ingress**: Traefik-based routing with SSL
- **HPA**: Auto-scaling based on CPU/memory
- **Middleware**: Compression and security headers

### Monitoring & Troubleshooting

#### Check Container Health:
```bash
# Docker
docker-compose ps
docker-compose logs geometry-jump

# Kubernetes
kubectl get pods -l app=geometry-jump
kubectl logs deployment/geometry-jump
```

#### Common Issues:
1. **Port conflicts**: Change ports in docker-compose.yml
2. **DNS resolution**: Add entries to /etc/hosts or configure DNS
3. **SSL issues**: Check cert-manager configuration
4. **Traefik not routing**: Verify labels and annotations

### Performance Optimization

#### Nginx Configuration:
- Gzip compression enabled
- Static asset caching (1 year)
- Security headers included
- Health check endpoint

#### Resource Limits:
- **Memory**: 64Mi request, 128Mi limit
- **CPU**: 50m request, 100m limit
- **Scaling**: 2-5 replicas based on load

### Security Features

#### Headers Applied:
- X-Frame-Options: SAMEORIGIN
- X-Content-Type-Options: nosniff
- X-XSS-Protection: 1; mode=block
- Referrer-Policy: no-referrer-when-downgrade
- Strict-Transport-Security (HTTPS only)

#### Network Security:
- Isolated Docker network
- Kubernetes network policies (optional)
- TLS termination at ingress

### Backup & Persistence

The game uses localStorage for high scores, so no database backup needed. However, consider:

1. **Container logs**: Mounted to `./logs/` directory
2. **SSL certificates**: Stored in `./letsencrypt/`
3. **Configuration**: Version controlled in git

### Scaling Considerations

#### Horizontal Scaling:
- Stateless application - scales easily
- Load balancer distributes traffic
- Session data stored client-side

#### Vertical Scaling:
- Increase resource limits in deployment files
- Monitor resource usage with `kubectl top pods`

### Development Workflow

1. **Local Testing**: Open index.html in browser
2. **Docker Testing**: `./deploy.sh docker`
3. **Production Deploy**: `./deploy.sh k8s`
4. **Monitor**: `./deploy.sh status` and `./deploy.sh logs`

### URLs After Deployment

#### Docker Compose:
- **Game**: http://localhost:8080
- **Traefik Dashboard**: http://localhost:8090
- **Custom Domain**: http://geometry.local (with DNS)

#### Kubernetes:
- **Game**: https://geometry.yourdomain.com
- **Local**: http://geometry.local (with ingress)

---

## Next Steps

1. **Deploy**: Choose Docker or Kubernetes
2. **Test**: Verify game works correctly
3. **Monitor**: Check logs and performance
4. **Scale**: Adjust resources as needed
5. **Enhance**: Add monitoring, backup strategies

Have fun playing with Joshua! 🎮

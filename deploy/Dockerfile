# Use nginx alpine for lightweight web server
FROM nginx:alpine

# Install curl for health check
RUN apk add --no-cache curl

# Set build argument for version
ARG VERSION=latest
ENV APP_VERSION=${VERSION}

# Copy game files to nginx html directory
COPY src/index.html /usr/share/nginx/html/
COPY src/style.css /usr/share/nginx/html/
COPY src/game.js /usr/share/nginx/html/
COPY docs/README.md /usr/share/nginx/html/

# Copy custom nginx configuration
COPY deploy/nginx.conf /etc/nginx/nginx.conf

# Add version info endpoint
RUN echo "{\"version\":\"${VERSION}\",\"build_date\":\"$(date -u +%Y-%m-%dT%H:%M:%S.%3NZ)\"}" > /usr/share/nginx/html/version.json

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

# Run nginx
CMD ["nginx", "-g", "daemon off;"]

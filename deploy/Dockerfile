# Use nginx alpine for lightweight web server
FROM nginx:alpine

# Install curl for health check
RUN apk add --no-cache curl

# Set build argument for version
ARG VERSION=latest
ENV APP_VERSION=${VERSION}

# Copy custom nginx configuration first (changes less frequently)
COPY deploy/nginx.conf /etc/nginx/nginx.conf

# Copy documentation (changes less frequently)
COPY docs/README.md /usr/share/nginx/html/

# Copy game files to nginx html directory (copy each file separately for better caching)
# These should be copied last as they change most frequently
COPY src/index.html /usr/share/nginx/html/
COPY src/style.css /usr/share/nginx/html/
COPY src/game.js /usr/share/nginx/html/

# Add version info endpoint with cache busting
ARG CACHEBUST=1
RUN echo "{\"version\":\"${VERSION}\",\"build_date\":\"$(date -u +%Y-%m-%dT%H:%M:%S.%3NZ)\",\"cache_bust\":\"${CACHEBUST}\"}" > /usr/share/nginx/html/version.json

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

# Run nginx
CMD ["nginx", "-g", "daemon off;"]

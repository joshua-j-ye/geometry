# Use nginx alpine for lightweight web server
FROM nginx:alpine

# Install curl for health check
RUN apk add --no-cache curl

# Set build arguments for version and cache busting
ARG VERSION=latest
ARG CACHEBUST=1
ENV APP_VERSION=${VERSION}

# Copy custom nginx configuration
COPY deploy/nginx.conf /etc/nginx/nginx.conf

# Copy documentation
COPY docs/README.md /usr/share/nginx/html/

# Cache bust to ensure fresh files
RUN echo "Cache bust: ${CACHEBUST}" > /tmp/cachebust

# Copy game files - these change most frequently
COPY src/ /usr/share/nginx/html/

# Add version info endpoint
RUN echo "{\"version\":\"${VERSION}\",\"build_date\":\"$(date -u +%Y-%m-%dT%H:%M:%S.%3NZ)\",\"cache_bust\":\"${CACHEBUST}\"}" > /usr/share/nginx/html/version.json

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

# Run nginx
CMD ["nginx", "-g", "daemon off;"]

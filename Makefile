# Geometry Jump - Makefile for easy commands

.PHONY: help install start build docker k8s test clean status logs version

# Default target
help: ## Show this help message
	@echo "Geometry Jump - Available Commands:"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

install: ## Install dependencies
	npm install

start: ## Start development server
	npm start

test: ## Run basic tests
	@echo "Testing game files..."
	@test -f src/index.html && echo "✓ HTML file exists"
	@test -f src/style.css && echo "✓ CSS file exists"
	@test -f src/game.js && echo "✓ JS file exists"
	@node -c src/game.js && echo "✓ JavaScript syntax OK"

build: ## Build Docker image
	./deploy/deploy.sh build

docker: ## Deploy with Docker Compose
	./deploy/deploy.sh up

docker-run: ## Start Docker containers
	./deploy/deploy.sh up

docker-stop: ## Stop Docker containers
	./deploy/deploy.sh down

status: ## Show deployment status
	./deploy/deploy.sh status

logs: ## Show application logs
	./deploy/deploy.sh logs

clean: ## Clean up deployments
	./deploy/deploy.sh clean

version: ## Show current version
	@echo "Current version: $$(./scripts/version.sh get)"

version-patch: ## Bump patch version
	npm run version:patch
	./scripts/version.sh update

version-minor: ## Bump minor version
	npm run version:minor
	./scripts/version.sh update

version-major: ## Bump major version
	npm run version:major
	./scripts/version.sh update

dev: ## Start development mode
	@echo "🎮 Starting Geometry Jump development..."
	@echo "📁 Game files: src/"
	@echo "🌐 Opening browser..."
	npm start

release: ## Create a new release (bump version, build, deploy)
	make version-patch
	make build
	@echo "🚀 Ready for deployment!"
	@echo "Push to main branch to trigger CI/CD"

# Docker shortcuts
docker-build: build ## Alias for build

docker-logs: ## Show Docker logs
	./deploy/deploy.sh logs

# Utility commands
open: ## Open game in browser
	@echo "🎮 Opening Geometry Jump..."
	@if command -v open >/dev/null 2>&1; then \
		open src/index.html; \
	elif command -v xdg-open >/dev/null 2>&1; then \
		xdg-open src/index.html; \
	else \
		echo "Please open src/index.html in your browser"; \
	fi

serve: ## Serve game locally (simple Python server)
	@echo "🌐 Serving game at http://localhost:8000"
	@cd src && python3 -m http.server 8000

lint: ## Basic linting
	@echo "🔍 Checking code quality..."
	@if command -v htmlhint >/dev/null 2>&1; then \
		htmlhint src/index.html; \
	else \
		echo "HTML file exists: $$(test -f src/index.html && echo 'OK' || echo 'MISSING')"; \
	fi
	@node -c src/game.js && echo "✓ JavaScript syntax OK"

info: ## Show project information
	@echo "🎮 Geometry Jump Project Info"
	@echo "=========================="
	@echo "Version: $$(./scripts/version.sh get)"
	@echo "Structure:"
	@echo "  📁 src/        - Game source code"
	@echo "  📁 deploy/     - Deployment files"
	@echo "  📁 docs/       - Documentation"
	@echo "  📁 scripts/    - Utility scripts"
	@echo ""
	@echo "Quick commands:"
	@echo "  make start     - Start development"
	@echo "  make docker    - Deploy with Docker"
	@echo "  make status    - Check deployment status"

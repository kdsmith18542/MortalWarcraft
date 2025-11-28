#!/bin/bash
# Initialize git repository and prepare for first commit

set -e

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║        🔧 Git Repository Initialization 🔧                    ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed. Please install it first."
    exit 1
fi

# Initialize git if not already initialized
if [ ! -d .git ]; then
    echo "📦 Initializing git repository..."
    git init
    echo "✅ Git repository initialized"
else
    echo "✅ Git repository already exists"
fi

# Configure git (if not already configured)
if [ -z "$(git config user.name)" ]; then
    echo ""
    echo "⚙️  Git user configuration not found."
    echo "Please configure git user:"
    echo "  git config user.name 'Your Name'"
    echo "  git config user.email 'your.email@example.com'"
    echo ""
    read -p "Configure now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "Enter your name: " GIT_NAME
        read -p "Enter your email: " GIT_EMAIL
        git config user.name "$GIT_NAME"
        git config user.email "$GIT_EMAIL"
        echo "✅ Git user configured"
    fi
fi

# Add .gitignore
if [ -f .gitignore ]; then
    echo ""
    echo "📝 Adding .gitignore..."
    git add .gitignore
    echo "✅ .gitignore added"
fi

# Add .gitattributes
if [ -f .gitattributes ]; then
    echo ""
    echo "📝 Adding .gitattributes..."
    git add .gitattributes
    echo "✅ .gitattributes added"
fi

# Stage key files
echo ""
echo "📦 Staging key files..."

# Documentation
git add README.md
git add DOCKER_MIGRATION_GUIDE.md
git add GPU_SERVER_DEPLOYMENT.md
git add docs/

# Docker files
git add docker-compose.yml
git add docker-compose.gpu.yml
git add .dockerignore

# Deployment scripts
git add deploy-to-gpu-server.sh
git add gpu-server-setup.sh
git add remote-build.sh
git add remote-monitor.sh
git add docker-export.sh
git add cleanup-old-docs.sh

# Dockerfiles
git add webportal/backend/Dockerfile
git add webportal/frontend/Dockerfile

# Configuration
git add config/

echo "✅ Key files staged"

# Show status
echo ""
echo "📊 Git Status:"
git status --short | head -30

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║        ✅ Git Repository Ready! ✅                            ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
echo "║                                                               ║"
echo "║  📋 Next Steps:                                              ║"
echo "║                                                               ║"
echo "║  1. Review staged files:                                      ║"
echo "║     git status                                               ║"
echo "║                                                               ║"
echo "║  2. Add more files if needed:                                 ║"
echo "║     git add <file>                                           ║"
echo "║                                                               ║"
echo "║  3. Commit changes:                                           ║"
echo "║     git commit -F COMMIT_MESSAGE.txt                         ║"
echo "║                                                               ║"
echo "║  4. Add remote (if needed):                                   ║"
echo "║     git remote add origin <repository-url>                   ║"
echo "║                                                               ║"
echo "║  5. Push to remote:                                           ║"
echo "║     git push -u origin main                                  ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"


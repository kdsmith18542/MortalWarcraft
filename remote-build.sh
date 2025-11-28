#!/bin/bash
# Remote build script - builds on GPU server with maximum parallelism
# Usage: ./remote-build.sh [service]

set -e

SERVER_IP="209.208.28.192"
SERVER_USER="root"
SERVER_PASS="3pW5hEdzTFGfU9qT"
REMOTE_DIR="/opt/mortal-warcraft"
SERVICE="${1:-all}"

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║        🔨 Remote Build on GPU Server 🔨                      ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
echo ""

# Check if sshpass is installed
if ! command -v sshpass &> /dev/null; then
    echo "📦 Installing sshpass..."
    sudo apt-get update && sudo apt-get install -y sshpass
fi

echo "🚀 Starting build on GPU server (28 cores, 240GB RAM)..."
echo ""

if [ "$SERVICE" = "all" ]; then
    sshpass -p "${SERVER_PASS}" ssh -o StrictHostKeyChecking=no "${SERVER_USER}@${SERVER_IP}" << ENDSSH
        cd ${REMOTE_DIR}
        echo "Building all services with maximum parallelism..."
        DOCKER_BUILDKIT=1 docker-compose build --parallel --build-arg BUILDKIT_INLINE_CACHE=1
        echo "✅ Build complete!"
ENDSSH
else
    sshpass -p "${SERVER_PASS}" ssh -o StrictHostKeyChecking=no "${SERVER_USER}@${SERVER_IP}" << ENDSSH
        cd ${REMOTE_DIR}
        echo "Building ${SERVICE} service..."
        DOCKER_BUILDKIT=1 docker-compose build --parallel --build-arg BUILDKIT_INLINE_CACHE=1 ${SERVICE}
        echo "✅ Build complete!"
ENDSSH
fi

echo ""
echo "✅ Remote build completed!"


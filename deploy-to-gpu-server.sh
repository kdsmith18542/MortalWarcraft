#!/bin/bash
# Automated deployment script for GPU compute server
# Server: 209.208.28.192
# Specs: 28 vCPU, 240GB RAM, 2400GB Disk

set -e

SERVER_IP="209.208.28.192"
SERVER_USER="root"
SERVER_PASS="3pW5hEdzTFGfU9qT"
REMOTE_DIR="/opt/mortal-warcraft"
LOCAL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║        🚀 GPU Server Deployment Script 🚀                      ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
echo ""

# Check if sshpass is installed
if ! command -v sshpass &> /dev/null; then
    echo "📦 Installing sshpass..."
    sudo apt-get update && sudo apt-get install -y sshpass
fi

# Test connection
echo "🔌 Testing connection to ${SERVER_IP}..."
if ! sshpass -p "${SERVER_PASS}" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 "${SERVER_USER}@${SERVER_IP}" "echo 'Connection successful'" 2>/dev/null; then
    echo "❌ Failed to connect to server. Please check:"
    echo "   - Server is fully provisioned"
    echo "   - IP address is correct"
    echo "   - SSH is enabled"
    exit 1
fi
echo "✅ Connection successful"

# Install dependencies on remote server
echo ""
echo "📦 Installing dependencies on remote server..."
sshpass -p "${SERVER_PASS}" ssh -o StrictHostKeyChecking=no "${SERVER_USER}@${SERVER_IP}" << 'ENDSSH'
    # Update system
    apt-get update -y
    
    # Install Docker
    if ! command -v docker &> /dev/null; then
        echo "Installing Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
        systemctl enable docker
        systemctl start docker
    fi
    
    # Install Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        echo "Installing Docker Compose..."
        curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
    fi
    
    # Install other utilities
    apt-get install -y git rsync htop iotop nethogs
    
    # Configure Docker for high performance
    mkdir -p /etc/docker
    cat > /etc/docker/daemon.json << 'EOF'
{
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "10m",
        "max-file": "3"
    },
    "storage-driver": "overlay2",
    "max-concurrent-downloads": 10,
    "max-concurrent-uploads": 10
}
EOF
    systemctl restart docker
    
    echo "✅ Dependencies installed"
ENDSSH

# Create remote directory
echo ""
echo "📁 Creating remote directory..."
sshpass -p "${SERVER_PASS}" ssh -o StrictHostKeyChecking=no "${SERVER_USER}@${SERVER_IP}" "mkdir -p ${REMOTE_DIR}"

# Transfer project files (excluding large files)
echo ""
echo "📤 Transferring project files..."
rsync -avz --progress \
    --exclude='.git' \
    --exclude='node_modules' \
    --exclude='target' \
    --exclude='build' \
    --exclude='*.log' \
    --exclude='gameclientfiles' \
    --exclude='db_backup' \
    --exclude='archive_*' \
    -e "sshpass -p '${SERVER_PASS}' ssh -o StrictHostKeyChecking=no" \
    "${LOCAL_DIR}/" "${SERVER_USER}@${SERVER_IP}:${REMOTE_DIR}/"

# Transfer gameclientfiles separately (with progress)
echo ""
echo "📤 Transferring game client files (this may take a while)..."
if [ -d "${LOCAL_DIR}/gameclientfiles" ]; then
    rsync -avz --progress \
        -e "sshpass -p '${SERVER_PASS}' ssh -o StrictHostKeyChecking=no" \
        "${LOCAL_DIR}/gameclientfiles/" "${SERVER_USER}@${SERVER_IP}:${REMOTE_DIR}/gameclientfiles/"
fi

# Setup on remote server
echo ""
echo "🔧 Setting up on remote server..."
sshpass -p "${SERVER_PASS}" ssh -o StrictHostKeyChecking=no "${SERVER_USER}@${SERVER_IP}" << ENDSSH
    cd ${REMOTE_DIR}
    
    # Create .env file
    if [ ! -f .env ]; then
        cat > .env << 'EOF'
# MySQL Configuration
MYSQL_ROOT_PASSWORD=mwdbpass
MYSQL_PORT=3306

# Server Ports
AUTHSERVER_PORT=3724
WORLDSERVER_PORT=8085
SOAP_PORT=7878

# Webportal Ports
WEBPORTAL_BACKEND_PORT=8080
WEBPORTAL_FRONTEND_PORT=3000

# Docker User
DOCKER_USER_ID=1000
DOCKER_GROUP_ID=1000
DOCKER_USER=acore

# JWT Secret
JWT_SECRET=$(openssl rand -base64 32)
EOF
        echo "✅ Created .env file"
    fi
    
    # Set permissions
    chmod +x docker-export.sh 2>/dev/null || true
    
    # Create optimized docker-compose override
    cat > docker-compose.override.yml << 'EOF'
version: '3.8'

services:
  mysql:
    deploy:
      resources:
        limits:
          cpus: '4'
          memory: 8G
        reservations:
          cpus: '2'
          memory: 4G

  authserver:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 4G
        reservations:
          cpus: '1'
          memory: 2G

  worldserver:
    deploy:
      resources:
        limits:
          cpus: '8'
          memory: 16G
        reservations:
          cpus: '4'
          memory: 8G
    environment:
      - AC_BUILD_PARALLEL=28

  webportal-backend:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 4G
        reservations:
          cpus: '1'
          memory: 2G

  webportal-frontend:
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 2G
        reservations:
          cpus: '0.5'
          memory: 1G
EOF
    echo "✅ Created docker-compose.override.yml"
    
    echo "✅ Setup complete"
ENDSSH

# Export and transfer database
echo ""
echo "💾 Exporting database..."
if [ -d "${LOCAL_DIR}/db_backup" ] && [ "$(ls -A ${LOCAL_DIR}/db_backup/*.sql 2>/dev/null)" ]; then
    echo "📤 Transferring database backups..."
    rsync -avz --progress \
        -e "sshpass -p '${SERVER_PASS}' ssh -o StrictHostKeyChecking=no" \
        "${LOCAL_DIR}/db_backup/" "${SERVER_USER}@${SERVER_IP}:${REMOTE_DIR}/db_backup/"
else
    echo "⚠️  No database backups found. You'll need to export manually."
fi

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║        ✅ Deployment Complete! ✅                             ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
echo "║                                                               ║"
echo "║  Next steps on remote server:                                ║"
echo "║  1. SSH: ssh root@${SERVER_IP}                                ║"
echo "║  2. cd ${REMOTE_DIR}                                           ║"
echo "║  3. docker-compose build (first time)                        ║"
echo "║  4. docker-compose up -d                                      ║"
echo "║  5. Import database if needed                                ║"
echo "║                                                               ║"
echo "║  Quick commands:                                              ║"
echo "║  • View logs: docker-compose logs -f worldserver            ║"
echo "║  • Check status: docker-compose ps                           ║"
echo "║  • Restart: docker-compose restart worldserver              ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"


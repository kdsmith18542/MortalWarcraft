#!/bin/bash
# Setup script to run on GPU server after deployment
# Run this on the remote server: bash gpu-server-setup.sh

set -e

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║        🚀 GPU Server Setup Script 🚀                          ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
echo ""

# Detect number of CPUs
CPU_COUNT=$(nproc)
echo "💻 Detected ${CPU_COUNT} CPU cores"

# Update system
echo ""
echo "📦 Updating system..."
apt-get update -y
apt-get upgrade -y

# Install Docker if not present
if ! command -v docker &> /dev/null; then
    echo "🐳 Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    systemctl enable docker
    systemctl start docker
    echo "✅ Docker installed"
else
    echo "✅ Docker already installed"
fi

# Install Docker Compose if not present
if ! command -v docker-compose &> /dev/null; then
    echo "🐳 Installing Docker Compose..."
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    echo "✅ Docker Compose installed"
else
    echo "✅ Docker Compose already installed"
fi

# Optimize Docker for high-performance build
echo ""
echo "⚙️  Optimizing Docker configuration..."
mkdir -p /etc/docker
cat > /etc/docker/daemon.json << EOF
{
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "50m",
        "max-file": "5"
    },
    "storage-driver": "overlay2",
    "max-concurrent-downloads": 20,
    "max-concurrent-uploads": 20,
    "default-ulimits": {
        "nofile": {
            "Name": "nofile",
            "Hard": 65536,
            "Soft": 65536
        }
    }
}
EOF
systemctl restart docker
echo "✅ Docker optimized"

# Install build dependencies
echo ""
echo "📦 Installing build dependencies..."
apt-get install -y \
    build-essential \
    cmake \
    git \
    libmysqlclient-dev \
    libssl-dev \
    libbz2-dev \
    libreadline-dev \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    liblzma-dev \
    libzstd-dev \
    curl \
    wget \
    htop \
    iotop \
    nethogs \
    screen \
    tmux

echo "✅ Build dependencies installed"

# Configure system limits for high-performance builds
echo ""
echo "⚙️  Configuring system limits..."
cat >> /etc/security/limits.conf << EOF
* soft nofile 65536
* hard nofile 65536
* soft nproc 32768
* hard nproc 32768
EOF

# Optimize kernel parameters
cat >> /etc/sysctl.conf << EOF
# Network optimizations
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.ipv4.tcp_rmem = 4096 87380 134217728
net.ipv4.tcp_wmem = 4096 65536 134217728
net.core.netdev_max_backlog = 5000

# File system optimizations
vm.swappiness = 10
vm.dirty_ratio = 60
vm.dirty_background_ratio = 2
EOF
sysctl -p

echo "✅ System limits configured"

# Create swap if needed (for safety, though 240GB RAM should be enough)
if [ ! -f /swapfile ]; then
    echo ""
    echo "💾 Creating swap file (16GB)..."
    fallocate -l 16G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
    echo "✅ Swap file created"
else
    echo "✅ Swap file already exists"
fi

# Setup monitoring script
echo ""
echo "📊 Creating monitoring script..."
cat > /usr/local/bin/mortal-status << 'EOF'
#!/bin/bash
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║        📊 Mortal Warcraft Server Status 📊                    ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
echo ""
echo "🐳 Docker Services:"
docker-compose ps
echo ""
echo "💻 System Resources:"
echo "CPU: $(nproc) cores"
echo "RAM: $(free -h | awk '/^Mem:/ {print $2 " total, " $3 " used, " $7 " available"}')"
echo "Disk: $(df -h / | awk 'NR==2 {print $2 " total, " $3 " used, " $4 " available"}')"
echo ""
echo "📊 Container Stats (last 5 seconds):"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}" $(docker-compose ps -q)
echo ""
echo "🌐 Network Ports:"
netstat -tuln | grep -E ":(3724|8085|7878|8080|3000|3306)" || echo "No services listening on expected ports"
echo ""
echo "╚═══════════════════════════════════════════════════════════════╝"
EOF
chmod +x /usr/local/bin/mortal-status
echo "✅ Monitoring script created (run: mortal-status)"

# Create quick commands script
echo ""
echo "📝 Creating quick commands..."
cat > /usr/local/bin/mortal << 'EOF'
#!/bin/bash
cd /opt/mortal-warcraft || exit 1

case "$1" in
    start)
        docker-compose up -d
        ;;
    stop)
        docker-compose down
        ;;
    restart)
        docker-compose restart
        ;;
    logs)
        docker-compose logs -f "${2:-worldserver}"
        ;;
    build)
        docker-compose build --parallel
        ;;
    status)
        mortal-status
        ;;
    shell)
        docker-compose exec "${2:-worldserver}" /bin/bash
        ;;
    *)
        echo "Usage: mortal {start|stop|restart|logs|build|status|shell}"
        echo "Examples:"
        echo "  mortal start              - Start all services"
        echo "  mortal logs worldserver   - View worldserver logs"
        echo "  mortal shell worldserver  - Open shell in worldserver container"
        exit 1
        ;;
esac
EOF
chmod +x /usr/local/bin/mortal
echo "✅ Quick commands created (run: mortal start|stop|logs|status)"

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║        ✅ GPU Server Setup Complete! ✅                       ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
echo "║                                                               ║"
echo "║  Quick Commands:                                             ║"
echo "║  • mortal status    - View server status                     ║"
echo "║  • mortal start     - Start all services                    ║"
echo "║  • mortal logs      - View logs                              ║"
echo "║  • mortal build    - Build containers (28 parallel jobs!)   ║"
echo "║                                                               ║"
echo "║  Next Steps:                                                  ║"
echo "║  1. cd /opt/mortal-warcraft                                  ║"
echo "║  2. Edit .env with your passwords                            ║"
echo "║  3. mortal build (first time)                                ║"
echo "║  4. mortal start                                             ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"


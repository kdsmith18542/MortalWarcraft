# GPU Server Deployment Guide

## Server Specifications
- **IP**: 209.208.28.192
- **Username**: root
- **Password**: 3pW5hEdzTFGfU9qT
- **CPU**: 28 vCPU
- **RAM**: 240 GB
- **Disk**: 2400 GB
- **Free Hours**: 150 hours

## Quick Start

### Option 1: Automated Deployment (Recommended)

```bash
# From your local machine
./deploy-to-gpu-server.sh
```

This script will:
- Install Docker and dependencies on remote server
- Transfer all project files
- Setup configuration files
- Prepare for first build

### Option 2: Manual Setup

#### Step 1: Initial Server Setup

```bash
# SSH to server
ssh root@209.208.28.192

# Run setup script
cd /opt/mortal-warcraft
bash gpu-server-setup.sh
```

#### Step 2: Configure Environment

```bash
# Edit .env file
nano .env

# Update passwords and secrets
MYSQL_ROOT_PASSWORD=your_secure_password
JWT_SECRET=$(openssl rand -base64 32)
```

#### Step 3: Build and Start

```bash
# Build all services (uses 28 cores!)
mortal build

# Start all services
mortal start

# Check status
mortal status
```

## Remote Management

### From Local Machine

```bash
# View logs
./remote-monitor.sh logs worldserver

# Check status
./remote-monitor.sh status

# View container stats
./remote-monitor.sh stats

# Open shell in container
./remote-monitor.sh shell worldserver

# Build remotely
./remote-build.sh
```

### Quick Commands (on server)

```bash
# Start services
mortal start

# Stop services
mortal stop

# Restart services
mortal restart

# View logs
mortal logs worldserver
mortal logs authserver

# Check status
mortal status

# Open shell
mortal shell worldserver
```

## Performance Optimization

### Build Performance

The GPU server setup is optimized for maximum build speed:

- **28 parallel build jobs** for AzerothCore compilation
- **Docker BuildKit** enabled for faster builds
- **Resource limits** configured for optimal performance
- **SSD storage** for fast I/O

### Expected Build Times

- **AzerothCore World Server**: ~15-20 minutes (vs 1-2 hours on 4 cores)
- **AzerothCore Auth Server**: ~5-10 minutes
- **Webportal Backend**: ~2-3 minutes
- **Webportal Frontend**: ~3-5 minutes

### Resource Allocation

- **MySQL**: 4 CPU, 8GB RAM
- **Auth Server**: 2 CPU, 4GB RAM
- **World Server**: 12 CPU, 32GB RAM (build: 28 CPU)
- **Webportal Backend**: 2 CPU, 4GB RAM
- **Webportal Frontend**: 1 CPU, 2GB RAM

## Database Migration

### Export from Local Server

```bash
# On local server
mysqldump -u root -pmwdbpass --all-databases > db_backup/all_databases.sql
```

### Import to GPU Server

```bash
# On GPU server
cd /opt/mortal-warcraft
docker-compose up -d mysql

# Wait for MySQL to be ready
docker-compose exec mysql mysqladmin ping -h localhost -u root -p

# Import database
docker-compose exec -T mysql mysql -u root -pmwdbpass < db_backup/all_databases.sql
```

## Monitoring

### Server Status

```bash
# On server
mortal status

# From local machine
./remote-monitor.sh status
```

### Container Logs

```bash
# All logs
docker-compose logs -f

# Specific service
docker-compose logs -f worldserver

# Last 100 lines
docker-compose logs --tail=100 worldserver
```

### Resource Usage

```bash
# Container stats
docker stats

# System resources
htop
iotop
nethogs
```

## Troubleshooting

### Connection Issues

```bash
# Test SSH connection
ssh root@209.208.28.192

# Test Docker
docker ps

# Test Docker Compose
docker-compose version
```

### Build Issues

```bash
# Clean build
docker-compose build --no-cache

# Rebuild specific service
docker-compose build --no-cache worldserver

# Check build logs
docker-compose build worldserver 2>&1 | tee build.log
```

### Service Issues

```bash
# Check service status
docker-compose ps

# Restart service
docker-compose restart worldserver

# View service logs
docker-compose logs worldserver

# Check container health
docker-compose exec worldserver /azerothcore/bin/worldserver --version
```

### Database Issues

```bash
# Check MySQL connection
docker-compose exec mysql mysql -u root -p -e "SHOW DATABASES;"

# Check database size
docker-compose exec mysql mysql -u root -p -e "
SELECT 
    table_schema AS 'Database',
    ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'Size (MB)'
FROM information_schema.tables
GROUP BY table_schema;"

# Backup database
docker-compose exec mysql mysqldump -u root -p --all-databases > backup_$(date +%Y%m%d).sql
```

## Security Notes

⚠️ **Important**: The server password is in plain text in scripts. For production:

1. **Use SSH keys** instead of passwords:
```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "mortal-warcraft"

# Copy to server
ssh-copy-id root@209.208.28.192

# Update scripts to remove sshpass
```

2. **Change default passwords** in `.env` file

3. **Use Docker secrets** for sensitive data

4. **Enable firewall**:
```bash
ufw allow 22/tcp
ufw allow 3724/tcp
ufw allow 8085/tcp
ufw enable
```

## Cost Management

With 150 free hours:

- **Full build cycle**: ~30-45 minutes
- **Daily testing**: ~2-4 hours
- **Estimated usage**: ~30-50 hours for development/testing

**Tips**:
- Stop services when not in use: `mortal stop`
- Use `screen` or `tmux` for long-running sessions
- Monitor usage: `uptime` and `docker stats`

## Next Steps

1. ✅ Deploy to GPU server
2. ✅ Build all services
3. ✅ Import database
4. ✅ Start services
5. ✅ Test client connection
6. ✅ Monitor performance
7. ✅ Optimize as needed

## Support

For issues:
- Check logs: `mortal logs [service]`
- Check status: `mortal status`
- Review this guide's troubleshooting section
- Check Docker documentation


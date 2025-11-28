# Docker Migration Guide

This guide explains how to transfer the Mortal Warcraft project to another server using Docker.

## Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- At least 50GB free disk space
- 8GB+ RAM recommended

## Step 1: Prepare Source Server

### 1.1 Export Database

```bash
# On source server
cd /home/keith/wowpack

# Export all databases
mysqldump -u root -pmwdbpass --all-databases > db_backup/all_databases.sql

# Or export individually
mysqldump -u root -pmwdbpass azerothcore_auth > db_backup/azerothcore_auth.sql
mysqldump -u root -pmwdbpass azerothcore_characters > db_backup/azerothcore_characters.sql
mysqldump -u root -pmwdbpass azerothcore_world > db_backup/azerothcore_world.sql
```

### 1.2 Create Archive (Optional)

```bash
# Create a compressed archive excluding large files
tar --exclude='gameclientfiles' \
    --exclude='node_modules' \
    --exclude='target' \
    --exclude='build' \
    --exclude='*.log' \
    -czf mortal-warcraft-docker.tar.gz \
    azerothcore/ \
    webportal/ \
    launcher/ \
    config/ \
    sql/ \
    db_backup/ \
    docker-compose.yml \
    .dockerignore \
    *.md
```

## Step 2: Transfer to Destination Server

### 2.1 Copy Files

```bash
# Option 1: SCP
scp -r mortal-warcraft-docker.tar.gz user@new-server:/opt/mortal-warcraft/

# Option 2: rsync (better for large transfers)
rsync -avz --progress \
  --exclude='gameclientfiles' \
  --exclude='node_modules' \
  --exclude='target' \
  --exclude='build' \
  /home/keith/wowpack/ \
  user@new-server:/opt/mortal-warcraft/
```

### 2.2 Transfer Game Client Files Separately

```bash
# Game client files are large (17GB), transfer separately
rsync -avz --progress \
  /home/keith/wowpack/gameclientfiles/ \
  user@new-server:/opt/mortal-warcraft/gameclientfiles/
```

## Step 3: Setup on Destination Server

### 3.1 Extract Archive (if using tar)

```bash
cd /opt/mortal-warcraft
tar -xzf mortal-warcraft-docker.tar.gz
```

### 3.2 Create Environment File

```bash
cat > .env << EOF
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

# Docker User (optional)
DOCKER_USER_ID=1000
DOCKER_GROUP_ID=1000
DOCKER_USER=acore

# JWT Secret (change in production!)
JWT_SECRET=$(openssl rand -base64 32)
EOF
```

### 3.3 Build Docker Images

```bash
# Build all services
docker-compose build

# Or build individually
docker-compose build authserver worldserver
docker-compose build webportal-backend webportal-frontend
```

### 3.4 Import Database

```bash
# Start MySQL first
docker-compose up -d mysql

# Wait for MySQL to be ready
docker-compose exec mysql mysqladmin ping -h localhost -u root -pmwdbpass

# Import databases
docker-compose exec mysql mysql -u root -pmwdbpass < db_backup/azerothcore_auth.sql
docker-compose exec mysql mysql -u root -pmwdbpass < db_backup/azerothcore_characters.sql
docker-compose exec mysql mysql -u root -pmwdbpass < db_backup/azerothcore_world.sql

# Or import all at once
docker-compose exec -T mysql mysql -u root -pmwdbpass < db_backup/all_databases.sql
```

### 3.5 Update Configuration Files

```bash
# Update worldserver.conf database connections
sed -i 's/127.0.0.1;3306/mysql;3306/g' azerothcore/env/dist/etc/worldserver.conf

# Update authserver.conf
sed -i 's/127.0.0.1;3306/mysql;3306/g' azerothcore/env/dist/etc/authserver.conf
```

## Step 4: Start Services

### 4.1 Start All Services

```bash
docker-compose up -d
```

### 4.2 Check Status

```bash
# Check all services
docker-compose ps

# Check logs
docker-compose logs -f worldserver
docker-compose logs -f authserver
docker-compose logs -f webportal-backend
```

### 4.3 Verify Services

```bash
# Check MySQL
docker-compose exec mysql mysql -u root -pmwdbpass -e "SHOW DATABASES;"

# Check Auth Server
curl http://localhost:3724

# Check World Server
netstat -tuln | grep 8085

# Check Webportal
curl http://localhost:3000
```

## Step 5: Post-Migration Tasks

### 5.1 Update Realmlist

```bash
# Update realmlist table with new server IP
docker-compose exec mysql mysql -u root -pmwdbpass azerothcore_auth -e \
  "UPDATE realmlist SET address = 'NEW_SERVER_IP' WHERE id = 1;"
```

### 5.2 Verify Module Loading

```bash
# Check worldserver logs for module loading
docker-compose logs worldserver | grep -i "mortal\|module"
```

### 5.3 Test Client Connection

1. Update client `realmlist.wtf` to point to new server
2. Test login
3. Verify character data
4. Test game functionality

## Troubleshooting

### Database Connection Issues

```bash
# Check MySQL logs
docker-compose logs mysql

# Test connection from container
docker-compose exec worldserver ping mysql
docker-compose exec worldserver nc -zv mysql 3306
```

### Port Conflicts

```bash
# Check what's using ports
netstat -tuln | grep -E "3724|8085|3306|8080|3000"

# Change ports in .env file
```

### Permission Issues

```bash
# Fix file permissions
sudo chown -R 1000:1000 azerothcore/env/dist/logs
sudo chown -R 1000:1000 azerothcore/env/dist/data
```

### Module Not Loading

```bash
# Check if module is compiled
docker-compose exec worldserver ls -la /azerothcore/bin/libmortal_overhaul.a

# Rebuild worldserver
docker-compose build --no-cache worldserver
docker-compose up -d worldserver
```

## Maintenance

### Backup Database

```bash
# Create backup
docker-compose exec mysql mysqldump -u root -pmwdbpass --all-databases > backup_$(date +%Y%m%d).sql
```

### Update Services

```bash
# Pull latest images
docker-compose pull

# Rebuild and restart
docker-compose up -d --build
```

### View Logs

```bash
# All logs
docker-compose logs -f

# Specific service
docker-compose logs -f worldserver

# Last 100 lines
docker-compose logs --tail=100 worldserver
```

## Production Considerations

1. **Change Default Passwords**: Update `MYSQL_ROOT_PASSWORD` and `JWT_SECRET` in `.env`
2. **Use Secrets**: Consider using Docker secrets for sensitive data
3. **Reverse Proxy**: Set up nginx/traefik for SSL termination
4. **Monitoring**: Add monitoring (Prometheus, Grafana)
5. **Backups**: Set up automated database backups
6. **Resource Limits**: Add resource limits in docker-compose.yml
7. **Network Security**: Use Docker networks and firewall rules

## File Structure

```
/opt/mortal-warcraft/
├── docker-compose.yml
├── .env
├── .dockerignore
├── azerothcore/
│   ├── env/dist/etc/     # Config files
│   ├── env/dist/logs/    # Log files
│   ├── env/dist/data/     # Game data
│   └── bin/               # Binaries
├── webportal/
│   ├── backend/
│   └── frontend/
├── config/                # Custom configs
├── sql/                   # SQL migrations
└── db_backup/             # Database backups
```

## Quick Start Commands

```bash
# Start everything
docker-compose up -d

# Stop everything
docker-compose down

# Restart a service
docker-compose restart worldserver

# View logs
docker-compose logs -f worldserver

# Execute command in container
docker-compose exec worldserver /azerothcore/bin/worldserver

# Update and restart
docker-compose pull && docker-compose up -d --build
```


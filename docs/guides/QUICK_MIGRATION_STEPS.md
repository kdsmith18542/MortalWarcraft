# Quick Migration Steps: MariaDB → MySQL

## Current Status
- **Current:** MariaDB 10.11.13
- **Required:** MySQL 8.0+ (8.4 recommended)
- **MySQL Client:** Already installed (8.0.43)
- **MySQL Server:** Needs installation

## Quick Start (5 Steps)

### 1. Install MySQL Server

```bash
# Update package list (mysql-apt-config is already installed)
sudo apt-get update

# Install MySQL Server 8.0
sudo apt-get install -y mysql-server

# During installation, set root password to: mwdbpass
# (or use the same password you're currently using)
```

### 2. Start MySQL Service

```bash
sudo systemctl start mysql
sudo systemctl enable mysql
```

### 3. Configure MySQL Root Password (if needed)

```bash
# If authentication fails, reset password:
sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'mwdbpass';
FLUSH PRIVILEGES;
EXIT;
```

### 4. Run Migration Script

```bash
cd /home/keith/wowpack
./migrate_to_mysql.sh
```

This will:
- Export all databases from MariaDB
- Import them into MySQL
- Create backups automatically

### 5. Test Connection

```bash
# Verify MySQL version
mysql -u root -pmwdbpass -e "SELECT VERSION();"

# Should show: 8.0.x or 8.4.x (NOT MariaDB)

# Check databases
mysql -u root -pmwdbpass -e "SHOW DATABASES LIKE 'azerothcore%';"
```

## If Both Servers Run Simultaneously

If MariaDB is still running on port 3306, you have two options:

### Option A: Stop MariaDB (Recommended)

```bash
sudo systemctl stop mariadb
sudo systemctl disable mariadb
```

### Option B: Change MySQL Port

```bash
# Edit MySQL config
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf

# Change port to 3307
port = 3307

# Restart MySQL
sudo systemctl restart mysql

# Update dbimport.conf
nano /home/keith/wowpack/azerothcore/etc/dbimport.conf

# Change port from 3306 to 3307 in all three database lines
```

## Verify AzerothCore Works

```bash
cd /home/keith/wowpack/azerothcore
./bin/worldserver
```

Look for in the logs:
- ✅ `MySQL client library: 8.0.x` (not MariaDB)
- ✅ No "does not support MySQL versions below 8.0" errors
- ✅ Successful database connections

## Troubleshooting

**Problem:** "Access denied for user 'root'@'localhost'"
```bash
sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'mwdbpass';
FLUSH PRIVILEGES;
EXIT;
```

**Problem:** Port 3306 already in use
```bash
# Check what's using it
sudo lsof -i :3306

# Stop MariaDB
sudo systemctl stop mariadb
```

**Problem:** Migration script fails
- Check MariaDB is accessible: `mysql -u root -pmwdbpass -e "SELECT 1;"`
- Check MySQL is running: `sudo systemctl status mysql`
- Check backups were created: `ls -lh /home/keith/wowpack/db_backup_*/`

## Files Created

- **Migration Script:** `/home/keith/wowpack/migrate_to_mysql.sh`
- **Full Guide:** `/home/keith/wowpack/MYSQL_MIGRATION_GUIDE.md`
- **Backups:** `/home/keith/wowpack/db_backup_YYYYMMDD_HHMMSS/`

## Need Help?

Check the full guide: `MYSQL_MIGRATION_GUIDE.md`


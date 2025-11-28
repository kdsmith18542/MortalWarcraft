# MariaDB to MySQL Migration Guide

## Overview

AzerothCore requires **MySQL 8.0 or higher** (8.4 recommended). You're currently using **MariaDB 10.11.13**, which is compatible but not officially supported.

This guide will help you migrate from MariaDB to MySQL 8.0+.

## Prerequisites

- Current database credentials: `root/mwdbpass`
- Databases: `azerothcore_auth`, `azerothcore_world`, `azerothcore_characters`
- Backup of all data (automatic via migration script)

## Option 1: Install MySQL 8.0+ Alongside MariaDB (Recommended)

This allows you to keep MariaDB running while testing MySQL.

### Step 1: Install MySQL 8.0+

```bash
# Download MySQL APT repository configuration
wget https://dev.mysql.com/get/mysql-apt-config_0.8.35-1_all.deb -P /tmp

# Install the repository package
sudo dpkg -i /tmp/mysql-apt-config_0.8.35-1_all.deb

# Update package list
sudo apt-get update

# Install MySQL Server 8.0 (or 8.4 if available)
sudo apt-get install -y mysql-server mysql-client

# During installation, you'll be prompted to set a root password
# Use the same password: mwdbpass (or different if you prefer)
```

### Step 2: Configure MySQL Port (Optional)

If you want to run both MariaDB and MySQL simultaneously:

```bash
# Edit MySQL configuration
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf

# Change the port (e.g., to 3307)
port = 3307

# Restart MySQL
sudo systemctl restart mysql
```

**Note:** If you change the port, update `dbimport.conf` accordingly.

### Step 3: Run Migration Script

```bash
cd /home/keith/wowpack
./migrate_to_mysql.sh
```

The script will:
1. Check MySQL version (must be 8.0+)
2. Export all databases from MariaDB
3. Create databases in MySQL
4. Import all data into MySQL
5. Create backups in `/home/keith/wowpack/db_backup_YYYYMMDD_HHMMSS/`

### Step 4: Verify Migration

```bash
# Check databases exist
mysql -u root -pmwdbpass -e "SHOW DATABASES LIKE 'azerothcore%';"

# Check table counts
mysql -u root -pmwdbpass azerothcore_auth -e "SHOW TABLES;" | wc -l
mysql -u root -pmwdbpass azerothcore_world -e "SHOW TABLES;" | wc -l
mysql -u root -pmwdbpass azerothcore_characters -e "SHOW TABLES;" | wc -l

# Test a query
mysql -u root -pmwdbpass azerothcore_auth -e "SELECT COUNT(*) FROM realmlist;"
```

### Step 5: Update AzerothCore Configuration

If you changed the MySQL port, update `/home/keith/wowpack/azerothcore/etc/dbimport.conf`:

```ini
LoginDatabaseInfo     = "127.0.0.1;3307;root;mwdbpass;azerothcore_auth"
WorldDatabaseInfo     = "127.0.0.1;3307;root;mwdbpass;azerothcore_world"
CharacterDatabaseInfo = "127.0.0.1;3307;root;mwdbpass;azerothcore_characters"
```

### Step 6: Test AzerothCore

```bash
cd /home/keith/wowpack/azerothcore
./bin/worldserver
```

Check the logs for:
- `MySQL client library: 8.0.x` (should show MySQL, not MariaDB)
- No errors about MySQL version compatibility

## Option 2: Replace MariaDB with MySQL (Clean Install)

**Warning:** This will remove MariaDB. Only do this if you're sure you want to switch completely.

### Step 1: Backup Everything

```bash
# Run the migration script first to create backups
cd /home/keith/wowpack
./migrate_to_mysql.sh
```

### Step 2: Stop MariaDB

```bash
sudo systemctl stop mariadb
sudo systemctl disable mariadb
```

### Step 3: Install MySQL 8.0+

```bash
wget https://dev.mysql.com/get/mysql-apt-config_0.8.35-1_all.deb -P /tmp
sudo dpkg -i /tmp/mysql-apt-config_0.8.35-1_all.deb
sudo apt-get update
sudo apt-get install -y mysql-server mysql-client
```

### Step 4: Import Databases

```bash
# The migration script already created backups, now import them
BACKUP_DIR=$(ls -td /home/keith/wowpack/db_backup_* | head -1)

mysql -u root -pmwdbpass < "$BACKUP_DIR/azerothcore_auth.sql"
mysql -u root -pmwdbpass < "$BACKUP_DIR/azerothcore_world.sql"
mysql -u root -pmwdbpass < "$BACKUP_DIR/azerothcore_characters.sql"
```

### Step 5: (Optional) Remove MariaDB

```bash
sudo apt-get remove --purge mariadb-server mariadb-client
sudo apt-get autoremove
```

## Troubleshooting

### Error: "Access denied for user 'root'@'localhost'"

MySQL 8.0+ uses `auth_socket` by default. Fix it:

```bash
sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'mwdbpass';
FLUSH PRIVILEGES;
EXIT;
```

### Error: "MySQL version mismatch"

Make sure you're using the MySQL client, not MariaDB:

```bash
# Check which binary is being used
which mysql
/usr/bin/mysql --version

# Should show: mysql  Ver 8.0.x or 8.4.x
```

### Error: "Port already in use"

If port 3306 is in use by MariaDB:

1. Change MySQL port to 3307 (see Option 1, Step 2)
2. Or stop MariaDB: `sudo systemctl stop mariadb`

### Error: "Character set issues"

MySQL 8.0+ uses `utf8mb4` by default. If you see charset errors:

```bash
mysql -u root -pmwdbpass <<EOF
ALTER DATABASE azerothcore_auth CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER DATABASE azerothcore_world CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER DATABASE azerothcore_characters CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
EOF
```

## Verification Checklist

- [ ] MySQL 8.0+ installed and running
- [ ] All three databases exist in MySQL
- [ ] Table counts match between MariaDB and MySQL
- [ ] AzerothCore connects successfully
- [ ] No version compatibility errors in logs
- [ ] Backups created in `db_backup_*` directory

## Rollback Plan

If something goes wrong, you can restore from MariaDB:

```bash
# MariaDB should still be running on the same port
# Just update dbimport.conf to point back to MariaDB
# Or restart MariaDB if you stopped it
sudo systemctl start mariadb
```

## Next Steps After Migration

1. **Test thoroughly:** Log in, create characters, test all systems
2. **Monitor logs:** Watch for any MySQL-specific errors
3. **Performance:** MySQL 8.0+ should perform similarly or better than MariaDB
4. **Keep backups:** Don't delete the `db_backup_*` directories for at least a week

## Support

If you encounter issues:
- Check AzerothCore logs: `azerothcore/Server.log`
- Check MySQL error log: `sudo tail -f /var/log/mysql/error.log`
- Verify database connectivity: `mysql -u root -pmwdbpass -e "SELECT VERSION();"`


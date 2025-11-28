# Resolving MariaDB/MySQL Conflict

## Problem

When trying to install MySQL, you get:
```
mariadb-client-core : Conflicts: virtual-mysql-client-core
mariadb-server-core : Conflicts: virtual-mysql-server-core
```

This happens because MariaDB and MySQL cannot coexist on the same system (they provide the same virtual packages).

## Solution: Remove MariaDB First

Since you're migrating from MariaDB to MySQL, we need to:

1. **Backup all databases** (safest approach)
2. **Remove MariaDB**
3. **Install MySQL**
4. **Restore databases**

## Option 1: Automated Script (Recommended)

I've created a script that does everything safely:

```bash
cd /home/keith/wowpack
./migrate_remove_mariadb.sh
```

This script will:
- ✅ Backup all databases from MariaDB
- ✅ Stop MariaDB service
- ✅ Remove MariaDB packages
- ✅ Install MySQL Server 8.0
- ✅ Restore all databases to MySQL
- ✅ Verify the migration

## Option 2: Manual Steps

If you prefer to do it manually:

### Step 1: Backup Databases

```bash
# Create backup directory
BACKUP_DIR="/home/keith/wowpack/db_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Export databases
mysqldump -u root -pmwdbpass --single-transaction --routines --triggers --events \
    azerothcore_auth > "$BACKUP_DIR/azerothcore_auth.sql"

mysqldump -u root -pmwdbpass --single-transaction --routines --triggers --events \
    azerothcore_world > "$BACKUP_DIR/azerothcore_world.sql"

mysqldump -u root -pmwdbpass --single-transaction --routines --triggers --events \
    azerothcore_characters > "$BACKUP_DIR/azerothcore_characters.sql"
```

### Step 2: Stop MariaDB

```bash
sudo systemctl stop mariadb
```

### Step 3: Remove MariaDB

```bash
sudo apt-get remove --purge -y \
    mariadb-server \
    mariadb-client \
    mariadb-server-core \
    mariadb-client-core \
    mariadb-common

sudo apt-get autoremove -y
```

### Step 4: Install MySQL

```bash
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server
```

### Step 5: Configure MySQL Root Password

```bash
sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'mwdbpass';
FLUSH PRIVILEGES;
EXIT;
```

### Step 6: Start MySQL and Restore

```bash
sudo systemctl start mysql
sudo systemctl enable mysql

# Create databases
mysql -u root -pmwdbpass <<EOF
CREATE DATABASE IF NOT EXISTS azerothcore_auth CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS azerothcore_world CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS azerothcore_characters CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
EOF

# Import databases
mysql -u root -pmwdbpass azerothcore_auth < "$BACKUP_DIR/azerothcore_auth.sql"
mysql -u root -pmwdbpass azerothcore_world < "$BACKUP_DIR/azerothcore_world.sql"
mysql -u root -pmwdbpass azerothcore_characters < "$BACKUP_DIR/azerothcore_characters.sql"
```

## Verification

After migration, verify everything works:

```bash
# Check MySQL version (should show 8.0.x, NOT MariaDB)
mysql -u root -pmwdbpass -e "SELECT VERSION();"

# Check databases exist
mysql -u root -pmwdbpass -e "SHOW DATABASES LIKE 'azerothcore%';"

# Check table counts
mysql -u root -pmwdbpass azerothcore_auth -e "SHOW TABLES;" | wc -l
mysql -u root -pmwdbpass azerothcore_world -e "SHOW TABLES;" | wc -l
mysql -u root -pmwdbpass azerothcore_characters -e "SHOW TABLES;" | wc -l
```

## Test AzerothCore

```bash
cd /home/keith/wowpack/azerothcore
./bin/worldserver
```

Look for in logs:
- ✅ `MySQL client library: 8.0.x` (not MariaDB)
- ✅ No "does not support MySQL versions below 8.0" errors
- ✅ Successful database connections

## Rollback (If Needed)

If something goes wrong, you can reinstall MariaDB and restore:

```bash
# Reinstall MariaDB
sudo apt-get install -y mariadb-server mariadb-client

# Start MariaDB
sudo systemctl start mariadb

# Restore databases (from backup directory)
mysql -u root -pmwdbpass azerothcore_auth < "$BACKUP_DIR/azerothcore_auth.sql"
mysql -u root -pmwdbpass azerothcore_world < "$BACKUP_DIR/azerothcore_world.sql"
mysql -u root -pmwdbpass azerothcore_characters < "$BACKUP_DIR/azerothcore_characters.sql"
```

## Important Notes

1. **Backups are critical** - The script creates automatic backups, but verify they exist before proceeding
2. **Service downtime** - There will be a brief period where no database is running (during removal/installation)
3. **Password** - Make sure to use the same password (`mwdbpass`) or update `dbimport.conf` accordingly
4. **Port** - MySQL will use the same port (3306) as MariaDB did

## Next Steps

After successful migration:
1. Test AzerothCore connection
2. Verify all custom tables exist (mortal_skills, regional_bank, etc.)
3. Test in-game functionality
4. Keep backups for at least a week


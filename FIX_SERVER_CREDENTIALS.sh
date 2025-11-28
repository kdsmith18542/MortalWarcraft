#!/bin/bash
# Fix AzerothCore server database credentials
# Run this script with: sudo bash FIX_SERVER_CREDENTIALS.sh

echo "Fixing database credentials in server config files..."

# Fix authserver.conf
sed -i 's/LoginDatabaseInfo.*=.*/LoginDatabaseInfo = "127.0.0.1;3306;root;mwdbpass;azerothcore_auth"/' /usr/local/etc/authserver.conf
echo "✅ Fixed /usr/local/etc/authserver.conf"

# Fix worldserver.conf
sed -i 's/LoginDatabaseInfo.*=.*/LoginDatabaseInfo = "127.0.0.1;3306;root;mwdbpass;azerothcore_auth"/' /usr/local/etc/worldserver.conf
sed -i 's/WorldDatabaseInfo.*=.*/WorldDatabaseInfo = "127.0.0.1;3306;root;mwdbpass;azerothcore_world"/' /usr/local/etc/worldserver.conf
sed -i 's/CharacterDatabaseInfo.*=.*/CharacterDatabaseInfo = "127.0.0.1;3306;root;mwdbpass;azerothcore_characters"/' /usr/local/etc/worldserver.conf
echo "✅ Fixed /usr/local/etc/worldserver.conf"

echo ""
echo "Verifying credentials..."
grep -E "LoginDatabaseInfo|WorldDatabaseInfo|CharacterDatabaseInfo" /usr/local/etc/worldserver.conf | grep -v "^#"

echo ""
echo "✅ Database credentials updated!"
echo "You can now start the servers."


#!/bin/bash
# Script to export project for Docker migration

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${SCRIPT_DIR}/docker-export"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║        🐳 Docker Export Script 🐳                            ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
echo ""

# Create output directory
mkdir -p "${OUTPUT_DIR}"

echo "📦 Step 1: Exporting databases..."
mysqldump -u root -pmwdbpass --all-databases > "${OUTPUT_DIR}/all_databases_${TIMESTAMP}.sql"
echo "✅ Database export complete"

echo ""
echo "📁 Step 2: Copying project files..."
rsync -av --progress \
  --exclude='.git' \
  --exclude='node_modules' \
  --exclude='target' \
  --exclude='build' \
  --exclude='*.log' \
  --exclude='gameclientfiles' \
  --exclude='db_backup' \
  --exclude='archive_*' \
  --exclude='.dockerignore' \
  "${SCRIPT_DIR}/" "${OUTPUT_DIR}/project/"

echo "✅ Files copied"

echo ""
echo "📝 Step 3: Creating .env.example..."
cat > "${OUTPUT_DIR}/.env.example" << 'EOF'
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

# JWT Secret (generate with: openssl rand -base64 32)
JWT_SECRET=change-me-in-production
EOF

echo "✅ .env.example created"

echo ""
echo "📋 Step 4: Creating README..."
cat > "${OUTPUT_DIR}/README.md" << 'EOF'
# Mortal Warcraft Docker Export

## Quick Start

1. Copy this directory to your destination server
2. Copy gameclientfiles separately (17GB)
3. Create `.env` from `.env.example` and update passwords
4. Run: `docker-compose up -d`
5. Import database: `docker-compose exec -T mysql mysql -u root -p < all_databases_*.sql`

See DOCKER_MIGRATION_GUIDE.md for detailed instructions.
EOF

echo "✅ README created"

echo ""
echo "📊 Step 5: Creating archive..."
cd "${OUTPUT_DIR}"
tar -czf "../mortal-warcraft-docker-${TIMESTAMP}.tar.gz" .

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║        ✅ Export Complete! ✅                                 ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
echo "║                                                               ║"
echo "║  Export location: ${OUTPUT_DIR}                               ║"
echo "║  Archive: ${SCRIPT_DIR}/mortal-warcraft-docker-${TIMESTAMP}.tar.gz ║"
echo "║                                                               ║"
echo "║  Next steps:                                                  ║"
echo "║  1. Transfer archive to destination server                   ║"
echo "║  2. Transfer gameclientfiles/ separately (17GB)             ║"
echo "║  3. Follow DOCKER_MIGRATION_GUIDE.md                         ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"


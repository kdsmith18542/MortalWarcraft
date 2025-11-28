#!/bin/bash
# Remote monitoring script - view logs and status from local machine
# Usage: ./remote-monitor.sh [logs|status|stats]

set -e

SERVER_IP="209.208.28.192"
SERVER_USER="root"
SERVER_PASS="3pW5hEdzTFGfU9qT"
REMOTE_DIR="/opt/mortal-warcraft"
COMMAND="${1:-status}"

# Check if sshpass is installed
if ! command -v sshpass &> /dev/null; then
    echo "📦 Installing sshpass..."
    sudo apt-get update && sudo apt-get install -y sshpass
fi

case "$COMMAND" in
    logs)
        SERVICE="${2:-worldserver}"
        echo "📋 Streaming logs for ${SERVICE}..."
        sshpass -p "${SERVER_PASS}" ssh -o StrictHostKeyChecking=no "${SERVER_USER}@${SERVER_IP}" \
            "cd ${REMOTE_DIR} && docker-compose logs -f ${SERVICE}"
        ;;
    status)
        sshpass -p "${SERVER_PASS}" ssh -o StrictHostKeyChecking=no "${SERVER_USER}@${SERVER_IP}" \
            "cd ${REMOTE_DIR} && mortal-status"
        ;;
    stats)
        echo "📊 Container statistics (refreshing every 2 seconds)..."
        sshpass -p "${SERVER_PASS}" ssh -o StrictHostKeyChecking=no "${SERVER_USER}@${SERVER_IP}" \
            "watch -n 2 'docker stats --no-stream --format \"table {{.Name}}\\t{{.CPUPerc}}\\t{{.MemUsage}}\\t{{.NetIO}}\"'"
        ;;
    ps)
        sshpass -p "${SERVER_PASS}" ssh -o StrictHostKeyChecking=no "${SERVER_USER}@${SERVER_IP}" \
            "cd ${REMOTE_DIR} && docker-compose ps"
        ;;
    shell)
        SERVICE="${2:-worldserver}"
        echo "🐚 Opening shell in ${SERVICE} container..."
        sshpass -p "${SERVER_PASS}" ssh -o StrictHostKeyChecking=no -t "${SERVER_USER}@${SERVER_IP}" \
            "cd ${REMOTE_DIR} && docker-compose exec ${SERVICE} /bin/bash"
        ;;
    *)
        echo "Usage: ./remote-monitor.sh {logs|status|stats|ps|shell} [service]"
        echo ""
        echo "Commands:"
        echo "  logs [service]  - Stream logs (default: worldserver)"
        echo "  status         - Show server status"
        echo "  stats          - Show container statistics"
        echo "  ps             - Show container status"
        echo "  shell [service] - Open shell in container"
        echo ""
        echo "Examples:"
        echo "  ./remote-monitor.sh logs worldserver"
        echo "  ./remote-monitor.sh status"
        echo "  ./remote-monitor.sh shell worldserver"
        exit 1
        ;;
esac


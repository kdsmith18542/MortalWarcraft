#!/bin/bash
# Create admin account by sending commands to worldserver console
# This script attempts to connect to the worldserver console

WORLDSERVER_PID=$(pgrep -f "./worldserver" | head -1)

if [ -z "$WORLDSERVER_PID" ]; then
    echo "❌ Worldserver not running!"
    exit 1
fi

echo "✅ Found worldserver PID: $WORLDSERVER_PID"
echo ""
echo "📝 To create the admin account, please run these commands in the worldserver console:"
echo ""
echo "   .account create admin admin"
echo "   .account set gmlevel admin 3 -1"
echo ""
echo "💡 You can connect to the worldserver console by:"
echo "   1. Opening a new terminal"
echo "   2. Running: screen -r (if using screen)"
echo "   3. Or attaching to the process directly"
echo ""
echo "🔧 Alternatively, I can create a SQL script if you prefer..."

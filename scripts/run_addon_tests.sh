#!/bin/bash

# ==================================================
# MortalUI Addon Integration Test Runner
# Description: Automated test execution script for MortalUI addon testing
# Usage: ./run_addon_tests.sh [player_name]
# ==================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LUA_SCRIPT="$PROJECT_ROOT/azerothcore/bin/lua_scripts/mortal_addon_integration_test.lua"

# Configuration
WORLD_SERVER_PID=""
TEST_PLAYER="${1:-}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${timestamp} [${level}] ${message}"
}

# Check if worldserver is running
check_worldserver() {
    WORLD_SERVER_PID=$(pgrep -f "worldserver")
    if [ -z "$WORLD_SERVER_PID" ]; then
        log "ERROR" "Worldserver is not running. Please start the server first."
        exit 1
    fi
    log "INFO" "Found worldserver process: $WORLD_SERVER_PID"
}

# Execute Lua test command
run_lua_test() {
    local test_command="$1"
    local description="$2"

    log "INFO" "Executing: $description"

    # Use screen or tmux to send command to worldserver console
    # This assumes worldserver is running in a screen session named "worldserver"
    if screen -list | grep -q "worldserver"; then
        screen -S worldserver -X stuff ".lua $test_command\n"
        log "SUCCESS" "Sent command to worldserver console"
    else
        log "ERROR" "Worldserver screen session not found. Please ensure worldserver is running in a screen session named 'worldserver'"
        log "INFO" "Manual command: .lua $test_command"
        exit 1
    fi
}

# Wait for test completion
wait_for_completion() {
    local timeout="${1:-30}"
    local count=0

    log "INFO" "Waiting for test completion (timeout: ${timeout}s)"
    while [ $count -lt $timeout ]; do
        sleep 1
        count=$((count + 1))

        # Check if worldserver is still running
        if ! kill -0 "$WORLD_SERVER_PID" 2>/dev/null; then
            log "ERROR" "Worldserver process died during testing"
            exit 1
        fi
    done

    log "INFO" "Test execution period completed"
}

# Main test execution
main() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  MortalUI Addon Integration Tests${NC}"
    echo -e "${BLUE}========================================${NC}"

    # Check prerequisites
    check_worldserver

    # Load the test script
    log "INFO" "Loading test script..."
    run_lua_test "dofile(\"$LUA_SCRIPT\")" "Load test script"

    # Wait for script to load
    sleep 2

    # Run tests
    if [ -n "$TEST_PLAYER" ]; then
        log "INFO" "Running tests on specific player: $TEST_PLAYER"

        run_lua_test "TestWeightAndHunger(\"$TEST_PLAYER\")" "Test weight and hunger updates"
        wait_for_completion 5

        run_lua_test "TestBountyUpdate(\"$TEST_PLAYER\")" "Test bounty updates"
        wait_for_completion 5

        run_lua_test "TestStrongholdUpdate(\"$TEST_PLAYER\")" "Test stronghold updates"
        wait_for_completion 5

        run_lua_test "TestRiftUpdate(\"$TEST_PLAYER\")" "Test rift updates"
        wait_for_completion 5

    else
        log "INFO" "Running comprehensive tests on all online players"
        run_lua_test "TestAllAddons()" "Run all addon tests"
        wait_for_completion 60  # Longer timeout for full test suite
    fi

    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  Test execution completed${NC}"
    echo -e "${GREEN}========================================${NC}"
    log "SUCCESS" "Addon integration tests completed"
}

# Show usage
usage() {
    echo "Usage: $0 [player_name]"
    echo ""
    echo "Arguments:"
    echo "  player_name    Optional. Run tests on specific player only."
    echo "                 If omitted, runs tests on all online players."
    echo ""
    echo "Examples:"
    echo "  $0              # Test all online players"
    echo "  $0 MyCharacter # Test specific player"
    echo ""
    echo "Prerequisites:"
    echo "  - Worldserver must be running"
    echo "  - Worldserver must be in a screen session named 'worldserver'"
    echo "  - Test script must be in lua_scripts/ directory"
}

# Parse arguments
case "$1" in
    -h|--help)
        usage
        exit 0
        ;;
    *)
        main "$@"
        ;;
esac
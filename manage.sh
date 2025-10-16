#!/bin/bash

# LibreChat Quick Start Script
# This script provides common operations for managing LibreChat

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

function print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

function print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

function print_error() {
    echo -e "${RED}✗ $1${NC}"
}

function print_menu() {
    echo ""
    echo "═══════════════════════════════════════════════════════"
    echo "           LibreChat Management Script"
    echo "═══════════════════════════════════════════════════════"
    echo "1) Start LibreChat"
    echo "2) Stop LibreChat"
    echo "3) Restart LibreChat"
    echo "4) View Logs (all services)"
    echo "5) View Logs (LibreChat only)"
    echo "6) View Logs (follow mode)"
    echo "7) Check Status"
    echo "8) Create User"
    echo "9) List Users"
    echo "10) Reset Password"
    echo "11) Update LibreChat"
    echo "12) Pull Latest Images"
    echo "13) Rebuild (reset all data)"
    echo "14) Open in Browser"
    echo "15) Generate Security Keys"
    echo "0) Exit"
    echo "═══════════════════════════════════════════════════════"
    echo -n "Enter your choice: "
}

function start_services() {
    print_warning "Starting LibreChat services..."
    docker compose up -d
    sleep 3
    print_success "LibreChat started!"
    echo "Access at: http://localhost:3080"
}

function stop_services() {
    print_warning "Stopping LibreChat services..."
    docker compose down
    print_success "LibreChat stopped!"
}

function restart_services() {
    print_warning "Restarting LibreChat services..."
    docker compose restart
    sleep 3
    print_success "LibreChat restarted!"
}

function view_logs_all() {
    docker compose logs --tail=100
}

function view_logs_librechat() {
    docker logs LibreChat --tail=100
}

function view_logs_follow() {
    print_warning "Following logs (Ctrl+C to exit)..."
    docker logs LibreChat -f
}

function check_status() {
    echo ""
    docker compose ps
    echo ""
    if curl -s http://localhost:3080 > /dev/null 2>&1; then
        print_success "LibreChat is accessible at http://localhost:3080"
    else
        print_error "LibreChat is not responding on port 3080"
    fi
}

function create_user() {
    npm run create-user
}

function list_users() {
    npm run list-users
}

function reset_password() {
    npm run reset-password
}

function update_librechat() {
    print_warning "Updating LibreChat..."
    npm run update
    print_success "Update complete!"
}

function pull_images() {
    print_warning "Pulling latest Docker images..."
    docker compose pull
    print_success "Images updated!"
}

function rebuild_all() {
    print_error "WARNING: This will DELETE ALL DATA!"
    echo -n "Are you sure you want to continue? (yes/no): "
    read confirm
    if [ "$confirm" = "yes" ]; then
        print_warning "Stopping services and removing volumes..."
        docker compose down -v
        print_warning "Removing data directories..."
        rm -rf data-node meili_data_v1.12
        print_warning "Starting fresh installation..."
        docker compose up -d
        print_success "Rebuild complete!"
    else
        print_warning "Rebuild cancelled"
    fi
}

function open_browser() {
    print_success "Opening LibreChat in browser..."
    if command -v open &> /dev/null; then
        open http://localhost:3080
    elif command -v xdg-open &> /dev/null; then
        xdg-open http://localhost:3080
    else
        echo "Please open http://localhost:3080 in your browser"
    fi
}

function generate_keys() {
    echo ""
    print_warning "Visit this URL to generate secure keys:"
    echo "https://www.librechat.ai/toolkit/creds_generator"
    echo ""
    print_warning "Then update your .env file with the generated values:"
    echo "  - CREDS_KEY"
    echo "  - CREDS_IV"
    echo "  - JWT_SECRET"
    echo "  - JWT_REFRESH_SECRET"
    echo "  - MEILI_MASTER_KEY"
    echo ""
    echo -n "Press Enter to continue..."
    read
}

# Main loop
while true; do
    print_menu
    read choice

    case $choice in
        1) start_services ;;
        2) stop_services ;;
        3) restart_services ;;
        4) view_logs_all ;;
        5) view_logs_librechat ;;
        6) view_logs_follow ;;
        7) check_status ;;
        8) create_user ;;
        9) list_users ;;
        10) reset_password ;;
        11) update_librechat ;;
        12) pull_images ;;
        13) rebuild_all ;;
        14) open_browser ;;
        15) generate_keys ;;
        0) 
            echo ""
            print_success "Goodbye!"
            exit 0
            ;;
        *)
            print_error "Invalid option. Please try again."
            ;;
    esac

    echo ""
    echo -n "Press Enter to continue..."
    read
done

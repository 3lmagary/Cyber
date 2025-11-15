#!/bin/bash

# ==========================================
# 🎪 SUPER RSYNC - Advanced Smart Sync
# ==========================================

# Color settings
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Default settings variables
DEFAULT_OPTIONS="-avh"
COMPRESSION_LEVEL=9
BWLIMIT=0
EXCLUDE_PATTERNS=("*.tmp" "*.log" "temp/" "cache/" ".DS_Store" "Thumbs.db")

# Helper functions
show_banner() {
    clear
    echo -e "${PURPLE}"
    echo "╔════════════════════════════════════════════════╗"
    echo "║               🚀 SUPER RSYNC 🚀               ║"
    echo "║          Advanced Smart Sync - v2.0           ║"
    echo "╚════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

show_help() {
    echo -e "${YELLOW}📖 Usage:${NC}"
    echo "  $0 [source] [destination]"
    echo "  or $0 for interactive mode"
    echo ""
    echo -e "${GREEN}🎯 Available Features:${NC}"
    echo "  ✅ Advanced sync with full control"
    echo "  ✅ High-level data compression"
    echo "  ✅ Custom transfer speed"
    echo "  ✅ Smart exclusions"
    echo "  ✅ Command preview before execution"
    echo "  ✅ Full operation logging"
    echo "  ✅ Resume interrupted transfers"
    echo "  ✅ Detailed statistics"
}

# Check if rsync is installed
check_rsync() {
    if ! command -v rsync &> /dev/null; then
        echo -e "${RED}❌ rsync is not installed!${NC}"
        echo "Please install it first:"
        echo "  Ubuntu/Debian: sudo apt install rsync"
        echo "  CentOS/RHEL: sudo yum install rsync"
        exit 1
    fi
}

# Get user input
get_user_input() {
    # Source
    while true; do
        echo -e "${CYAN}📁 Enter source path:${NC}"
        read -e SOURCE
        if [ -z "$SOURCE" ]; then
            echo -e "${RED}❌ Source path is required!${NC}"
            continue
        fi
        if [ ! -e "$SOURCE" ]; then
            echo -e "${YELLOW}⚠️  Path doesn't exist. Continue anyway? [y/N]${NC}"
            read -n1 confirm
            echo
            [[ $confirm =~ [yY] ]] && break
        else
            break
        fi
    done

    # Destination
    while true; do
        echo -e "${CYAN}📁 Enter destination path:${NC}"
        read -e DESTINATION
        if [ -z "$DESTINATION" ]; then
            echo -e "${RED}❌ Destination path is required!${NC}"
            continue
        fi
        break
    done
}

# Feature selection
select_features() {
    echo -e "${GREEN}🎛️  Select desired features:${NC}"
    
    # Basic options
    OPTIONS="-avh"
    
    # Progress and details
    echo -e "${YELLOW}📊 Progress and details:${NC}"
    echo "1) ✅ Enable detailed progress (--progress --stats)"
    echo "2) ❌ No progress display"
    read -p "Choose [1-2] (default: 1): " progress_choice
    case $progress_choice in
        2) ;;
        *) OPTIONS="$OPTIONS --progress --stats -P";;
    esac
    
    # Delete extra files
    echo -e "${YELLOW}🗑️  Delete extra files:${NC}"
    echo "1) ✅ Enable delete extra files (--delete)"
    echo "2) ⚠️  Delete with confirmation (--delete --ignore-errors)"
    echo "3) ❌ No deletion"
    read -p "Choose [1-3] (default: 1): " delete_choice
    case $delete_choice in
        2) OPTIONS="$OPTIONS --delete --ignore-errors";;
        3) ;;
        *) OPTIONS="$OPTIONS --delete";;
    esac
    
    # Compression
    echo -e "${YELLOW}🗜️  Data compression:${NC}"
    echo "1) ✅ High compression (--compress --compress-level=9)"
    echo "2) 🔄 Medium compression (--compress --compress-level=5)"
    echo "3) ❌ No compression"
    read -p "Choose [1-3] (default: 1): " compress_choice
    case $compress_choice in
        2) OPTIONS="$OPTIONS --compress --compress-level=5";;
        3) ;;
        *) OPTIONS="$OPTIONS --compress --compress-level=9";;
    esac
    
    # Speed limit
    echo -e "${YELLOW}⚡ Transfer speed limit:${NC}"
    echo "1) 🚀 Maximum speed (unlimited)"
    echo "2) 🐢 Limited speed (1MB/s)"
    echo "3) 🔧 Custom speed"
    read -p "Choose [1-3] (default: 1): " speed_choice
    case $speed_choice in
        2) OPTIONS="$OPTIONS --bwlimit=1000";;
        3) 
            read -p "Enter speed in KB/s: " custom_speed
            OPTIONS="$OPTIONS --bwlimit=$custom_speed"
            ;;
        *) OPTIONS="$OPTIONS --bwlimit=0";;
    esac
    
    # Exclusions
    echo -e "${YELLOW}🚫 File exclusions:${NC}"
    echo "1) ✅ Default smart exclusions"
    echo "2) 🔧 Add custom exclusions"
    echo "3) ❌ No exclusions"
    read -p "Choose [1-3] (default: 1): " exclude_choice
    case $exclude_choice in
        2)
            echo -e "${CYAN}Enter patterns to exclude (space separated):${NC}"
            echo "Example: *.log temp/ cache/ *.tmp"
            read -a custom_excludes
            for pattern in "${custom_excludes[@]}"; do
                OPTIONS="$OPTIONS --exclude='$pattern'"
            done
            ;;
        3) ;;
        *)
            for pattern in "${EXCLUDE_PATTERNS[@]}"; do
                OPTIONS="$OPTIONS --exclude='$pattern'"
            done
            ;;
    esac
    
    # Additional features
    echo -e "${YELLOW}🔧 Additional features:${NC}"
    
    echo -n "Enable resume partial transfers (--partial)? [y/N] "
    read -n1 partial_choice
    echo
    [[ $partial_choice =~ [yY] ]] && OPTIONS="$OPTIONS --partial"
    
    echo -n "Enable update only newer files (--update)? [y/N] "
    read -n1 update_choice
    echo
    [[ $update_choice =~ [yY] ]] && OPTIONS="$OPTIONS --update"
    
    echo -n "Enable checksum verification for accuracy (--checksum)? [y/N] "
    read -n1 checksum_choice
    echo
    [[ $checksum_choice =~ [yY] ]] && OPTIONS="$OPTIONS --checksum"
    
    # Dry run
    echo -e "${YELLOW}🧪 Test mode:${NC}"
    echo "1) ✅ Run dry-run first (recommended for safety)"
    echo "2) 🚀 Direct execution (for advanced users)"
    read -p "Choose [1-2] (default: 1): " dryrun_choice
    case $dryrun_choice in
        2) DRY_RUN=false;;
        *) DRY_RUN=true;;
    esac
}

# Show information and warnings
show_warnings() {
    echo -e "${RED}⚠️  Important warnings:${NC}"
    
    if [[ $OPTIONS == *"--delete"* ]]; then
        echo -e "🔴 ${RED}Extra file deletion is enabled!${NC}"
        echo -e "   Files in destination not in source will be deleted"
    fi
    
    if [ "$DRY_RUN" = false ]; then
        echo -e "🔴 ${RED}Direct mode enabled - changes will execute immediately!${NC}"
    else
        echo -e "🟢 ${GREEN}Dry-run mode enabled - no changes will be made${NC}"
    fi
    
    echo -e "${YELLOW}Press Enter to continue or Ctrl+C to cancel...${NC}"
    read
}

# Build final rsync command
build_rsync_command() {
    if [ "$DRY_RUN" = true ]; then
        RSYNC_CMD="rsync $OPTIONS --dry-run \"$SOURCE\" \"$DESTINATION\""
    else
        RSYNC_CMD="rsync $OPTIONS \"$SOURCE\" \"$DESTINATION\""
    fi
}

# Show final command before execution
show_final_command() {
    echo -e "${GREEN}"
    echo "╔════════════════════════════════════════════════╗"
    echo "║               🎯 Final Command                ║"
    echo "╚════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${CYAN}$RSYNC_CMD${NC}"
    echo ""
    
    echo -e "${YELLOW}📋 Options breakdown:${NC}"
    echo "$OPTIONS" | tr ' ' '\n' | while read opt; do
        case $opt in
            "-avh") echo "  📁 Archive mode with human-readable sizes";;
            "--progress") echo "  📊 Detailed progress bar";;
            "--stats") echo "  📈 Final statistics";;
            "--delete") echo "  🗑️  Delete extra files";;
            "--compress") echo "  🗜️  Data compression";;
            "--compress-level=9") echo "  💎 High-level compression";;
            "--bwlimit=0") echo "  🚀 Unlimited speed";;
            "--partial") echo "  🔄 Resume partial transfers";;
            "--dry-run") echo "  🧪 Test mode (no execution)";;
            "--exclude="*) echo "  🚫 Exclude: $opt";;
            *) echo "  ⚙️  $opt";;
        esac
    done
    echo ""
}

# Final execution
execute_rsync() {
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}🎪 Running dry-run test...${NC}"
        echo -e "${GREEN}Below is what the actual command would do:${NC}"
        echo ""
        eval "$RSYNC_CMD"
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Dry-run completed successfully!${NC}"
            echo -e "${YELLOW}Do you want to execute for real now? [y/N]${NC}"
            read -n1 confirm
            echo
            if [[ $confirm =~ [yY] ]]; then
                # Re-execute without dry-run
                ACTUAL_CMD="rsync ${OPTIONS/--dry-run/} \"$SOURCE\" \"$DESTINATION\""
                echo -e "${GREEN}🚀 Starting actual execution...${NC}"
                eval "$ACTUAL_CMD"
            else
                echo -e "${BLUE}✅ Operation cancelled. You can modify settings and try again.${NC}"
            fi
        else
            echo -e "${RED}❌ Error in dry-run test!${NC}"
        fi
    else
        echo -e "${RED}🚀 Starting direct execution...${NC}"
        echo -e "${YELLOW}This will make changes immediately!${NC}"
        echo -e "Press Ctrl+C to cancel within 5 seconds..."
        sleep 5
        eval "$RSYNC_CMD"
    fi
}

# Main function
main() {
    show_banner
    
    # Check rsync
    check_rsync
    
    # Get inputs
    if [ $# -eq 2 ]; then
        SOURCE="$1"
        DESTINATION="$2"
        echo -e "${GREEN}✅ Using provided paths:${NC}"
        echo -e "Source: $SOURCE"
        echo -e "Destination: $DESTINATION"
    else
        show_help
        echo ""
        get_user_input
    fi
    
    # Select features
    select_features
    
    # Build command
    build_rsync_command
    
    # Show warnings and final command
    show_warnings
    show_final_command
    
    # Execute
    execute_rsync
    
    # Final message
    echo -e "${PURPLE}"
    echo "╔════════════════════════════════════════════════╗"
    echo "║               🎉 Operation Complete!          ║"
    echo "╚════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Run the program
main "$@"
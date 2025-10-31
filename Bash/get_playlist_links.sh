#!/bin/bash

# --------------------------------------------------------
# 🎬 YouTube Playlist to Markdown - Multiple Styles
# --------------------------------------------------------

set -euo pipefail  # Exit on error, undefined variables

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Dependency check
check_dependencies() {
    local deps=("yt-dlp" "jq")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo -e "${RED}❌ Error: $dep is not installed${NC}"
            exit 1
        fi
    done
}

# Validate YouTube URL (accepts many common forms)
validate_url() {
    local url="$1"
    # Accept http/https, with or without www, mobile subdomains, ensure either /playlist? or list= present
    if [[ "$url" =~ ^https?://([a-z0-9.-]+\.)?youtube\.com/playlist\? ]] || \
       [[ "$url" =~ ^https?://([a-z0-9.-]+\.)?youtube\.com/.*(\&|\?)list= ]] || \
       [[ "$url" =~ ^https?://youtu\.be/.*(\&|\?)list= ]]; then
        return 0
    fi
    echo -e "${RED}❌ Invalid YouTube playlist URL — make sure it's a playlist URL (contains /playlist or list=).${NC}"
    return 1
}

# Main script
main() {
    clear
    echo -e "${CYAN}🎬 YouTube Playlist to Markdown Converter${NC}"
    echo -e "${PURPLE}==========================================${NC}"
    
    check_dependencies

    # Get output file
    echo -e "\n${CYAN}📁 Enter full path to Markdown file:${NC}"
    read -r OUTPUT_FILE

    if [ -z "$OUTPUT_FILE" ]; then
        echo -e "${RED}❌ No file path provided. Exiting.${NC}"
        exit 1
    fi

    # Create file if it doesn't exist
    if [ ! -f "$OUTPUT_FILE" ]; then
        echo -e "${YELLOW}🆕 Creating new file: $OUTPUT_FILE${NC}"
        touch "$OUTPUT_FILE"
    fi

    # Check if file is writable
    if [ ! -w "$OUTPUT_FILE" ]; then
        echo -e "${RED}❌ File is not writable: $OUTPUT_FILE${NC}"
        exit 1
    fi

    ADD_MORE="y"
    while [[ "$ADD_MORE" =~ ^[Yy]$ ]]; do
        echo -e "\n${CYAN}🎥 Enter YouTube playlist URL:${NC}"
        read -r PLAYLIST_URL
        
        # Clean up URL
        PLAYLIST_URL=$(echo "$PLAYLIST_URL" | tr -d '\\' | xargs)

        # Validate URL
        if ! validate_url "$PLAYLIST_URL"; then
            continue
        fi

        echo -e "${YELLOW}📦 Fetching playlist data...${NC}"
        
        # Fetch playlist data with error handling (let yt-dlp report errors)
        if ! output=$(yt-dlp --flat-playlist -J "$PLAYLIST_URL" 2>&1); then
            echo -e "${RED}❌ Error fetching playlist. yt-dlp output:${NC}"
            echo "$output"
            continue
        fi

        if [ -z "$output" ]; then
            echo -e "${RED}❌ No data received from playlist.${NC}"
            continue
        fi

        # Extract playlist info
        playlist_title=$(echo "$output" | jq -r '.title // "Unknown Playlist"')
        mapfile -t titles < <(echo "$output" | jq -r '.entries[]?.title // empty')
        mapfile -t ids < <(echo "$output" | jq -r '.entries[]?.id // empty')
        
        count=${#titles[@]}
        today=$(date +"%Y-%m-%d")

        if [ "$count" -eq 0 ]; then
            echo -e "${YELLOW}❌ No videos found in playlist.${NC}"
            continue
        fi

        echo -e "${GREEN}✅ Found $count videos in '$playlist_title'${NC}"

        # Add separator if file has existing content
        if [ -s "$OUTPUT_FILE" ]; then
            printf "\n---\n\n" >> "$OUTPUT_FILE"
        fi

        # Write to Markdown file (use proper markdown links)
        {
            echo "# 🎞️ $playlist_title"
            echo "**Imported:** $today | **Videos:** $count"
            echo "**Source:** $PLAYLIST_URL"
            echo ""

            for i in "${!titles[@]}"; do
                idx=$((i+1))
                    title="${titles[$i]}"
                echo "- [ ] 🎬 ${idx}. ${title}"
                echo "![${titles[$i]}](https://www.youtube.com/watch?v=${ids[$i]})"
                echo ""
            done
        } >> "$OUTPUT_FILE"

        echo -e "${GREEN}✅ Successfully saved $count videos to $OUTPUT_FILE${NC}"

        echo -e "\n${CYAN}➕ Add another playlist? (y/n):${NC}"
        read -r ADD_MORE
    done

    echo -e "${GREEN}🎉 All done! Output file: $OUTPUT_FILE${NC}"
    echo -e "${BLUE}📊 Total lines: $(wc -l < "$OUTPUT_FILE")${NC}"
}

# Run main function
main "$@"

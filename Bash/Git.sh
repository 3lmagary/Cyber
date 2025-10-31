#!/bin/bash

# Root directory to start scanning (change if needed)
BASE_DIR="/mnt/MyProject"

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RESET='\033[0m'

echo -e "${BLUE}🔍 Scanning for Git repositories in:${RESET} $BASE_DIR"
echo "------------------------------------------------------------"

count=0
modified=0
ahead=0

# Find all directories containing .git
find "$BASE_DIR" -type d -name ".git" 2>/dev/null | while read gitdir; do
    repo=$(dirname "$gitdir")
    cd "$repo" || continue
    ((count++))

    repo_name=$(basename "$repo")
    branch=$(git branch --show-current 2>/dev/null)
    status=$(git status --porcelain)

    # Check for uncommitted or unstaged changes
    if [ -n "$status" ]; then
        ((modified++))
        echo -e "${YELLOW}📁 $repo_name${RESET} ($repo)"
        echo "   🔸 Local changes not committed or staged"
        git status -s
        echo "------------------------------------------------------------"
    else
        # Check for commits not pushed or remote changes
        git fetch --quiet 2>/dev/null
        local_commit=$(git rev-parse @ 2>/dev/null)
        remote_commit=$(git rev-parse "@{u}" 2>/dev/null)
        base_commit=$(git merge-base @ "@{u}" 2>/dev/null)

        if [ "$local_commit" != "$remote_commit" ]; then
            ((ahead++))
            echo -e "${GREEN}📁 $repo_name${RESET} ($repo)"
            echo "   🔹 Local and remote commits are out of sync"
            git status -sb
            echo "------------------------------------------------------------"
        fi
    fi
done

echo
echo "✅ Scan completed."
echo "------------------------------------------------------------"
echo -e "Total repositories scanned: ${BLUE}$count${RESET}"
echo -e "Repositories with local changes: ${YELLOW}$modified${RESET}"
echo -e "Repositories ahead or behind remote: ${GREEN}$ahead${RESET}"
echo

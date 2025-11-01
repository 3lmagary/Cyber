#!/bin/bash

# =========================================================
# CONFIG
# =========================================================
BASE_DIR="/mnt/MyProject"

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Counters
count=0
modified=0
out_of_sync=0
clean=0
no_remote=0

# =========================================================
# START SCAN
# =========================================================
echo -e "${BLUE}🔍 Scanning all Git repositories under:${RESET} ${CYAN}$BASE_DIR${RESET}"
echo "------------------------------------------------------------"

while IFS= read -r gitdir; do
    repo=$(dirname "$gitdir")
    cd "$repo" || continue
    ((count++))

    repo_name=$(basename "$repo")
    branch=$(git symbolic-ref --short HEAD 2>/dev/null)

    # 🔹 Check for local/untracked changes
    status=$(git status --porcelain 2>/dev/null)
    if [ -n "$status" ]; then
        ((modified++))
        echo -e "${YELLOW}📁 $repo_name${RESET} [${branch}]"
        echo -e "   ${YELLOW}🔸 Local changes or untracked files${RESET}"
        echo -e "   ${BLUE}📂 Path:${RESET} $repo"
        echo "$status"
        echo "------------------------------------------------------------"
        continue
    fi

    # 🔹 Check for remote tracking
    remote_branch=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
    if [ -z "$remote_branch" ]; then
        ((no_remote++))
        echo -e "${CYAN}📁 $repo_name${RESET} [${branch}]"
        echo -e "   ${CYAN}🟡 No remote tracking branch${RESET}"
        echo -e "   ${BLUE}📂 Path:${RESET} $repo"
        echo "------------------------------------------------------------"
        continue
    fi

    # 🔹 Compare with remote
    git fetch --quiet 2>/dev/null
    local_commit=$(git rev-parse @ 2>/dev/null)
    remote_commit=$(git rev-parse @{u} 2>/dev/null)
    base_commit=$(git merge-base @ @{u} 2>/dev/null)

    if [ "$local_commit" = "$remote_commit" ]; then
        ((clean++))
    elif [ "$local_commit" = "$base_commit" ]; then
        ((out_of_sync++))
        echo -e "${RED}⬇️ $repo_name${RESET} [${branch}] - ${RED}Behind remote${RESET}"
        echo -e "   ${BLUE}📂 Path:${RESET} $repo"
        echo "------------------------------------------------------------"
    elif [ "$remote_commit" = "$base_commit" ]; then
        ((out_of_sync++))
        echo -e "${YELLOW}⬆️ $repo_name${RESET} [${branch}] - ${YELLOW}Ahead of remote${RESET}"
        echo -e "   ${BLUE}📂 Path:${RESET} $repo"
        echo "------------------------------------------------------------"
    else
        ((out_of_sync++))
        echo -e "${RED}⚠️ $repo_name${RESET} [${branch}] - ${RED}Diverged (ahead & behind)${RESET}"
        echo -e "   ${BLUE}📂 Path:${RESET} $repo"
        echo "------------------------------------------------------------"
    fi
done < <(find "$BASE_DIR" -type d -name ".git" -prune 2>/dev/null)

# =========================================================
# SUMMARY
# =========================================================
echo
echo -e "${BLUE}==================== Scan Summary ====================${RESET}"
printf "📦 Total repositories scanned: ${CYAN}%d${RESET}\n" "$count"
printf "📝 Repositories with local/untracked changes: ${YELLOW}%d${RESET}\n" "$modified"
printf "🔄 Repositories ahead/behind remote: ${RED}%d${RESET}\n" "$out_of_sync"
printf "🟢 Clean and synced repositories: ${GREEN}%d${RESET}\n" "$clean"
printf "🟡 No remote tracking branch: ${CYAN}%d${RESET}\n" "$no_remote"
echo -e "${BLUE}======================================================${RESET}"

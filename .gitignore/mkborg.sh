#!/bin/bash
# REPO="/vs/vs-Storage/backups/repo"
REPO="/mnt/Data/repo"

# -------------------- Colors --------------------
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
RED="\e[31m"
RESET="\e[0m"
BOLD="\e[1m"

# -------------------- Read repo password once --------------------
echo -ne "${BOLD}${CYAN}Enter Borg Repository Password:${RESET} "
read -s BORG_PASSPHRASE
echo
export BORG_PASSPHRASE

# -------------------- Folders List --------------------
declare -A FOLDERS=(
    [1]="/home/3lmagary"
    [2]="/mnt/Main/iso"
    [3]="/mnt/Main/app"
    [4]="/mnt/Main/Book"
    [5]="/mnt/Main/Vmware"
    [6]="/mnt/Data/test"
    [7]="/mnt/Data/test2"
)

clear

# -------------------- Show Repo Content --------------------
echo -e "${BOLD}${CYAN}========== Available Snapshots ==========${RESET}"
borg list "$REPO" --format="{archive} " 2>/dev/null | xargs -n1 || borg list "$REPO"
echo -e "${CYAN}==========================================${RESET}"
echo

# -------------------- Folder List --------------------
echo -e "${BOLD}${BLUE}Folders available for backup:${RESET}"
for i in "${!FOLDERS[@]}"; do
    echo -e "${YELLOW}$i)${RESET} ${FOLDERS[$i]}"
done
echo

# -------------------- Input --------------------
echo -e "${BOLD}${CYAN}Enter folder numbers separated by commas (example: 1,3,5):${RESET}"
read -p "> " CHOICE

read -p "Enter Snapshot Number (e.g. 01): " num

CHOICE=$(echo "$CHOICE" | tr -d ' ')
IFS=',' read -ra SELECTED <<< "$CHOICE"

clear
echo -e "${BOLD}${CYAN}========== Backup Summary and Execution ==========${RESET}"

# -------------------- Execute backups --------------------
for n in "${SELECTED[@]}"; do

    FOLDER="${FOLDERS[$n]}"

    if [[ -z "$FOLDER" ]]; then
        echo -e "${RED}Invalid number: $n${RESET}"
        continue
    fi

    FOLDER_BASE=$(basename "$FOLDER")
    SNAP_NAME="$num-$FOLDER_BASE"
    CMD="borg create --stats --progress $REPO::$SNAP_NAME $FOLDER"

    echo -e "${YELLOW}Folder:${RESET} $FOLDER"
    echo -e "${YELLOW}Snapshot:${RESET} $SNAP_NAME"
    echo -e "${BLUE}Command:${RESET} $CMD"
    eval "$CMD"
    echo

    # -------- Ask for diff for THIS folder only --------
echo -e "${BOLD}${CYAN}========== Snapshot Comparison ==========${RESET}"
echo -e "${CYAN}Do you want to compare the new backup (${SNAP_NAME}) with an older one? (y/n)${RESET}"
read -p "> " do_diff

if [[ "$do_diff" == "y" || "$do_diff" == "Y" ]]; then
    OLD_NUM=$(printf "%02d" $((10#$num - 1)))
    OLD_SNAP="${OLD_NUM}-${FOLDER_BASE}"

    echo -e "${BLUE}Running diff:${RESET} borg diff $REPO::$OLD_SNAP $SNAP_NAME"
    echo "-----------------------------------------"

    borg diff "$REPO::$OLD_SNAP" "$SNAP_NAME" 2>&1
    echo
    echo -e "${CYAN}==========================================${RESET}"
fi

done 

echo -e "\n${GREEN}All backups completed.${RESET}"

# -------------------- Secure cleanup --------------------
unset BORG_PASSPHRASE
#!/bin/bash
# # Big buggy script — debug this to practice Bash troubleshooting.

DIR="$1"
LOGFILE="$2"

# ask for directory if not provided
if [[ -f "$DIR" ]]; then
  read -r -p "Enter a directory to scan: " DIR
fi

# # BUG: test uses literal DIR instead of variable
if [ ! -d "$DIR" ]; then
  echo "Directory '$DIR' does not exist."
  exit 1
fi

# # Build file list (BUG: using ls + word splitting, not handling spaces)
files=$(ls "$DIR")

total=0
for f in $(files[@]); do
  # BUG: stat uses only basename (ls output) and may fail; also unhandled errors
  size=$(stat -c%s "$f" 2>/dev/null)
  total=$(( total + size ))
done

echo "Total bytes: $total"

# # BUG: wrong length expansion for arrays
avg=$(( $total / $files ))
echo "Average bytes: $avg"

# # Log file processing
if [[ -z $LOGFILE ]]; then
  LOGFILE="$DIR/system.log"
fi

if [ -f "$LOGFILE" ]; then
  line_count=0
  # BUG: using pipe here causes the while to run in a subshell (line_count won't persist)
  cat "$LOGFILE" | while read -r line ; do
    # BUG: unquoted expansion; also grep usage could be simplified
    if echo $line | grep "ERROR" >/dev/null; then
      echo "Found ERROR: $line"
    fi
    (($line_count++))
  done
  echo "Lines in log: $line_count"
else
  echo "Logfile '$LOGFILE' not found"
fi

# # CSV processing (assume CSV with numeric fields)
csv="$DIR/data.csv"
if [ -f "$csv" ]; then
  # BUG: using double quotes around awk program (shell will try to expand $3), wrong field used
  total_csv=$(awk -F, "{ sum += $3 } END { print sum }" "$csv")
  echo "CSV total: $total_csv"
fi

# # Function to get disk usage — BUG: returns disk via 'return' instead of echo (and return can only be 0-255)
# get_disk_usage() {
#   du -sb "$DIR" | cut -f1 > /tmp/du.$$ 
#   disk=$(cat /tmp/du.$$)
#   return $disk
# }

# disk_used=$(get_disk_usage)
# echo "Disk used: $disk_used"

# # trap cleanup but function defined after trap (ok in bash), cleanup uses tmp file variable
# trap cleanup EXIT

# cleanup() {
#   rm -f /tmp/du.$$
#   echo "Temp removed"
# }

# # Arrays: collect .txt files (BUG: unquoted glob + if no match pattern remains)
# txts=($DIR/*.txt)

# echo "Found ${#txts} text files"
# for i in ${!txts[@]}; do
#   echo "File $i : ${txts[i]}"
#   # BUG: trying to use arithmetic on filename (invalid)
#   len=$(( ${txts[i]} ))
#   echo "Length guess: $len"
# done

# # Simple menu with case — BUG: missing esac and other quoting issues
read -r -p "1) Show disk usage
2) Show top 5 largest files in dir
3) Exit
Choose: " choice

case $choice in
1) get_disk_usage ;;
2) ls -lh "$DIR" | sort -k5 -n | tail -n 5 ;;
3) echo "Bye" ; exit 0 ;;
*) echo "Invalid"
esac
# # BUG: forgot esac here

# # End of script
# #
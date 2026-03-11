#!/usr/bin/env bash
#
# init.sh - Auto-source all shell functions from accessible-dotfiles
#
# Usage: Add this line to your ~/.bashrc:
#   source /path/to/accessible-dotfiles/init.sh

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source all .sh files recursively, excluding this init file
while IFS= read -r -d '' script; do
  # Skip this init script itself
  [[ "$(basename "$script")" == "init.sh" ]] && continue
  
  # Source the script
  source "$script"
done < <(find "$DOTFILES_DIR" -type f -name "*.sh" -print0)

# Optional: Print loaded functions for debugging
# Uncomment the following lines if you want to see what gets loaded:
# echo "Loaded functions from accessible-dotfiles:"
# declare -F | grep -E "gh_|custom_function_prefix" | awk '{print "  - " $3}'
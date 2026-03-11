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

# adh - Accessible Dotfiles Help
# Navigate the dotfiles hierarchy with numbered menus for screen readers
adh() {
  local dotfiles_dir="$DOTFILES_DIR"
  local topic="$1"
  local script="$2"
  
  # Level 1: Show topics (directories)
  if [[ -z "$topic" ]]; then
    echo "Topics:"
    local -a topics
    local idx=1
    while IFS= read -r dir; do
      local topic_name="$(basename "$dir")"
      topics+=("$topic_name")
      echo "$idx. $topic_name"
      ((idx++))
    done < <(find "$dotfiles_dir" -mindepth 1 -maxdepth 1 -type d -not -name ".*" | sort)
    
    [[ ${#topics[@]} -gt 0 ]] && echo "Usage: adh ${topics[0]}"
    return 0
  fi
  
  local topic_dir="$dotfiles_dir/$topic"
  
  # Check if topic exists
  if [[ ! -d "$topic_dir" ]]; then
    echo "Topic '$topic' not found. Run 'adh' to list."
    return 1
  fi
  
  # Level 2: Show scripts in topic
  if [[ -z "$script" ]]; then
    echo "$topic scripts:"
    local -a scripts
    local idx=1
    while IFS= read -r file; do
      local script_name="$(basename "$file" .sh)"
      scripts+=("$script_name")
      echo "$idx. $script_name"
      ((idx++))
    done < <(find "$topic_dir" -maxdepth 1 -type f -name "*.sh" | sort)
    
    [[ ${#scripts[@]} -gt 0 ]] && echo "Usage: adh $topic ${scripts[0]}"
    return 0
  fi
  
  local script_file="$topic_dir/$script.sh"
  
  # Check if script exists
  if [[ ! -f "$script_file" ]]; then
    echo "Script '$script' not found. Run 'adh $topic' to list."
    return 1
  fi
  
  # Level 3: Show functions in script
  echo "$topic/$script functions:"
  local -a functions
  local idx=1
  
  # Extract function names from the script
  while IFS= read -r func_name; do
    functions+=("$func_name")
    
    # Try to extract the comment line directly before function declaration
    local line_num=$(grep -n "^${func_name}()" "$script_file" | cut -d: -f1)
    local description=""
    if [[ -n "$line_num" && "$line_num" -gt 1 ]]; then
      local prev_line=$((line_num - 1))
      description=$(sed -n "${prev_line}p" "$script_file" | grep "^#" | sed 's/^#[[:space:]]*//')
    fi
    
    if [[ -n "$description" ]]; then
      echo "$idx. $func_name - $description"
    else
      echo "$idx. $func_name"
    fi
    
    ((idx++))
  done < <(grep -E "^[a-zA-Z_][a-zA-Z0-9_]*\(\)" "$script_file" | sed 's/().*//' | sort)
  
  return 0
}
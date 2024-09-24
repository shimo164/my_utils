#!/bin/bash

: '
This script provides an interactive command selector using fzf.

It sources commands and their aliases from an external file named "settings.sh"
which declares an associative array `commands` with aliases as keys and their
corresponding commands as values.

This script uses fzf to create an interactive menu of the aliases, which the user can select from.
Upon selecting an alias, the script executes the corresponding command.

Usage:
./main.sh

Dependencies:
fzf: https://github.com/junegunn/fzf
settings.sh: should be in the same directory as main.sh

Author: Your Name
Date: Month Day, Year
'

# Get the directory of the currently executing script
DIR="${SCRIPTS}"

declare -A commands
commands=(
  ["git push force-with-lease"]="git push --force-with-lease --force-if-includes"
  ["git toplevel dir"]="git rev-parse --show-toplevel"
  ["git safe push"]="bash ${DIR}/git_safe_push.sh"
  ["git checkout"]="bash ${DIR}/git_branch_checkout.sh"
  ["git stash specific files"]="bash ${DIR}/git_stash_specific_files.sh"
  ["ChatGPT print out files"]="bash ${DIR}/print_out_selected_files.sh > ${DIR}/tmp_print_out_selected_files.txt && code ${DIR}/tmp_print_out_selected_files.txt"
)

# Create a list of aliases for fzf, sorted alphabetically
alias_list=$(printf '%s\n' "${!commands[@]}" | sort)

# Use fzf to select an alias
selected_alias=$(echo "$alias_list" | fzf)

# Get the corresponding command
selected_command="${commands["$selected_alias"]}"

# Run the selected command
if [ -n "$selected_command" ]; then
  echo "Running: $selected_command"
  eval "$selected_command"
else
  echo "Command not found!"
fi

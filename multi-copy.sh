#!/bin/bash

# Function to display the help menu
show_help() {
  echo "Usage: $0 <repo_list.txt>"
  echo
  echo "This script reads a text file with GitHub repository URLs, clones each repository"
  echo "using 'sudo git clone', and adds verbosity to the cloning process."
  echo
  echo "Options:"
  echo "  <repo_list.txt>    Path to the text file containing GitHub repository URLs (one URL per line)."
  echo "  -h, --help         Display this help menu and exit."
  echo
  echo "Example:"
  echo "  ./clone_repos.sh repos.txt"
}

# Check if help is requested
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  show_help
  exit 0
fi

# Check if the input file is provided
if [ -z "$1" ]; then
  echo "Error: No input file provided."
  show_help
  exit 1
fi

repo_list=$1

# Prompt for sudo password and temporarily store it
echo "Please enter your sudo password:"
read -s sudo_password

# Function to clean up the stored sudo password on exit
cleanup() {
  sudo_password=""
  unset sudo_password
}

# Register the cleanup function to be called on the EXIT signal
trap cleanup EXIT

# Read each line of the input file and clone the repo
while IFS= read -r repo; do
  if [[ -z "$repo" ]]; then
    continue
  fi
  echo "Cloning repository: $repo"
  if echo $sudo_password | sudo -S git clone "$repo" -v; then
    echo "Successfully cloned: $repo"
  else
    echo "Failed to clone: $repo (skipping)"
  fi
done < "$repo_list"

echo "All repositories have been processed."

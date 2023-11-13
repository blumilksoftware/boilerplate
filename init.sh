#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 source_directory target_directory old_string new_string"
    exit 1
fi

# Assign arguments to variables for better readability
SOURCE_DIR=$1
TARGET_DIR=$2
OLD_STRING=$3
NEW_STRING=$4

# Create the target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Copy files from source to target directory
shopt -s dotglob
cp -r "$SOURCE_DIR"/* "$TARGET_DIR"/
shopt -u dotglob

# Change the given string to a new string in all files in the target directory
# This uses a loop to go through each file and sed to perform the string replacement
find "$TARGET_DIR" -type f -exec sed -i "s/$OLD_STRING/$NEW_STRING/g" {} \;

echo "Operation completed."

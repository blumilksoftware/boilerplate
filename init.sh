#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 new_string"
    exit 1
fi

# Assign argument to variables for better readability
NEW_STRING=$1

# Current working directory
TARGET_DIR=$(pwd)

# Temporary directory for cloning
TEMP_DIR=$(mktemp -d)

# Clone the repository into a temporary directory
git clone --branch init "https://github.com/blumilksoftware/boilerplate" "$TEMP_DIR"

# Check if the clone was successful
if [ $? -ne 0 ]; then
    echo "Failed to clone the repository."
    exit 1
fi

# Move the desired subdirectory to the target directory
mv "$TEMP_DIR/src" "$TARGET_DIR"

# Remove the temporary directory
rm -rf "$TEMP_DIR"

# Change the given string to a new string in all files in the target directory
# This uses a loop to go through each file and sed to perform the string replacement
find "$TARGET_DIR" -type f -exec sed -i "s/ITPM/$NEW_STRING/g" {} \;

echo "Operation completed."

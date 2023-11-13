#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 app_name namespace"
    exit 1
fi

# Assign argument to variables for better readability
APP_NAME=$1
NAMESPACE=$2

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

# Enable dotglob to include hidden files
shopt -s dotglob

# Move the desired subdirectory to the target directory
mv "$TEMP_DIR/src/"* "$TARGET_DIR"

# Disable dotglob
shopt -u dotglob

# Remove the temporary directory
rm -rf "$TEMP_DIR"

# Change the given string to a new string in all files in the target directory
# This uses a loop to go through each file and sed to perform the string replacement
find "$TARGET_DIR" -type f -exec sed -i "s/example-app/$NEW_STRING/g" {} \;
find "$TARGET_DIR" -type f -exec sed -i "s/ExampleApp/$NAMESPACE/g" {} \;

echo "Operation completed."

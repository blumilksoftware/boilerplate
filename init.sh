#!/bin/bash

# Application name validation function
isValidAppNamespace() {
    local appName="$1"

    if [ -z "$appName" ]; then
        echo -e "${RED}Application name cannot be empty.${NC}"
        return 1
    fi

    if ! [[ $appName =~ ^[A-Z][a-zA-Z0-9]*$ ]]; then
        echo -e "${RED}Application name must start with an uppercase letter and be alphanumeric.${NC}"
        return 1
    fi

    local len=${#appName}
    if [ $len -lt 2 ] || [ $len -gt 20 ]; then
        echo -e "${RED}Application name must be between 2 and 20 characters.${NC}"
        return 1
    fi

    return 0
}

# Function to prompt for input
promptForInput() {
    read -p "Enter the app name: " APP_NAME
    read -p "Enter the namespace for the app: " APP_NAMESPACE
}

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Arguments missing or incomplete. Please follow the prompts."
    promptForInput
else
    # Assign arguments to variables
    APP_NAME=$1
    APP_NAMESPACE=$2
fi

# Validate the namespace
if ! isValidAppNamespace "$APP_NAMESPACE"; then
    exit 1
fi

# Current working directory
TARGET_DIR=$(pwd)

# Temporary directory for cloning
TEMP_DIR=$(mktemp -d)

# Clone the repository into a temporary directory
git clone "https://github.com/blumilksoftware/boilerplate" "$TEMP_DIR"

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
find "$TARGET_DIR" -type f -exec sed -i "s/example-app/$APP_NAME/g" {} \;
find "$TARGET_DIR" -type f -exec sed -i "s/ExampleApp/$APP_NAMESPACE/g" {} \;

echo "Operation completed."

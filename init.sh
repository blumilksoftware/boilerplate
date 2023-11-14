#!/bin/bash

set -e

BLUE='\033[01;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

isValidAppNamespace() {
    local appName="$1"

    if [ -z "$appName" ]; then
        echo -e "${RED}Application namespace cannot be empty.${NC}"
        return 1
    fi

    if ! [[ $appName =~ ^[A-Z][a-zA-Z0-9]*$ ]]; then
        echo -e "${RED}Application namespace must start with an uppercase letter and be alphanumeric.${NC}"
        return 1
    fi

    local len=${#appName}
    if [ $len -lt 2 ] || [ $len -gt 20 ]; then
        echo -e "${RED}Application namespace must be between 2 and 20 characters.${NC}"
        return 1
    fi

    return 0
}

promptForInput() {
    read -p "Enter the app name: " APP_NAME
    read -p "Enter the namespace for the app (leave empty for default namespace 'App'): " APP_NAMESPACE
    read -p "Enter the branch name (leave empty for default branch): " BRANCH_NAME
    APP_NAMESPACE=${APP_NAMESPACE:-App}
}

echo -e "${BLUE}
██████╗ ██╗     ██╗   ██╗███╗   ███╗██╗██╗     ██╗  ██╗    ██████╗  ██████╗ ██╗██╗     ███████╗██████╗ ██████╗ ██╗      █████╗ ████████╗███████╗
██╔══██╗██║     ██║   ██║████╗ ████║██║██║     ██║ ██╔╝    ██╔══██╗██╔═══██╗██║██║     ██╔════╝██╔══██╗██╔══██╗██║     ██╔══██╗╚══██╔══╝██╔════╝
██████╔╝██║     ██║   ██║██╔████╔██║██║██║     █████╔╝     ██████╔╝██║   ██║██║██║     █████╗  ██████╔╝██████╔╝██║     ███████║   ██║   █████╗
██╔══██╗██║     ██║   ██║██║╚██╔╝██║██║██║     ██╔═██╗     ██╔══██╗██║   ██║██║██║     ██╔══╝  ██╔══██╗██╔═══╝ ██║     ██╔══██║   ██║   ██╔══╝
██████╔╝███████╗╚██████╔╝██║ ╚═╝ ██║██║███████╗██║  ██╗    ██████╔╝╚██████╔╝██║███████╗███████╗██║  ██║██║     ███████╗██║  ██║   ██║   ███████╗
╚═════╝ ╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝╚══════╝╚═╝  ╚═╝    ╚═════╝  ╚═════╝ ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝
${NC}"

if [ "$#" -lt 1 ]; then
    echo "Arguments missing or incomplete. Please follow the prompts."
    promptForInput
else
    APP_NAME=$1
    APP_NAMESPACE=${2:-App}
    BRANCH_NAME=${3:-}
fi

if ! isValidAppNamespace "$APP_NAMESPACE"; then
    exit 1
fi

TARGET_DIR=$(pwd)
TEMP_DIR=$(mktemp -d)

if [ -z "$BRANCH_NAME" ]; then
    git clone "https://github.com/blumilksoftware/boilerplate" "$TEMP_DIR"
else
    git clone --branch "$BRANCH_NAME" "https://github.com/blumilksoftware/boilerplate" "$TEMP_DIR"
fi

if [ $? -ne 0 ]; then
    echo "Failed to clone the repository."
    exit 1
fi

shopt -s dotglob
mv "$TEMP_DIR/src/"* "$TARGET_DIR"
shopt -u dotglob

rm -rf "$TEMP_DIR"

find "$TARGET_DIR" -type f -exec sed -i "s/example-app/$APP_NAME/g" {} \;
find "$TARGET_DIR" -type f -exec sed -i "s/ExampleApp/$APP_NAMESPACE/g" {} \;

echo "Boilerplate copied."

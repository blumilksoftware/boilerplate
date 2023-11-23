#!/bin/bash

set -e

BLUE='\033[01;34m'
RED='\033[0;31m'
NC='\033[0m'

isValidAppNamespace() {
    local appName="$1"

    if [ -z "$appName" ]; then
        echo -e "${RED}Application namespace cannot be empty.${NC}"
        return 1
    fi

    if ! [[ $appName =~ ^[A-Z][a-zA-Z0-9\\]*$ ]]; then
        echo -e "${RED}Application namespace must start with an uppercase letter and be alphanumeric.${NC}"
        return 1
    fi

    local len=${#appName}
    if [ "$len" -lt 2 ] || [ "$len" -gt 20 ]; then
        echo -e "${RED}Application namespace must be between 2 and 20 characters.${NC}"
        return 1
    fi

    return 0
}

promptForInput() {
    read -r -p "Enter the app name: " APP_NAME
    read -r -p "Enter the namespace for the app (leave empty for default namespace 'App'): " APP_NAMESPACE
    read -r -p "Enter the branch name (leave empty for default branch): " BRANCH_NAME
    read -r -p "Enter the docker app host port (leave empty for default 63851): " DOCKER_APP_HOST_PORT
    read -r -p "Enter the docker database host port (leave empty for default 63853): " DOCKER_DATABASE_HOST_PORT
    read -r -p "Enter the docker mailpit host port (leave empty for default 63854): " DOCKER_MAILPIT_DASHBOARD_HOST_PORT
    read -r -p "Enter the docker redis host port (leave empty for default 63854): " DOCKER_REDIS_HOST_PORT
    APP_NAMESPACE=${APP_NAMESPACE:-App}
    DOCKER_APP_HOST_PORT=${DOCKER_APP_HOST_PORT:-63851}
    DOCKER_DATABASE_HOST_PORT=${DOCKER_DATABASE_HOST_PORT:-63853}
    DOCKER_MAILPIT_DASHBOARD_HOST_PORT=${DOCKER_MAILPIT_DASHBOARD_HOST_PORT:-63854}
    DOCKER_REDIS_HOST_PORT=${DOCKER_REDIS_HOST_PORT:-63852}
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
    DOCKER_APP_HOST_PORT=${4:-63851}
    DOCKER_DATABASE_HOST_PORT=${5:-63853}
    DOCKER_MAILPIT_DASHBOARD_HOST_PORT=${6:-63854}
    DOCKER_REDIS_HOST_PORT=${7:-63852}
fi

if ! isValidAppNamespace "$APP_NAMESPACE"; then
    exit 1
fi

TEMP_DIR=$(mktemp -d)
TARGET_DIR="$(pwd)/$APP_NAME"

# Check if the directory already exists
if [ -d "$TARGET_DIR" ]; then
    echo -e "${RED}Directory $TARGET_DIR already exists. Please choose a different app name or remove the existing directory.${NC}"
    exit 1
fi

# Create the new directory
mkdir -p "$TARGET_DIR"

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

ESCAPED_APP_NAMESPACE=$(printf '%s\n' "$APP_NAMESPACE" | sed -e 's/[\/&]/\\&/g')
find "$TARGET_DIR" -type f -exec sed -i "s/example-app/$APP_NAME/g" {} \;
find "$TARGET_DIR" -type f -exec sed -i "s/ExampleApp/$ESCAPED_APP_NAMESPACE/g" {} \;
find "$TARGET_DIR" -type f -name ".env.example" -exec sed -i "s/63851/$DOCKER_APP_HOST_PORT/g" {} \;
find "$TARGET_DIR" -type f -name ".env.example" -exec sed -i "s/63853/$DOCKER_DATABASE_HOST_PORT/g" {} \;
find "$TARGET_DIR" -type f -name ".env.example" -exec sed -i "s/63854/$DOCKER_MAILPIT_DASHBOARD_HOST_PORT/g" {} \;
find "$TARGET_DIR" -type f -name ".env.example" -exec sed -i "s/63852/$DOCKER_REDIS_HOST_PORT/g" {} \;

echo "Boilerplate copied."

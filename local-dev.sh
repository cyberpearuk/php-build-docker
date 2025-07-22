#!/bin/bash

set -euo pipefail

# Determine namespace and name from script location
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
NAMESPACE=$(basename "$(dirname "$SCRIPT_DIR")")
NAME=$(basename "$SCRIPT_DIR")
DOCKER_TAG=development

IMAGE_NAME="${NAMESPACE}/${NAME}:${DOCKER_TAG}"

# Build the Docker image
build() {
    echo "Building Docker image: ${IMAGE_NAME}"
    docker build -t "$IMAGE_NAME" "$SCRIPT_DIR"
}

# Display usage information
usage() {
    echo "Usage: $0 {build|run|build-run|build-push}"
    exit 1
}

# Main command dispatcher
case "${1:-}" in
    build)
        build
        ;;
    *)
        usage
        ;;
esac

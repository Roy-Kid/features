#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

if ! command -v cmake --version &> /dev/null
then
    echo "cmake could not be found"
    exit 1
fi

# Report result
reportResults
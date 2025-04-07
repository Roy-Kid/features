#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

# test if default shell is zsh
if [ "$SHELL" != "/bin/zsh" ]; then
    echo "Default shell is not zsh"
    exit 1
fi

# Report result
reportResults
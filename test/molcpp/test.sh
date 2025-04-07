#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

# test if default shell is zsh
check "cmake" cmake  --version
check "clangd" clangd --version

# Report result
reportResults
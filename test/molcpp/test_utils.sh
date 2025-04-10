#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

# test if default shell is zsh
check "test_zsh_default" echo $SHELL | grep -q zsh
check "test_cmake" cmake --version
check "test_ninja" ninja --version
check "test_clangd" clangd --version

# Report result
reportResults
#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

# # Check if clangd is installed
# if ! command -v clangd &> /dev/null
# then
#     echo "clangd could not be found"
#     exit 1
# fi
# # Check if clang-tidy is installed
# if ! command -v clang-tidy &> /dev/null
# then
#     echo "clang-tidy could not be found"
#     exit 1
# fi

# Report result
reportResults
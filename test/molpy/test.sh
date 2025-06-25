#!/bin/bash

# Test file for molpy feature

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Basic tool availability tests
check "python3 is available" python3 --version
check "pip3 is available" pip3 --version
check "conda is available" conda --version

# Test Jupyter installation
check "jupyter is available" jupyter --version
check "jupyter lab is available" jupyter lab --version

# Test development tools
check "black is available" black --version
check "isort is available" isort --version

# Report result
reportResults

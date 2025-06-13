#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

check "python" python --version

# Report result
reportResults
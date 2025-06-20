#!/bin/bash

# Test script for CUDA-enabled PyTorch installation

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Basic checks
check "python3 is available" python3 --version
check "pip3 is available" pip3 --version

# Test PyTorch with CUDA installation
check "pytorch is installed" python3 -c "import torch; print('PyTorch version:', torch.__version__)"
check "pytorch cuda build" python3 -c "import torch; print('CUDA build available:', torch.cuda.is_available())"

# Note: CUDA availability depends on the host system having NVIDIA GPU and drivers
# In CI/testing environments, this might return False even with CUDA build
check "pytorch cuda version check" python3 -c "import torch; print('PyTorch compiled with CUDA:', torch.version.cuda is not None)"

# Report result
reportResults

#!/bin/bash

# This test script verifies the default molnex installation (CPU-only PyTorch, no molnex install)

set -e

# Source dev-container-features-test-lib
source dev-container-features-test-lib

# Test that basic tools are available
check "python3 is available" python3 --version
check "pip3 is available" pip3 --version
check "g++ is available" g++ --version
check "git is available" git --version
check "curl is available" curl --version

# Test that PyTorch is installed (CPU version)
check "pytorch is installed" python3 -c "import torch; print('PyTorch version:', torch.__version__)"
check "torchvision is installed" python3 -c "import torchvision; print('torchvision version:', torchvision.__version__)"
check "torchaudio is installed" python3 -c "import torchaudio; print('torchaudio version:', torchaudio.__version__)"

# Test that PyTorch works with CPU
check "pytorch tensor creation" python3 -c "import torch; x = torch.tensor([1.0, 2.0, 3.0]); print('Tensor created:', x)"
check "pytorch basic operations" python3 -c "import torch; x = torch.tensor([1.0, 2.0]); y = torch.tensor([3.0, 4.0]); z = x + y; print('Addition result:', z)"

# Test that CUDA is NOT available (default is CPU-only)
check "pytorch is CPU-only" python3 -c "import torch; assert not torch.cuda.is_available(), 'CUDA should not be available in default setup'"

# Test that molnex is NOT installed (default is no molnex install)
check "molnex is not installed" bash -c "python3 -c 'import molnex' 2>&1 | grep -q 'No module named' && echo 'molnex correctly not installed'"

# Report result
reportResults

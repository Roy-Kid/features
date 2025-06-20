#!/bin/bash

# The test file is used to verify that the feature works as expected.

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Definition specific tests
check "python3 is available" python3 --version
check "pip3 is available" pip3 --version
check "g++ is available" g++ --version
check "git is available" git --version
check "curl is available" curl --version

# Test PyTorch installation (CPU version by default)
check "pytorch is installed" python3 -c "import torch; print('PyTorch version:', torch.__version__)"
check "torchvision is installed" python3 -c "import torchvision; print('torchvision version:', torchvision.__version__)"
check "torchaudio is installed" python3 -c "import torchaudio; print('torchaudio version:', torchaudio.__version__)"

# Test PyTorch functionality
check "pytorch tensor creation" python3 -c "import torch; x = torch.tensor([1.0, 2.0, 3.0]); print('Tensor created:', x)"
check "pytorch basic operations" python3 -c "import torch; x = torch.tensor([1.0, 2.0]); y = torch.tensor([3.0, 4.0]); print('Addition result:', x + y)"

# Report result
reportResults

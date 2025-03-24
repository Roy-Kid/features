#!/bin/sh
set -e

ENABLE_CUDA="${ENABLECUDA:-"false"}"
PYTORCH_CUDA_VERSION="${PYTORCHCUDAVERSION:-""}"
INSTALL_MOLPOT="${INSTALL:-"false"}"

apt update && sudo apt install -y build-essential
g++ --version

echo "Activating feature 'pytorch'"

which pip > /dev/null || (apt update && apt install python3-pip -y -qq)

if [[ "${ENABLE_CUDA}" == "false" ]]; then
    echo "Installing pytorch with ${PYTORCH_CUDA_VERSION} support"
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/${PYTORCH_CUDA_VERSION}
    echo "Pytorch with CUDA support installed!"
else
    echo "Installing pytorch without CUDA support"
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
    echo "Pytorch without CUDA support installed!"
fi

if [[ "${INSTALL_MOLPOT}" == "true" ]]; then
    git clone https://github.com/MolCrafts/molpot.git
    cd molpot
    git checkout dev
    pip install .
fi

echo "pytorch installed! "
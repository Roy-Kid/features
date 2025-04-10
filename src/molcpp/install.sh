#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Load OS release information
. /etc/os-release
release=${UBUNTU_CODENAME}
llvm_version=16

# Install necessary packages and clean up
apt-get update -y && apt-get install -y --no-install-recommends \
    lsb-release \
    software-properties-common \
    gnupg \
    gnupg2 \
    gnupg-agent \
    ca-certificates \
    ninja-build \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Verify ninja installation
ninja --version

# Add Kitware APT repository for the latest CMake
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - > /usr/share/keyrings/kitware-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ ${release} main" > /etc/apt/sources.list.d/kitware.list
if [ -n "${rc}" ]; then
  echo "deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ ${release}-rc main" >> /etc/apt/sources.list.d/kitware.list
fi

# Install CMake and clean up
apt-get update -y && apt-get install -y kitware-archive-keyring cmake && rm -rf /var/lib/apt/lists/*

# Install latest GCC
add-apt-repository universe
apt-get update -y && apt-get install gcc-14 -y
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-14 0
gcc --version

# Install Clang tools
wget -qO- https://apt.llvm.org/llvm.sh | bash -s -- 20
clangd-20 --version
clang++-20 --version
update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-20 0

#
apt-get upgrade

# Install xtensor and related libraries using conda
conda install -c conda-forge xtensor xtensor-blas xtl xsimd

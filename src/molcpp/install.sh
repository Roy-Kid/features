#!/bin/bash

set -e

# Define arguments
base_tag=jammy
llvm_version=16

# Install necessary packages
apt-get install -y --no-install-recommends \
    gnupg2 \
    gnupg-agent \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# install latest cmake
apt-get update -y
apt-get install -y --no-install-recommends \
    software-properties-common \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*
apt-get clean all
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main"
apt-get install kitware-archive-keyring
rm /etc/apt/trusted.gpg.d/kitware.gpg
apt-get update -y
apt-get install -y cmake
cmake --version

# Add LLVM GPG key and repository
curl --fail --silent --show-error --location https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
echo "deb http://apt.llvm.org/$base_tag/ llvm-toolchain-$base_tag-$llvm_version main" >> /etc/apt/sources.list.d/llvm.list

# Update and upgrade system again
apt-get update --fix-missing && apt-get -y upgrade

# Install clang tools
apt-get install -y --no-install-recommends \
    clang-format-${llvm_version} \
    clang-tidy-${llvm_version} \
    && rm -rf /var/lib/apt/lists/*

# Create symbolic links for clang tools
ln -s /usr/bin/clang-format-${llvm_version} /usr/local/bin/clang-format
ln -s /usr/bin/clang-tidy-${llvm_version} /usr/local/bin/clang-tidy

# install xtensor
conda install -c conda-forge xtensor xtensor-blas xtl xsimd
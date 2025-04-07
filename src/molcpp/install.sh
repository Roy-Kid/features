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

# Install clang tools
apt-get install -y clangd

# install xtensor
conda install -c conda-forge xtensor xtensor-blas xtl xsimd
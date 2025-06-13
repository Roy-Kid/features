#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Load OS release information
. /etc/os-release
release=${UBUNTU_CODENAME}

# Install necessary packages and clean up
apt-get update -y && apt-get install -y --no-install-recommends \
    build-essential \
    lsb-release \
    software-properties-common \
    gnupg \
    gnupg2 \
    gnupg-agent \
    ca-certificates \
    ninja-build \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install CMake and clean up
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - > /usr/share/keyrings/kitware-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ ${release} main" > /etc/apt/sources.list.d/kitware.list
if [ -n "${rc}" ]; then
  echo "deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ ${release}-rc main" >> /etc/apt/sources.list.d/kitware.list
fi
apt-get update -y && apt-get install -y kitware-archive-keyring cmake && rm -rf /var/lib/apt/lists/*

# Default GCC 11
if [ -n "${GCC11}" ]; then
  sudo apt-get install clangd-12

fi

# Install latest GCC
# add-apt-repository universe
# apt-get update -y && apt-get install gcc-14 g++-14 -y
# update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-14 100
# update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-14 100
# gcc --version

# Install Clang tools
# wget -qO- https://apt.llvm.org/llvm.sh | bash -s -- 20
# clangd-20 --version
# clang++-20 --version
# update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-20 100
# update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-20 100
# apt-get upgrade

# Install vcpkg
VCPKG_ROOT="${VCPKGROOT:-/usr/local/vcpkg}"
VCPKG_DOWNLOADS="${VCPKGDOWNLOADS:-/usr/local/vcpkg-downloads}"
VCPKG_VERSION="${VCPKGVERSION:-latest}"

# Clone and bootstrap vcpkg
if [ ! -d "$VCPKG_ROOT" ]; then
    echo "[INFO] Cloning vcpkg into $VCPKG_ROOT"
    git clone --depth=1 https://github.com/microsoft/vcpkg "$VCPKG_ROOT"
    "$VCPKG_ROOT/bootstrap-vcpkg.sh"
fi

# Fix permissions if needed
chmod -R g+r+w "$VCPKG_ROOT" "$VCPKG_DOWNLOADS" 2>/dev/null || true
chown -R $(id -u):$(id -g) "$VCPKG_ROOT" "$VCPKG_DOWNLOADS" 2>/dev/null || true

# Set up environment persistently
echo "[INFO] Writing environment setup to /etc/profile.d/vcpkg.sh"
cat <<EOF | tee /etc/profile.d/vcpkg.sh >/dev/null
export VCPKG_ROOT="$VCPKG_ROOT"
export PATH="\$VCPKG_ROOT:\$PATH"
EOF
chmod +x /etc/profile.d/vcpkg.sh

# Also export to current shell for immediate use
export VCPKG_ROOT="$VCPKG_ROOT"
export PATH="$VCPKG_ROOT:$PATH"

# Confirm success
echo "[INFO] vcpkg installed to $VCPKG_ROOT"
vcpkg version || echo "[WARNING] vcpkg not found in PATH"
# End vcpkg installation

if [ -n "${INSTALLXTENSOR}"]; then
  conda install -c conda-forge xtensor xtensor-blas xtl xsimd xtensor-python
fi

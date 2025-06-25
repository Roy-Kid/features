#!/usr/bin/env bash

# molpy Feature Install Script
# This script installs Python packages for molecular science development

set -e

# Function to install packages with conda
install_conda_packages() {
    local packages="$1"
    if [ -n "$packages" ]; then
        echo_info "Installing conda packages: $packages"
        $CONDA_CMD install -y -c conda-forge $packages
    fi
}

# Function to install packages with pip
install_pip_packages() {
    local packages="$1"
    if [ -n "$packages" ]; then
        echo_info "Installing pip packages: $packages"
        pip install --no-cache-dir $packages
    fi
}


# Set up Jupyter Lab extensions if Jupyter is installed
if [ "$INSTALLJUPYTER" = "true" ]; then
    echo_info "Setting up Jupyter Lab..."
    install_pip_packages "jupyterlab ipykernel"
fi

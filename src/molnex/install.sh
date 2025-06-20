#!/bin/bash
set -e

# Parse feature options
ENABLECUDA="${ENABLECUDA:-"false"}"
PYTORCHCUDAVERSION="${PYTORCHCUDAVERSION:-"cu118"}"
INSTALLFROMSOURCE="${INSTALLFROMSOURCE:-"false"}"
INSTALLFROMPYPI="${INSTALLFROMPYPI:-"false"}"
MOLNEXBRANCH="${MOLNEXBRANCH:-"dev"}"
MOLNEXVERSION="${MOLNEXVERSION:-"latest"}"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

echo_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

echo_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo_info "Installing molnex feature..."

# Update package list and install build essentials
echo_info "Installing build dependencies..."
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq build-essential git curl

# Verify compiler installation
g++ --version > /dev/null 2>&1 || {
    echo_error "g++ compiler not found after installation"
    exit 1
}

echo_info "Build tools installed successfully"

# Ensure pip is available
echo_info "Ensuring pip is available..."
if ! command -v pip3 &> /dev/null; then
    apt-get install -y -qq python3-pip
fi

# Verify Python and pip
python3 --version
pip3 --version

# Install PyTorch
echo_info "Installing PyTorch..."
if [ "$ENABLECUDA" = "true" ]; then
    echo_info "Installing PyTorch with CUDA ($PYTORCHCUDAVERSION) support"
    # Validate CUDA version
    case "$PYTORCHCUDAVERSION" in
        cu118|cu121|cu124)
            pip3 install --no-cache-dir torch torchvision torchaudio --index-url "https://download.pytorch.org/whl/${PYTORCHCUDAVERSION}"
            ;;
        *)
            echo_error "Unsupported CUDA version: $PYTORCHCUDAVERSION"
            echo_info "Supported versions: cu118, cu121, cu124"
            echo_info "Falling back to CPU version..."
            pip3 install --no-cache-dir torch torchvision torchaudio --index-url "https://download.pytorch.org/whl/cpu"
            ;;
    esac
    echo_info "PyTorch with CUDA support installed successfully!"
else
    echo_info "Installing PyTorch with CPU-only support"
    pip3 install --no-cache-dir torch torchvision torchaudio --index-url "https://download.pytorch.org/whl/cpu"
    echo_info "PyTorch with CPU support installed successfully!"
fi

# Install molnex if requested
if [ "$INSTALLFROMSOURCE" = "true" ] && [ "$INSTALLFROMPYPI" = "true" ]; then
    echo_error "Cannot install from both source and PyPI simultaneously. Please choose one option."
    exit 1
fi

if [ "$INSTALLFROMSOURCE" = "true" ]; then
    echo_info "Installing molnex from source..."
    
    # Create temporary directory for clone
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    # Clone and install molnex
    echo_info "Cloning molnex from branch: $MOLNEXBRANCH"
    git clone --depth=1 --branch="$MOLNEXBRANCH" https://github.com/MolCrafts/molnex.git || {
        echo_warn "Failed to clone branch $MOLNEXBRANCH, trying main branch..."
        git clone --depth=1 https://github.com/MolCrafts/molnex.git
        cd molnex
        git checkout "$MOLNEXBRANCH" 2>/dev/null || {
            echo_warn "Branch $MOLNEXBRANCH not found, using default branch"
        }
    }
    
    if [ ! -d "molnex" ]; then
        cd molnex
    fi
    
    # Install molnex
    pip3 install --no-cache-dir .
    
    # Cleanup
    cd /
    rm -rf "$TEMP_DIR"
    
    echo_info "molnex installed successfully from source (branch: $MOLNEXBRANCH)"
fi

if [ "$INSTALLFROMPYPI" = "true" ]; then
    echo_info "Installing molnex from PyPI..."
    
    if [ "$MOLNEXVERSION" = "latest" ]; then
        echo_info "Installing latest version of molnex from PyPI"
        pip3 install --no-cache-dir molnex
    else
        echo_info "Installing molnex version $MOLNEXVERSION from PyPI"
        pip3 install --no-cache-dir "molnex==$MOLNEXVERSION"
    fi
    
    echo_info "molnex installed successfully from PyPI (version: $MOLNEXVERSION)"
fi

# Verify installations
echo_info "Verifying installations..."
python3 -c "import torch; print(f'PyTorch version: {torch.__version__}')"
if [ "$ENABLECUDA" = "true" ]; then
    python3 -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}')"
fi

if [ "$INSTALLFROMSOURCE" = "true" ] || [ "$INSTALLFROMPYPI" = "true" ]; then
    python3 -c "import molnex; print('molnex imported successfully')" 2>/dev/null || echo_warn "molnex import failed"
fi

echo_info "molnex feature installation completed!"
# molnex Feature

A dev container feature for installing PyTorch and molnex with optional CUDA support.

## Usage

```json
{
    "features": {
        "ghcr.io/molcrafts/features/molnex:latest": {
            "enableCuda": true,
            "pytorchCudaVersion": "cu118",
            "install": true,
            "molnexBranch": "dev"
        }
    }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enableCuda` | boolean | `false` | Enable CUDA support for PyTorch installation |
| `pytorchCudaVersion` | string | `cu118` | PyTorch CUDA version (cu118, cu121, cu124) |
| `install` | boolean | `false` | Install molnex from source |
| `molnexBranch` | string | `dev` | Git branch to checkout for molnex installation |

## Dependencies

This feature depends on:
- `ghcr.io/molcrafts/features/utils:latest`
- `ghcr.io/molcrafts/features/miniforge:latest`

## What's Installed

- PyTorch with optional CUDA support
- torchvision
- torchaudio
- molnex (optional)
- Build essentials (gcc, g++, make)
- Git and curl

## VS Code Extensions

The following extensions are automatically installed:
- ms-python.python
- ms-python.black-formatter
- ms-python.isort
- ms-toolsai.tensorboard
- ms-python.pylint

## Examples

### Basic PyTorch Installation (CPU only)

```json
{
    "features": {
        "ghcr.io/molcrafts/features/molnex:latest": {}
    }
}
```

### PyTorch with CUDA Support

```json
{
    "features": {
        "ghcr.io/molcrafts/features/molnex:latest": {
            "enableCuda": true,
            "pytorchCudaVersion": "cu118"
        }
    }
}
```

### Full Installation with molnex

```json
{
    "features": {
        "ghcr.io/molcrafts/features/molnex:latest": {
            "enableCuda": true,
            "pytorchCudaVersion": "cu118",
            "install": true,
            "molnexBranch": "main"
        }
    }
}
```

## Supported CUDA Versions

- cu118 (CUDA 11.8)
- cu121 (CUDA 12.1)  
- cu124 (CUDA 12.4)

## Notes

- CUDA support requires compatible NVIDIA GPU and drivers on the host system
- molnex installation requires the repository to be accessible
- Build tools are automatically installed as dependencies

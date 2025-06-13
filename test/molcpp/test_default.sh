#!/bin/zsh

set -e

# Optional: Import test library
source dev-container-features-test-lib

# test if default shell is zsh
source /etc/profile.d/vcpkg.sh
check "test_zsh" echo $SHELL | grep -q zsh
check "test_cmake" cmake --version
check "test_ninja" ninja --version
check "test_gcc" gcc --version
check "test_g++" g++ --version
check "test_cc" cc --version
check "test_c++" c++ --version
check "test_vcpkg" vcpkg version

# Report result
reportResults
#!/bin/bash

# CMake Build Script for C++ Template
# Usage: ./build.sh [debug|release|clean|run|help]

set -e  # Exit on any error

PROJECT_NAME="CppTemplate"
BUILD_DIR="build"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS_NAME="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS_NAME="macos"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    OS_NAME="windows"
    PROJECT_NAME="${PROJECT_NAME}.exe"
else
    OS_NAME="unknown"
fi

print_usage() {
    echo -e "${BLUE}Usage: $0 [command]${NC}"
    echo ""
    echo "Commands:"
    echo "  debug     Build in debug mode (default)"
    echo "  release   Build in release mode"
    echo "  clean     Clean build directory"
    echo "  run       Build and run the executable"
    echo "  help      Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 debug"
    echo "  $0 release"
    echo "  $0 run"
}

clean_build() {
    echo -e "${YELLOW}Cleaning build directory...${NC}"
    if [ -d "$BUILD_DIR" ]; then
        rm -rf "$BUILD_DIR"
        echo -e "${GREEN}Build directory cleaned.${NC}"
    else
        echo -e "${YELLOW}Build directory doesn't exist.${NC}"
    fi
}

build_project() {
    local build_type=$1
    
    echo -e "${BLUE}Building project in ${build_type} mode...${NC}"
    
    # Create build directory if it doesn't exist
    mkdir -p "$BUILD_DIR"
    cd "$BUILD_DIR"
    
    # Configure
    echo -e "${YELLOW}Configuring...${NC}"
    cmake -DCMAKE_BUILD_TYPE="$build_type" ..
    
    # Build
    echo -e "${YELLOW}Building...${NC}"
    cmake --build . --config "$build_type"
    
    cd ..
    echo -e "${GREEN}Build completed successfully!${NC}"
    echo -e "${BLUE}Executable location: ${BUILD_DIR}/bin/${build_type}/${OS_NAME}/${PROJECT_NAME}${NC}"
}

run_executable() {
    local build_type="Debug"  # Default to debug for run
    
    # Check if executable exists
    local exe_path="${BUILD_DIR}/bin/${build_type}/${OS_NAME}/${PROJECT_NAME}"
    
    if [ ! -f "$exe_path" ]; then
        echo -e "${YELLOW}Executable not found. Building first...${NC}"
        build_project "$build_type"
    fi
    
    echo -e "${BLUE}Running executable...${NC}"
    echo -e "${GREEN}Output:${NC}"
    echo "----------------------------------------"
    "$exe_path"
    echo "----------------------------------------"
}

# Main script logic
case "${1:-debug}" in
    "debug")
        build_project "Debug"
        ;;
    "release")
        build_project "Release"
        ;;
    "clean")
        clean_build
        ;;
    "run")
        run_executable
        ;;
    "help"|"-h"|"--help")
        print_usage
        ;;
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        echo ""
        print_usage
        exit 1
        ;;
esac
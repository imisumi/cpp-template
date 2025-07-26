# Simple C++ CMakeLists.txt Template - Explicit Files
cmake_minimum_required(VERSION 3.16)

project(CppTemplate VERSION 1.0.0)

# Set C++ standard
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Project options
option(USE_PCH "Use precompiled headers" ON)

# Compiler warnings
if(MSVC)
    add_compile_options(/W4)
else()
    add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# Find packages BEFORE defining targets
# find_package(fmt REQUIRED)
# find_package(spdlog REQUIRED)

# Recursively find all source files in src/
file(GLOB_RECURSE SOURCES
    src/*.cpp
)

# Recursively find all header files in src/ (for IDE support)
file(GLOB_RECURSE HEADERS
    src/*.h
)

# Define targets AFTER finding packages
add_executable(${PROJECT_NAME} ${SOURCES} ${HEADERS})

# Configure target properties AFTER defining target
target_include_directories(${PROJECT_NAME} PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src
)

# Precompiled headers (if enabled and pch.hpp exists)
if(USE_PCH AND EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/src/pch.h)
    target_precompile_headers(${PROJECT_NAME} PRIVATE src/pch.h)
    message(STATUS "Using precompiled headers: src/pch.hpp")
elseif(USE_PCH)
    message(STATUS "PCH enabled but src/pch.hpp not found - skipping PCH")
endif()

# Link libraries AFTER target configuration
# target_link_libraries(${PROJECT_NAME} PRIVATE
#     fmt::fmt
#     spdlog::spdlog
# )

# Determine OS string
if(WIN32)
    set(OS_NAME "windows")
elseif(APPLE)
    set(OS_NAME "macos")
elseif(UNIX)
    set(OS_NAME "linux")
else()
    set(OS_NAME "unknown")
endif()

# Set output directory: build/bin/build-type/os/
set_target_properties(${PROJECT_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/bin/${CMAKE_BUILD_TYPE}/${OS_NAME}
    # Set working directory for IDEs (Visual Studio, etc.)
    VS_DEBUGGER_WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)

# Custom target to run the executable from project root
add_custom_target(run
    COMMAND ${CMAKE_CURRENT_BINARY_DIR}/bin/${CMAKE_BUILD_TYPE}/${OS_NAME}/${PROJECT_NAME}
    DEPENDS ${PROJECT_NAME}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Running ${PROJECT_NAME} from project root"
)
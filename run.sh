#!/bin/bash

BUILD_DIR="build_run"
INSTALL_DIR="install"
EXECUTABLE_PATH="$BUILD_DIR/src/journaling" # Adjust this if the path changes

# Step 1: Setup the build directory (only if not already set up)
if [ ! -d "$BUILD_DIR" ]; then
    echo "Setting up Meson build directory..."
    meson setup "$BUILD_DIR" || { echo "Meson setup failed."; exit 1; }
fi

# Step 2: Build the project
echo "Building the project..."
meson compile -C "$BUILD_DIR" || { echo "Build failed."; exit 1; }

# Step 3: Run the application
if [ -x "$EXECUTABLE_PATH" ]; then
    echo "Running the application: $EXECUTABLE_PATH"
    "$EXECUTABLE_PATH" || { echo "Application failed to run."; exit 1; }
else
    echo "Executable not found or not executable at: $EXECUTABLE_PATH"
    exit 1
fi

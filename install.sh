#!/bin/bash

# Define colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running with sudo
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Please run as root or using sudo${NC}"
  exit 1
fi

# Define paths
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SRC_DIR="$SCRIPT_DIR/src"
APP_NAME="VLCURLHandler.app"
INSTALL_DIR="/Applications/$APP_NAME"

echo -e "${YELLOW}Installing VLC URL Handler...${NC}"

# Check if AppleScript command line tool is available
if ! command -v osacompile &> /dev/null; then
    echo -e "${RED}Error: osacompile not found. Please ensure Xcode or Xcode Command Line Tools are installed.${NC}"
    exit 1
fi

# Compile AppleScript
echo "Compiling AppleScript..."
osacompile -o "$INSTALL_DIR" "$SRC_DIR/VLCURLHandler.applescript"

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to compile AppleScript.${NC}"
    exit 1
fi

# Copy bash script
echo "Copying bash script..."
mkdir -p "$INSTALL_DIR/Contents/Resources"
cp "$SRC_DIR/vlc_handler.sh" "$INSTALL_DIR/Contents/Resources/"

# Make bash script executable
echo "Making bash script executable..."
chmod +x "$INSTALL_DIR/Contents/Resources/vlc_handler.sh"

# Update Info.plist to register URL scheme
echo "Registering URL scheme..."
PLIST="$INSTALL_DIR/Contents/Info.plist"

/usr/libexec/PlistBuddy -c "Delete :CFBundleURLTypes array" "$PLIST" 2>/dev/null
/usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes array" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes:0 dict" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes:0:CFBundleURLName string 'Custom Scheme'" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes:0:CFBundleURLSchemes array" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes:0:CFBundleURLSchemes:0 string 'vlc'" "$PLIST"

/usr/libexec/PlistBuddy -c "Delete :LSApplicationQueriesSchemes array" "$PLIST" 2>/dev/null
/usr/libexec/PlistBuddy -c "Add :LSApplicationQueriesSchemes array" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :LSApplicationQueriesSchemes:0 string 'vlc'" "$PLIST"

# Set proper permissions
echo "Setting permissions..."
chown -R root:wheel "$INSTALL_DIR"
chmod -R 755 "$INSTALL_DIR"

echo -e "${GREEN}Installation complete!${NC}"
echo -e "VLC URL Handler has been installed to $INSTALL_DIR"
echo -e "${YELLOW}Note: You may need to restart your computer or log out and back in for the URL scheme to be recognized.${NC}"
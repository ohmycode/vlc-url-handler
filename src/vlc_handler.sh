#!/bin/bash

# Default values
DEFAULT_BASE_PATH="~/Documents"
DEFAULT_VLC_PATH="/Applications/VLC.app/Contents/MacOS/VLC"

# Load configuration if exists
if [ -f ~/.vlc-url-handler ]; then
    source ~/.vlc-url-handler
fi

# Use default values if not set in config
BASE_PATH=${BASE_PATH:-$DEFAULT_BASE_PATH}
VLC_PATH=${VLC_PATH:-$DEFAULT_VLC_PATH}

# Function to urldecode the input
urldecode() {
    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}
# Function to remove escaped spaces
remove_escaped_spaces() {
    echo "$1" | sed 's/\\ / /g'
}

# Parse the input
IFS='?' read -r file_path params <<< "$1"

# URL decode the file path
file_path=$(urldecode "$file_path")

# Remove escaped spaces
file_path=$(remove_escaped_spaces "$file_path")

# Check if the path is absolute
if [[ "$file_path" != /* ]]; then
    file_path="$BASE_PATH/$file_path"
fi

# Parse parameters
start_time=""
end_time=""
playback_speed=""
loop_value=""

if [ -n "$params" ]; then
    IFS='&' read -ra PARAMS <<< "$params"
    for param in "${PARAMS[@]}"; do
        IFS='=' read -r key value <<< "$param"
        value=$(urldecode "$value")
        case "$key" in
            start) start_time=$value ;;
            stop) end_time=$value ;;
            speed) playback_speed=$value ;;
            loop) loop_value=$value ;;
        esac
    done
fi

# Construct the VLC command
vlc_command=("$VLC_PATH")

# Add parameters if they exist
[ -n "$start_time" ] && vlc_command+=("--start-time=$start_time")
[ -n "$end_time" ] && vlc_command+=("--stop-time=$end_time")
[ -n "$playback_speed" ] && vlc_command+=("--rate=$playback_speed")
[ "$loop_value" = "true" ] && vlc_command+=("--loop")

# Add the file path
vlc_command+=("$file_path")

# Echo the command (will be captured by AppleScript)
printf '%q ' "${vlc_command[@]}"
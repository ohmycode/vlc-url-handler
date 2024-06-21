# VLC URL Handler for macOS

This project provides a custom URL scheme handler for VLC on macOS, allowing you to open VLC with specific local files and parameters directly from web links or other applications.  
  
Example: `vlc://path/to/video.mp4?start=30&stop=60&loop=true` 

## Motivation

As a guitarist, I often need to quickly access specific sections of music videos or loop backing tracks for practice. This tool streamlines that process, allowing me to create clickable links in my Obsidian (or simple HTML) documents that open VLC with precise settings for each song or practice section. It transforms my practice routine, making it more efficient and organized.

## Features

- Open VLC with a specific file using a custom URL scheme
- Set start and stop times for video playback
- Control playback speed
- Enable looping

## Requirements

- macOS 10.14 or later
- VLC media player
- Xcode Command Line Tools (for building from source)

## Installation

Choose one of the following installation methods:

### 1. Download Pre-built Application

1. Go to the [Releases](https://github.com/yourusername/vlc-url-handler/releases) page.
2. Download the latest `VLCURLHandler.app.zip` file.
3. Unzip the file and move `VLCURLHandler.app` to your Applications folder.

### 2. Use the Install Script

1. Clone this repository:
```bash
git clone https://github.com/ohmycode/vlc-url-handler.git
```

2. Navigate to the project directory:
```bash
cd vlc-url-handler
```
3. Run the install script with sudo:

```bash
sudo ./install.sh
```
4. Follow any on-screen prompts.
5. Restart your computer or log out and back in for the changes to take effect.

### 3. Build from Source

1. Clone this repository:
```bash
git clone https://github.com/yourusername/vlc-url-handler.git
```
2. Open `src/VLCURLHandler.applescript` in AppleScript Editor.

3. Export as an application named VLCURLHandler.app (File > Export > File Format: Application).

4. Right-click on VLCURLHandler.app, select "Show Package Contents", and navigate to Contents/Resources/.

5. Copy `src/vlc_handler.sh` into the Resources folder.

6. Make sure `vlc_handler.sh` is executable:

7. In order to register the URL Scheme you need to add the following lines to the Info.plist of the VLCURLHandler.app, inside of the <dict></dict> tag.
```xml
<key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleURLName</key>
            <string>Custom Scheme</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>vlc</string>
            </array>
        </dict>
    </array>
    <key>LSApplicationQueriesSchemes</key>
    <array>
        <string>vlc</string>
    </array>
``` 
8. Restart or run following command to apply the new url scheme
```bash
 /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -f /Applications/VLCURLHandler.ap
```

## Usage

Use URLs in the following format:

```html
vlc://path/to/video.mp4?start=30&stop=60&speed=1.5&loop=true
```

Parameters:
- `start`: Start time in seconds
- `stop`: Stop time in seconds
- `speed`: Playback speed (e.g., 1.5 for 1.5x speed)
- `loop`: Set to 'true' to loop the video

Example:
```
<a href="vlc://Movies/MyVideo.mp4?start=30&stop=60&speed=1.5&loop=true">Play Video in VLC</a>
```

## Configuration

You can customize the behavior of the VLC URL Handler by creating a configuration file at `~/.vlc-url-handler`. This file allows you to set the following options:

- `BASE_PATH`: The base path for relative URLs (default: "/x/Personal/guitar")
- `VLC_PATH`: The path to the VLC executable (default: "/Applications/VLC.app/Contents/MacOS/VLC")

Example `~/.vlc-url-handler` file:

```bash
BASE_PATH="/Users/yourUsername/Videos"
VLC_PATH="/Applications/VLC.app/Contents/MacOS/VLC"
```

## Troubleshooting

 - If the URL scheme doesn't work after installation, try restarting your computer or logging out and back in.
 - Ensure that VLC is installed in the standard Applications folder.
 - Check Console.app for any error messages related to VLCURLHandler.

## Contributing
Feedback and contributions are welcome! Please feel free to submit a Pull Request.

## License
This project is licensed under the MIT License - see the LICENSE file for details.
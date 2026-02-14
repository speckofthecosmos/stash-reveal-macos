#!/bin/bash

# Stash Reveal App Compiler
# This script compiles the AppleScript into an Application and injects the Info.plist

APP_NAME="StashReveal.app"
SCRIPT_SRC="StashReveal.applescript"

echo "🔨 Compiling $APP_NAME..."

# 1. Compile AppleScript to Application Bundle
osacompile -o "$APP_NAME" "$SCRIPT_SRC"

if [ $? -ne 0 ]; then
    echo "❌ Compilation failed."
    exit 1
fi

echo "✅ Compiled successfully."

# 2. Inject Info.plist URL Scheme
PLIST_PATH="$APP_NAME/Contents/Info.plist"

# Check if file exists
if [ ! -f "$PLIST_PATH" ]; then
    echo "❌ Error: Info.plist not found at $PLIST_PATH"
    exit 1
fi

echo "🔧 Injecting URL Protocol (stashreveal://)..."

# Using plutil to insert the array safely
# This is cleaner than sed/xml manipulation
plutil -insert CFBundleURLTypes -xml '
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>Stash Reveal Protocol</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>stashreveal</string>
        </array>
    </dict>
</array>' "$PLIST_PATH"

echo "✅ Info.plist updated."

echo "🚀 Done! Move $APP_NAME to your Applications folder to activate the protocol."
echo "   Don't forget to open the App once to verify permissions."
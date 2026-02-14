# Stash Reveal in Finder (macOS)

A lightweight workflow for [Stash](https://github.com/stashapp/stash) users on macOS to **reveal files in Finder** directly from the web interface.

This is particularly useful if your Stash server is remote (NAS/Docker) but you have the storage mounted locally via SMB/NFS on your Mac.

![Screenshot](https://via.placeholder.com/600x150?text=Reveal+Button+Example)

## Features

*   **Native Finder Integration:** Clicks "Reveal" and the file is highlighted in Finder.
*   **Path Mapping:** Automatically translates remote server paths (e.g., `/data/...`) to local mount paths (e.g., `/Volumes/Media/...`).
*   **Lightweight:** No heavy apps or Python backends required. Just a tiny AppleScript helper and a Userscript.
*   **Safe:** Uses a custom URL protocol (`stashreveal://`) so it works from any browser (Chrome, Safari, Firefox).

## Installation

### 1. Compile the Helper App

Since this requires an AppleScript application to handle the custom URL protocol, you need to "build" it on your Mac. I've included a script to do this automatically.

1.  Clone this repo or download the files.
2.  Open `StashReveal.applescript` in a text editor.
3.  **Edit the Configuration Variables** at the top:
    ```applescript
    set remote_path_prefix to "/data" -- The path Stash sees
    set local_mount_prefix to "/Volumes/Media" -- The path on your Mac
    ```
4.  Run the build script in Terminal:
    ```bash
    ./build.sh
    ```
5.  This creates `StashReveal.app`.
6.  **Move** `StashReveal.app` to your `/Applications` folder.
7.  **Run it once** (double-click) to register the protocol. It might do nothing or show an error, that's fine.

### 2. Install the Userscript

1.  Install the **Tampermonkey** extension for your browser.
2.  Create a new script.
3.  Copy the content of `StashReveal.user.js`.
4.  Paste it into Tampermonkey.
5.  Update the `@match` URL to point to your Stash instance (e.g., `http://192.168.1.100:9999/*`).
6.  Save.

## Usage

1.  Refresh your Stash page.
2.  Navigate to any Scene or file.
3.  Look for the **📂 Reveal** button next to the file path.
4.  Click it -> Finder opens with the file selected!

## Troubleshooting

*   **"There is no application set to open the URL stashreveal://..."**: 
    *   Move the App out of Applications and back in to force macOS to re-scan the `Info.plist`.
*   **"Path does not match remote prefix"**:
    *   Check your `remote_path_prefix` in the AppleScript.
*   **Automation Permission Denied**:
    *   Go to **System Settings > Privacy & Security > Automation**. Ensure `StashReveal` is checked under "Finder".

## License

MIT License. Free to use and modify.
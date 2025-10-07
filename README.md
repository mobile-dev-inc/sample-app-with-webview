# SimpleWebViewApp

A simple iOS app that presents a modal SFSafariViewController (WebView) with a local HTML login page.

**Purpose**: This project is designed for testing Maestro's ability to read contents in webviews within iOS applications.

## How it Works

1. The main `ViewController` displays a button labeled "Open Login Page"
2. When tapped, it loads the local `login.html` file
3. The HTML file is presented in a modal `SFSafariViewController`
4. The login page contains email and password fields with basic form validation
5. Users can dismiss the modal by tapping "Done" in the Safari view controller

## Running the App

1. Open `SimpleWebViewApp.xcodeproj` in Xcode
2. Select a simulator or device
3. Build and run the project (⌘+R)

## Notes

- The HTML file is served via a local HTTP server on port 8080 (SFSafariViewController requires HTTP/HTTPS URLs)
- The login form includes basic JavaScript validation for demonstration purposes
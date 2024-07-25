Certainly! Below is a `README.md` file for your `LogManager` Swift package. This file includes instructions on how to use the package, integrate it into a project, and provides an overview of its features.

### README.md

```markdown
# LogManager

LogManager is a Swift package that provides an easy-to-use logging system. It allows you to create log files, manage log retention, zip log files, and present a share sheet to share the zipped logs. The logs include a timestamp with date, time, and region for better context.

## Features

- Log messages with timestamps and custom topics.
- Rotate logs to keep only the last N days of logs (configurable).
- Zip log files for easy sharing.
- Present a share sheet to share the zipped logs.

## Requirements

- iOS 13.0+
- Swift 5.3+

## Installation

### Swift Package Manager

You can add LogManager to your project using Swift Package Manager.

1. **File > Swift Packages > Add Package Dependency...**
2. Enter the repository URL: `https://github.com/prabhatk/LogManager.git`
3. Follow the prompts to add the package to your project.

Alternatively, you can add it directly to your `Package.swift` file:

```swift
// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "YourApp",
    dependencies: [
        .package(url: "https://github.com/your-username/LogManager.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "YourApp",
            dependencies: ["LogManager"]),
    ]
)
```

## Usage

### Import LogManager

```swift
import LogManager
```

### Logging Messages

```swift
LogManager.shared.log(topic: "AppLifecycle", message: "App started")
LogManager.shared.log(topic: "UserEvent", message: "User logged in")
```

### Configuring Log Retention

Set the maximum number of days to keep log files:

```swift
LogManager.shared.setMaxDays(7)
```

### Zipping Log Files

```swift
if let zipFileURL = LogManager.shared.zipLogs() {
    print("Zipped logs are available at: \(zipFileURL)")
}
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
```

### Explanation

- **Title and Features:** Provides an overview of the package and its key features.
- **Requirements:** Specifies the platform and Swift version requirements.
- **Installation:** Instructions for adding the package using Swift Package Manager.
- **Usage:** Demonstrates how to import, log messages, configure log retention and zip log files.
- **License:** Mentions the license for the project.

You can customize the repository URL and other details as needed. This `README.md` file will help users understand how to use your `LogManager` package effectively.

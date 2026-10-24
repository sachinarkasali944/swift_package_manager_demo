# 📦 Swift Package Manager (SPM) Deep Dive Tutorial & Demo

> **Checkout status:** The committed snapshot includes `SPM_Demo.xcworkspace` and the demo app, but not the local `MyUtilityPackage` or `MyLibrary` source folders described below. Those sections are tutorial instructions; create the packages or restore them locally before expecting the full workspace example to build. Paths from the original author's machine have been removed from this README.

Welcome to the **Swift Package Manager (SPM) Tutorial**! This repository serves as both a step-by-step learning guide and a working demo project. 

Here, we demonstrate how to build a custom Swift Package called **`UtilityKit`**, organize it with an **Xcode Workspace**, and integrate it into a SwiftUI App (**`SPM_Demo`**).

---

## 📖 Table of Contents
1. [What is Swift Package Manager (SPM)?](#1-what-is-swift-package-manager-spm)
2. [Structure of a Swift Package](#2-structure-of-a-swift-package)
3. [Step 1: Creating a Swift Package](#3-step-1-creating-a-swift-package)
4. [Step 2: Defining `Package.swift`](#4-step-2-defining-packageswift)
5. [Step 3: Creating Public Code & Components](#5-step-3-creating-public-code--components)
6. [Step 4: Writing & Running Package Tests](#6-step-4-writing--running-package-tests)
7. [Step 5: Local Integration (Xcode Workspace)](#7-step-5-local-integration-xcode-workspace)
8. [Step 6: Importing & Using the Package in SwiftUI](#8-step-6-importing--using-the-package-in-swiftui)
9. [Publishing Your Package (Remote SPM)](#publishing-your-package-remote-spm)

---

## 1. What is Swift Package Manager (SPM)?

**Swift Package Manager (SPM)** is Apple's first-party tool for managing the distribution of Swift code. It is integrated directly into the Swift build system and Xcode, making it the modern standard for dependency management in iOS, macOS, watchOS, tvOS, and Linux development.

### SPM vs. CocoaPods vs. Carthage
| Feature | Swift Package Manager (SPM) | CocoaPods | Carthage |
| :--- | :--- | :--- | :--- |
| **First-Party Support** | ✅ Yes (Apple) | ❌ No (Community) | ❌ No (Community) |
| **Xcode Integration** | ✅ Native (No extra configuration) | ❌ Requires `.xcworkspace` generation | ❌ Manual framework linking |
| **Configuration File** | `Package.swift` (Swift code) | `Podfile` (Ruby-based DSL) | `Cartfile` (Custom DSL) |
| **Build overhead** | ✅ Fast, incremental builds | ❌ Rebuilds workspace targets frequently | ✅ Pre-compiled frameworks (fast but rigid) |

---

## 2. Structure of a Swift Package

A standard Swift Package is organized as follows:

```text
MyUtilityPackage/
├── Package.swift           # Package configuration (metadata, products, dependencies, targets)
├── README.md               # Package documentation
├── Sources/                # Source code directory
│   └── UtilityKit/         # Target module directory (holds the Swift source files)
│       ├── GreetingFormatter.swift
│       └── GradientBadge.swift
└── Tests/                  # Unit tests directory
    └── UtilityKitTests/    # Test target directory
        └── UtilityKitTests.swift
```

---

## 3. Step 1: Creating a Swift Package

You can create a Swift Package directly from the command line:

1. Create a new directory for your package:
   ```bash
   mkdir MyUtilityPackage
   cd MyUtilityPackage
   ```
2. Initialize a new package with a library template:
   ```bash
   swift package init --type library
   ```
   *Note: Other templates include `--type executable` for CLI apps and `--type system-module` for C-library wrappers.*

---

## 4. Step 2: Defining `Package.swift`

The `Package.swift` file is the heart of your package. It is written in Swift and configures your package's targets, products, and dependencies.

Here is the `Package.swift` we configured for `UtilityKit` (`Package.swift`):

```swift
// swift-tools-version: 6.3
import PackageDescription

let package = Package(
    name: "UtilityKit",
    platforms: [
        .iOS(.v15),       // Minimum supported platforms
        .macOS(.v12)
    ],
    products: [
        // Defines libraries/executables produced by this package (visible to other projects)
        .library(
            name: "UtilityKit",
            targets: ["UtilityKit"]
        ),
    ],
    dependencies: [
        // Put external package dependencies here (e.g., Alamofire, Firebase)
    ],
    targets: [
        // Building block of package. Defines a module or test suite.
        .target(
            name: "UtilityKit",
            dependencies: []
        ),
        .testTarget(
            name: "UtilityKitTests",
            dependencies: ["UtilityKit"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
```

---

## 5. Step 3: Creating Public Code & Components

> [!IMPORTANT]
> By default, Swift classes, structs, functions, and initializers have `internal` access control. If you do not explicitly declare them as **`public`** or **`open`**, they will **NOT** be visible when the package is imported into your app.

### 1. Reusable Logic Target (`GreetingFormatter.swift`)
This utility formats greeting strings depending on the time of day:

```swift
import Foundation

public struct GreetingFormatter {
    // Explicit public initializer is REQUIRED for instantiation outside the module
    public init() {}
    
    public func greeting(for name: String) -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12:  return "Good morning, \(name)!"
        case 12..<17: return "Good afternoon, \(name)!"
        case 17..<22: return "Good evening, \(name)!"
        default:      return "Good night, \(name)!"
        }
    }
}
```

### 2. Reusable UI Target (`GradientBadge.swift`)
This SwiftUI view demonstrates how packages can export visual UI components:

```swift
import SwiftUI

public struct GradientBadge: View {
    public let text: String
    public let colors: [Color]
    
    public init(text: String, colors: [Color] = [.purple, .indigo]) {
        self.text = text
        self.colors = colors
    }
    
    public var body: some View {
        Text(text)
            .font(.system(.subheadline, design: .rounded))
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
            .clipShape(Capsule())
    }
}
```

---

## 6. Step 4: Writing & Running Package Tests

Testing packages is simple. Create files in the `Tests/` target directory and import the module using `@testable import <ModuleName>`.

We implemented the unit tests inside `UtilityKitTests.swift`.

### Running Tests from Command Line
In the `MyUtilityPackage` folder, run:
```bash
swift test
```

### Running Tests in Xcode
Open the package folder or workspace in Xcode and press `Cmd + U` to execute the package tests.

---

## 7. Step 5: Local Integration (Xcode Workspace)

To develop your package locally alongside your application, use an **Xcode Workspace**.

We created a workspace called `SPM_Demo.xcworkspace` containing the following structure:
- `SPM_Demo/SPM_Demo.xcodeproj` (The Application project)
- `MyUtilityPackage/` (The local Swift Package folder)

### 🔗 How to Link the Local Package:
1. Open `SPM_Demo.xcworkspace` in Xcode.
2. In the Navigator pane, you will see both the `SPM_Demo` project and the `MyUtilityPackage` folder.
3. Select the `SPM_Demo` project file at the top of the sidebar.
4. Select the **`SPM_Demo` Target** and navigate to the **General** tab.
5. Scroll down to **Frameworks, Libraries, and Embedded Content**.
6. Click the **`+`** button.
7. Under `Workspace` > `UtilityKit`, select **`UtilityKit`** and click **Add**.

*Now Xcode knows to link your local package library to your main app executable!*

---

## 8. Step 6: Importing & Using the Package in SwiftUI

Once linked, you can use the package like any other dependency in your app code.

We updated `ContentView.swift`:

```swift
import SwiftUI
import UtilityKit // Import your local SPM package!

struct ContentView: View {
    @State private var name: String = "Swift Developer"
    private let formatter = GreetingFormatter() // Instantiated from Package
    
    var body: some View {
        VStack(spacing: 24) {
            Text(formatter.greeting(for: name)) // Calling Package method
                .font(.title2)
                
            HStack {
                // Using Package SwiftUI Views
                GradientBadge(text: "Local Package", colors: [.blue, .teal])
                GradientBadge(text: "SwiftUI View", colors: [.purple, .pink])
            }
        }
    }
}
```

---

## 9. Working with Multiple Packages in a Workspace

As your app grows, you can manage multiple local packages under the same Xcode Workspace. We have added the **`MyLibrary`** package to the workspace alongside **`UtilityKit`**.

### Workspace Layout

```text
swift_package_manager_demo/
├── SPM_Demo.xcworkspace        # Workspace file referencing SPM_Demo, MyUtilityPackage, and MyLibrary
├── SPM_Demo/                   # Main application project
├── MyUtilityPackage/           # Local Package 1: UtilityKit
└── ../swiftUIcomponents/MyLibrary/ # Local Package 2: MyLibrary (referenced relatively)
```

### Linking the new Package (MyLibrary)
1. Open the Workspace.
2. Select `SPM_Demo` Project -> `SPM_Demo` Target -> **General** > **Frameworks, Libraries, and Embedded Content**.
3. Click **`+`** and choose **`MyLibrary`** from the Workspace products.

---

## Publishing Your Package (Remote SPM)

When you are ready to share your package with others or use it in other apps remotely:

1. **Commit and push** the package folder (`MyUtilityPackage`) to a git repository (e.g., GitHub):
   ```bash
   git init
   git add .
   git commit -m "Initial commit of UtilityKit package"
   git remote add origin https://github.com/your-username/UtilityKit.git
   git push -u origin main
   ```
2. **Tag your release** with semantic versioning:
   ```bash
   git tag 1.0.0
   git push origin 1.0.0
   ```
3. **Import remotely in Xcode**:
   - Open your project.
   - Go to **File** > **Add Packages...**
   - Paste the repository URL: `https://github.com/your-username/UtilityKit.git`.
   - Specify dependency rules (e.g., `Up to Next Major Version: 1.0.0`).

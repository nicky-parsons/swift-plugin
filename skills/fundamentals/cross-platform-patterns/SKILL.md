---
name: cross-platform-patterns
description: Build multi-platform Apple applications targeting iOS, iPadOS, macOS, watchOS, tvOS, and visionOS. Use conditional compilation, platform abstractions, and adaptive UI patterns to share code across platforms while respecting platform-specific differences and Human Interface Guidelines.
version: 1.0.0
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# Cross-Platform Patterns

## What This Skill Does

Provides patterns and techniques for building applications that run across multiple Apple platforms (iOS, iPadOS, macOS, watchOS, tvOS, visionOS) while maintaining native experiences. Covers conditional compilation, platform abstraction, SwiftUI adaptation, and platform-specific considerations.

## When to Activate

- Building apps that target multiple Apple platforms
- Adapting existing iOS app for macOS or other platforms
- Handling platform-specific UI or behavior differences
- Creating shared frameworks or Swift packages
- Implementing Catalyst apps (iPad apps on macOS)
- Designing adaptive user interfaces

## Core Concepts

### Platform Availability

Each Apple platform has distinct characteristics:

**iOS/iPadOS**: Touch-based, mobile constraints (battery, memory), multitasking (Split View, Slide Over), widgets

**macOS**: Mouse/keyboard/trackpad input, multiple windows, menu bars, full file system access, bottom-left coordinate origin

**watchOS**: Severely constrained (CPU, memory, battery), SwiftUI only, Digital Crown navigation, complications, minimal background execution

**tvOS**: Focus-based navigation (not touch), Siri Remote input, 10-foot UI design, no local storage, no WebViews

**visionOS**: Spatial computing, eye tracking + hand gestures, RealityKit for 3D, Windows/Volumes/Spaces

### Conditional Compilation

Swift provides platform-specific compilation directives:

```swift
#if os(iOS)
// iOS-specific code
#elseif os(macOS)
// macOS-specific code
#elseif os(watchOS)
// watchOS-specific code
#elseif os(tvOS)
// tvOS-specific code
#elseif os(visionOS)
// visionOS-specific code
#endif
```

Additional conditions:
- `targetEnvironment(simulator)` - Running in simulator
- `canImport(Module)` - Module availability
- `swift(>=5.9)` - Swift version checks

### Protocol-Oriented Abstraction

Use protocols to abstract platform differences rather than scattering `#if` throughout code:

```swift
protocol PlatformColor {
    static var primary: Self { get }
    static var secondary: Self { get }
}

#if os(iOS)
import UIKit
extension UIColor: PlatformColor {
    static var primary: UIColor { .systemBlue }
    static var secondary: UIColor { .systemGray }
}
typealias Color = UIColor
#elseif os(macOS)
import AppKit
extension NSColor: PlatformColor {
    static var primary: NSColor { .systemBlue }
    static var secondary: NSColor { .systemGray }
}
typealias Color = NSColor
#endif
```

## Implementation Patterns

### Type Aliases for Platform Types

Create platform-agnostic type aliases:

```swift
#if os(iOS) || os(tvOS)
import UIKit
typealias PlatformView = UIView
typealias PlatformViewController = UIViewController
typealias PlatformColor = UIColor
typealias PlatformImage = UIImage
typealias PlatformFont = UIFont
#elseif os(macOS)
import AppKit
typealias PlatformView = NSView
typealias PlatformViewController = NSViewController
typealias PlatformColor = NSColor
typealias PlatformImage = NSImage
typealias PlatformFont = NSFont
#endif

// Now use PlatformView everywhere
class CustomView: PlatformView {
    // Works on both iOS and macOS
}
```

### SwiftUI Adaptive Design

SwiftUI provides automatic adaptation across platforms:

```swift
struct ContentView: View {
    var body: some View {
        NavigationSplitView {
            // Sidebar - becomes navigation on iOS, sidebar on macOS
            List(categories) { category in
                NavigationLink(category.name, value: category)
            }
        } detail: {
            // Detail view
            DetailView()
        }
    }
}

// Platform-specific modifiers
struct AdaptiveView: View {
    var body: some View {
        Text("Hello")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #elseif os(macOS)
            .frame(minWidth: 400, minHeight: 300)
            #endif
    }
}
```

### Environment-Based Adaptation

Use SwiftUI environment values for runtime adaptation:

```swift
struct ResponsiveView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var body: some View {
        if horizontalSizeClass == .compact {
            // iPhone portrait or narrow iPad
            VStack {
                Sidebar()
                Content()
            }
        } else {
            // iPad landscape, macOS
            HStack {
                Sidebar()
                Content()
            }
        }
    }
}
```

### Platform Detection at Runtime

Check platform at runtime when needed:

```swift
extension View {
    func adaptivePadding() -> some View {
        #if os(iOS)
        return self.padding()
        #elseif os(macOS)
        return self.padding(20)
        #elseif os(watchOS)
        return self.padding(8)
        #endif
    }
}

// Or use environment
struct PlatformInfo {
    static var current: Platform {
        #if os(iOS)
        return .iOS
        #elseif os(macOS)
        return .macOS
        #elseif os(watchOS)
        return .watchOS
        #elseif os(tvOS)
        return .tvOS
        #elseif os(visionOS)
        return .visionOS
        #endif
    }
}

enum Platform {
    case iOS, macOS, watchOS, tvOS, visionOS
}
```

### Shared Business Logic

Keep business logic platform-independent:

```swift
// Shared model - works on all platforms
struct User: Codable, Identifiable {
    let id: UUID
    var name: String
    var email: String
}

// Shared networking - no platform dependencies
actor NetworkService {
    func fetchUser(id: UUID) async throws -> User {
        let url = URL(string: "https://api.example.com/users/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(User.self, from: data)
    }
}

// Platform-specific UI
#if os(iOS)
struct UserProfileView: View {
    // iOS implementation
}
#elseif os(macOS)
struct UserProfileView: View {
    // macOS implementation
}
#endif
```

### Platform Abstraction Layer

Create a dedicated abstraction layer for platform differences:

```swift
// PlatformKit/PlatformKit.swift
protocol ImageProvider {
    associatedtype ImageType
    func loadImage(named: String) -> ImageType?
}

#if os(iOS)
import UIKit
struct iOSImageProvider: ImageProvider {
    func loadImage(named: String) -> UIImage? {
        UIImage(named: named)
    }
}
typealias DefaultImageProvider = iOSImageProvider
#elseif os(macOS)
import AppKit
struct macOSImageProvider: ImageProvider {
    func loadImage(named: String) -> NSImage? {
        NSImage(named: named)
    }
}
typealias DefaultImageProvider = macOSImageProvider
#endif

// App code uses abstraction
let provider = DefaultImageProvider()
let image = provider.loadImage(named: "logo")
```

### Catalyst Considerations

When running iPad apps on macOS via Catalyst:

```swift
#if targetEnvironment(macCatalyst)
// Catalyst-specific code
extension UIApplication {
    var macOSWindowFrame: CGRect? {
        // Access macOS window properties
        return nil
    }
}
#endif

// Check at runtime
if ProcessInfo.processInfo.isiOSAppOnMac {
    // Running as Catalyst
}
```

### Input Method Adaptation

Handle different input methods:

```swift
struct AdaptiveButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Click Me")
        }
        #if os(macOS)
        .keyboardShortcut("K", modifiers: .command)
        #endif
        #if os(tvOS)
        .buttonStyle(.card)
        #endif
    }
}

// Gesture handling
struct GestureView: View {
    var body: some View {
        Rectangle()
            .fill(.blue)
            #if os(iOS) || os(visionOS)
            .onTapGesture {
                print("Tapped")
            }
            #elseif os(macOS)
            .onTapGesture {
                print("Clicked")
            }
            #endif
    }
}
```

### File System Access

Handle platform-specific file access:

```swift
struct FileManager {
    static func documentsDirectory() -> URL {
        #if os(iOS) || os(watchOS) || os(tvOS)
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        #elseif os(macOS)
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        #endif
    }

    static func saveFile(data: Data, filename: String) throws {
        #if os(tvOS)
        // tvOS: No local storage, must use iCloud
        throw FileError.storageNotAvailable
        #else
        let url = documentsDirectory().appendingPathComponent(filename)
        try data.write(to: url)
        #endif
    }
}
```

### Navigation Patterns

Implement platform-appropriate navigation:

```swift
struct AdaptiveNavigation: View {
    var body: some View {
        #if os(iOS)
        NavigationStack {
            ContentList()
        }
        #elseif os(macOS)
        NavigationSplitView {
            SidebarView()
        } detail: {
            DetailView()
        }
        .navigationSplitViewStyle(.balanced)
        #elseif os(watchOS)
        // watchOS: Simple vertical navigation
        NavigationStack {
            ContentList()
        }
        #elseif os(tvOS)
        // tvOS: Focus-based tab navigation
        TabView {
            ContentList()
                .tabItem { Label("Home", systemImage: "house") }
        }
        #endif
    }
}
```

## Best Practices

1. **Minimize conditional compilation** - Use protocol abstraction instead of scattered #if statements

2. **Share business logic** - Keep models, networking, and data processing platform-independent

3. **Use SwiftUI when possible** - Automatically adapts across platforms with minimal platform-specific code

4. **Respect platform conventions** - Don't force iOS patterns onto macOS (or vice versa)

5. **Test on all targets** - Ensure app works correctly on each supported platform

6. **Use size classes** - Adapt UI based on environment rather than hardcoding platform checks

7. **Create platform-specific views** - When differences are significant, create separate view implementations

8. **Centralize platform detection** - Put platform checks in dedicated files/modules

9. **Document platform limitations** - Note when features aren't available on certain platforms

10. **Use availability checks** - `@available(iOS 17, *)` for version-specific features

## Platform-Specific Considerations

### iOS/iPadOS

**Unique features:**
- Multitasking (Split View, Slide Over on iPad)
- Touch-based interaction
- Home Screen widgets
- App Clips
- Handoff and Continuity

**UI Patterns:**
- Tab bar at bottom
- Navigation bar at top
- Swipe gestures
- Pull-to-refresh

```swift
#if os(iOS)
struct iOSFeatures: View {
    var body: some View {
        List {
            Text("Item")
        }
        .refreshable {
            await refresh()
        }
        .swipeActions {
            Button("Delete", role: .destructive) { }
        }
    }
}
#endif
```

### macOS

**Unique features:**
- Multiple windows
- Menu bar
- Toolbar customization
- Keyboard shortcuts essential
- Right-click context menus

**Coordinate system:** Bottom-left origin (unlike iOS's top-left)

```swift
#if os(macOS)
struct macOSFeatures: View {
    var body: some View {
        Text("Content")
            .frame(minWidth: 600, minHeight: 400)
            .toolbar {
                ToolbarItem {
                    Button("New") { }
                        .keyboardShortcut("N", modifiers: .command)
                }
            }
    }
}
#endif
```

### watchOS

**Constraints:**
- Extremely limited resources
- Small screen (< 50mm diagonal)
- SwiftUI only (Xcode 14+)
- Minimal background execution
- No keyboard input

**Features:**
- Digital Crown navigation
- Complications
- HealthKit integration

```swift
#if os(watchOS)
struct WatchFeatures: View {
    @State private var crownValue = 0.0

    var body: some View {
        VStack {
            Text("\(Int(crownValue))")
        }
        .digitalCrownRotation($crownValue, from: 0, through: 100, by: 1)
    }
}
#endif
```

### tvOS

**Constraints:**
- No touch input
- Focus-based navigation only
- No local storage (iCloud only)
- No WebKit/WebViews
- 10-foot viewing distance

**Features:**
- Siri Remote
- Top Shelf
- Picture in Picture

```swift
#if os(tvOS)
struct TVFeatures: View {
    var body: some View {
        TabView {
            MoviesView()
                .tabItem { Label("Movies", systemImage: "film") }
        }
        .focusSection()  // Group focus
    }
}
#endif
```

### visionOS

**Features:**
- Spatial computing
- Eye tracking + gestures
- 3D windows and volumes
- Immersive spaces
- RealityKit integration

```swift
#if os(visionOS)
import RealityKit

struct VisionFeatures: View {
    var body: some View {
        Model3D(named: "Scene") { model in
            model
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
        .frame(depth: 300)  // visionOS-specific
    }
}
#endif
```

## Common Pitfalls

1. **Over-using conditional compilation**
   - ❌ `#if os(iOS)` scattered throughout codebase
   - ✅ Protocol abstraction with platform-specific implementations

2. **Ignoring platform conventions**
   - ❌ Using iOS tab bar pattern on macOS
   - ✅ Sidebar navigation on macOS, tabs on iOS

3. **Forgetting coordinate system differences**
   - ❌ Assuming top-left origin on macOS
   - ✅ Use SwiftUI or handle coordinate conversion

4. **Not testing on all platforms**
   - ❌ Developing on iOS, assuming macOS works
   - ✅ Run and test on each target platform

5. **Hardcoding platform assumptions**
   - ❌ `let isPhone = true`
   - ✅ Check environment at runtime

6. **Copying platform-specific code**
   - ❌ Duplicating entire views for each platform
   - ✅ Share common components, specialize where needed

7. **Ignoring input method differences**
   - ❌ Touch-only interactions on macOS
   - ✅ Support keyboard, mouse, and accessibility

8. **Not handling unavailable APIs**
   - ❌ Using iOS-only APIs on macOS
   - ✅ Use `#available` or conditional compilation

## Related Skills

- `platform-differences` - Detailed platform-specific requirements
- `swiftui-essentials` - SwiftUI adaptive design patterns
- `human-interface-guidelines` - Platform-specific HIG compliance
- `deployment-essentials` - Building for multiple platforms

## Example Scenarios

### Scenario 1: Platform-Agnostic Network Layer

```swift
// Shared across all platforms
actor NetworkClient {
    private let session: URLSession

    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        self.session = URLSession(configuration: config)
    }

    func fetch<T: Decodable>(url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}

enum NetworkError: Error {
    case invalidResponse
    case decodingFailed
}

// Use on any platform
let client = NetworkClient()
let users: [User] = try await client.fetch(url: usersURL)
```

### Scenario 2: Adaptive UI Layout

```swift
struct AdaptiveLayout: View {
    @Environment(\.horizontalSizeClass) var horizontalSize
    @State private var items: [Item] = []

    var body: some View {
        Group {
            if horizontalSize == .compact {
                // Compact: iPhone portrait, narrow iPad
                CompactLayout(items: items)
            } else {
                // Regular: iPad landscape, macOS
                RegularLayout(items: items)
            }
        }
        .navigationTitle("Items")
    }
}

struct CompactLayout: View {
    let items: [Item]

    var body: some View {
        List(items) { item in
            VStack(alignment: .leading) {
                Text(item.title).font(.headline)
                Text(item.subtitle).font(.caption)
            }
        }
    }
}

struct RegularLayout: View {
    let items: [Item]

    var body: some View {
        NavigationSplitView {
            List(items) { item in
                NavigationLink(item.title, value: item)
            }
        } detail: {
            ItemDetailView()
        }
    }
}
```

### Scenario 3: Platform Abstraction Protocol

```swift
protocol PlatformAdapter {
    func showAlert(title: String, message: String)
    func shareContent(_ content: String)
    func openURL(_ url: URL)
}

#if os(iOS)
import UIKit

class iOSAdapter: PlatformAdapter {
    weak var viewController: UIViewController?

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController?.present(alert, animated: true)
    }

    func shareContent(_ content: String) {
        let activityVC = UIActivityViewController(activityItems: [content], applicationActivities: nil)
        viewController?.present(activityVC, animated: true)
    }

    func openURL(_ url: URL) {
        UIApplication.shared.open(url)
    }
}
#elseif os(macOS)
import AppKit

class macOSAdapter: PlatformAdapter {
    func showAlert(title: String, message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.runModal()
    }

    func shareContent(_ content: String) {
        let picker = NSSharingServicePicker(items: [content])
        picker.show(relativeTo: .zero, of: NSApp.keyWindow!.contentView!, preferredEdge: .minY)
    }

    func openURL(_ url: URL) {
        NSWorkspace.shared.open(url)
    }
}
#endif

// App uses the adapter
#if os(iOS)
let adapter = iOSAdapter()
#elseif os(macOS)
let adapter = macOSAdapter()
#endif

adapter.showAlert(title: "Hello", message: "Cross-platform alert")
```

### Scenario 4: SwiftUI Multi-Platform App

```swift
@main
struct MultiPlatformApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        #if os(macOS)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Item") {
                    createNewItem()
                }
                .keyboardShortcut("N", modifiers: .command)
            }
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified)
        #endif

        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }

    func createNewItem() {
        // Implementation
    }
}

struct ContentView: View {
    var body: some View {
        NavigationSplitView {
            SidebarView()
        } detail: {
            DetailView()
        }
        #if os(iOS)
        .navigationSplitViewStyle(.balanced)
        #elseif os(macOS)
        .navigationSplitViewStyle(.prominentDetail)
        #endif
    }
}
```

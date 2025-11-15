# Swift/Xcode Quick Reference

Fast lookup for common patterns and solutions.

## Swift 6 Essentials

### Actor Isolation
```swift
actor DataCache {
    private var cache: [String: Data] = [:]

    func store(_ data: Data, forKey key: String) {
        cache[key] = data
    }
}

// Usage
let cache = DataCache()
await cache.store(data, forKey: "key")
```

### Typed Throws
```swift
func fetch() throws(NetworkError) -> Data {
    throw .timeout
}

do {
    let data = try fetch()
} catch {
    // error is NetworkError, not Error
}
```

### MainActor
```swift
@MainActor
class ViewModel: ObservableObject {
    @Published var data: [Item] = []

    func loadData() async {
        data = await fetchData()  // Already on main
    }
}
```

## SwiftUI Patterns

### State Management
```swift
// Local state
@State private var count = 0

// Owned object
@StateObject private var viewModel = ViewModel()

// Passed object
@ObservedObject var viewModel: ViewModel

// Environment
@EnvironmentObject var settings: AppSettings

// Modern (iOS 17+)
@Observable class Model { }
```

### Navigation
```swift
NavigationStack(path: $path) {
    List(items) { item in
        NavigationLink(value: item) {
            ItemRow(item: item)
        }
    }
    .navigationDestination(for: Item.self) { item in
        DetailView(item: item)
    }
}
```

## Memory Management

### Weak Self
```swift
// Closure
completion { [weak self] in
    self?.update()
}

// Combine
publisher.sink { [weak self] value in
    self?.handle(value)
}
.store(in: &cancellables)
```

### Delegate
```swift
protocol MyDelegate: AnyObject { }

class MyClass {
    weak var delegate: MyDelegate?  // Always weak!
}
```

## Networking

### Basic Request
```swift
let (data, response) = try await URLSession.shared.data(from: url)

guard let httpResponse = response as? HTTPURLResponse,
      (200...299).contains(httpResponse.statusCode) else {
    throw NetworkError.invalidResponse
}

let decoded = try JSONDecoder().decode(Model.self, from: data)
```

### Error Handling
```swift
do {
    let data = try await fetchData()
} catch NetworkError.unauthorized {
    // Handle auth error
} catch {
    // Handle other errors
}
```

## Testing

### Swift Testing
```swift
@Test
func addition() {
    #expect(2 + 2 == 4)
}

@Test(arguments: [1, 2, 3])
func isPositive(_ number: Int) {
    #expect(number > 0)
}
```

### XCTest
```swift
func testExample() {
    XCTAssertEqual(value, expected)
    XCTAssertTrue(condition)
    XCTAssertNil(value)
}
```

## Debugging

### Breakpoint
- Click line number gutter
- Right-click → Edit → Add condition
- Add action (LLDB command, log message)

### LLDB
```lldb
po myObject              # Print object
p myVariable            # Print variable
bt                      # Stack trace
frame variable          # Local variables
```

## Data Persistence

### SwiftData
```swift
@Model
class Item {
    var name: String
    init(name: String) { self.name = name }
}

// In view
@Query var items: [Item]
@Environment(\.modelContext) var context

context.insert(newItem)
```

### UserDefaults
```swift
UserDefaults.standard.set(value, forKey: "key")
let value = UserDefaults.standard.string(forKey: "key")
```

### Keychain
```swift
let query: [String: Any] = [
    kSecClass as String: kSecClassGenericPassword,
    kSecAttrAccount as String: identifier,
    kSecValueData as String: data
]
SecItemAdd(query as CFDictionary, nil)
```

## Performance

### Launch Optimization
```swift
func application(...didFinishLaunching...) -> Bool {
    // Minimal sync work only
    setupCrashReporting()

    // Defer heavy work
    Task { await loadConfiguration() }

    return true
}
```

### Memory
```swift
let cache = NSCache<NSString, UIImage>()
cache.countLimit = 100
cache.totalCostLimit = 50 * 1024 * 1024  // 50 MB
```

## Accessibility

### Labels
```swift
Image(systemName: "trash")
    .accessibilityLabel("Delete")

Button(action: submit) {
    Image(systemName: "paperplane")
}
.accessibilityLabel("Submit form")
```

### Dynamic Type
```swift
Text("Hello")
    .font(.body)  // Scales automatically

Text("Custom")
    .font(.custom("MyFont", size: 17, relativeTo: .body))
```

## Common Mistakes

### ❌ Don't
```swift
// Force unwrap
let name = user!.name

// Strong delegate
var delegate: MyDelegate?

// Fixed font size
.font(.system(size: 14))

// Blocking main thread
UserDefaults.standard.set(heavyData, forKey: "key")

// Missing [weak self]
timer = Timer.scheduledTimer { self.update() }
```

### ✅ Do
```swift
// Safe unwrapping
guard let name = user?.name else { return }

// Weak delegate
weak var delegate: MyDelegate?

// Scalable font
.font(.body)

// Background work
Task { await performHeavyWork() }

// Weak capture
timer = Timer.scheduledTimer { [weak self] _ in
    self?.update()
}
```

## Platform Differences

| Feature | iOS | macOS | watchOS | tvOS |
|---------|-----|-------|---------|------|
| Input | Touch | Mouse/Keyboard | Digital Crown/Tap | Siri Remote |
| Navigation | Tab Bar | Menu Bar | Simple Stack | Focus-based |
| Multitasking | Yes | Always | No | No |
| Background | Limited | Full | Minimal | Limited |
| Storage | Sandboxed | Less restricted | Minimal | iCloud only |

## Useful Commands

- `/new-swiftui-view` - Create new SwiftUI view
- `/review-memory` - Memory leak analysis
- `/optimize-performance` - Performance audit
- `/add-tests` - Generate tests
- `/fix-accessibility` - Accessibility improvements
- `/setup-storekit` - In-app purchase setup

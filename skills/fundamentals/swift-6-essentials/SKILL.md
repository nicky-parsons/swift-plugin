---
name: swift-6-essentials
description: Implement Swift 6 language features including data race safety, typed throws, actor isolation, Sendable protocol, and strict concurrency checking. Use when migrating to Swift 6, writing concurrent code, or fixing data race warnings in Swift applications.
version: 1.0.0
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# Swift 6 Essentials

## What This Skill Does

Provides comprehensive guidance on Swift 6's groundbreaking features, with emphasis on compile-time data race safety, typed throws, and safe concurrency patterns. This skill helps developers write safer, more maintainable Swift code and successfully migrate from Swift 5 to Swift 6.

## When to Activate

- Migrating existing Swift 5 code to Swift 6
- Implementing concurrent code with actors and async/await
- Fixing data race warnings and strict concurrency errors
- Understanding and using typed throws for better error handling
- Adopting Swift 6 language mode in new or existing projects
- Working with Sendable types and actor isolation

## Core Concepts

### Data Race Safety

**Swift 6's flagship feature is compile-time data race safety**, making applications significantly safer by preventing data races at compile time rather than runtime. The compiler enforces:

- **Actor isolation**: Protects mutable state with automatic synchronization
- **Sendable conformance**: Marks types that can be safely shared across concurrency domains
- **Main actor isolation**: Ensures UI code runs on the main thread
- **Strict concurrency checking**: Three-level migration path (minimal → targeted → complete)

### Typed Throws

Swift 6 introduces **typed throws** (SE-0413), eliminating type erasure in error handling and enabling more precise error handling:

```swift
enum CopierError: Error {
    case outOfPaper
    case jammed
    case tonerLow
}

func photocopy(pages: Int) throws(CopierError) {
    if pages > 100 {
        throw .outOfPaper  // Type is inferred
    }
}

// Caller knows exact error type
do {
    try photocopy(pages: 150)
} catch {
    // error is CopierError, not any Error
    switch error {
    case .outOfPaper: print("Add paper")
    case .jammed: print("Clear jam")
    case .tonerLow: print("Replace toner")
    }
}
```

### Swift 6.2 Performance Features

- **InlineArray**: Stack-allocated fixed-size arrays for improved performance
- **Span**: Safe buffer operations without overhead
- **Pack iteration**: Enhanced support for variadic generics

## Implementation Patterns

### Actor Isolation Pattern

Actors provide mutually exclusive access to mutable state, preventing data races:

```swift
actor DataCache {
    private var cache: [String: Data] = [:]
    private var timestamps: [String: Date] = [:]

    func store(_ data: Data, forKey key: String) {
        cache[key] = data
        timestamps[key] = Date()
    }

    func retrieve(forKey key: String) -> Data? {
        return cache[key]
    }

    // nonisolated for methods that don't access mutable state
    nonisolated func cacheSize() -> Int {
        // This won't compile - can't access isolated state
        // return cache.count
        return 0
    }
}

// Usage
let cache = DataCache()
await cache.store(imageData, forKey: "profile")
let data = await cache.retrieve(forKey: "profile")
```

### MainActor for UI Updates

Mark UI-related code with `@MainActor` to ensure main thread execution:

```swift
@MainActor
class ViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var isLoading = false

    func loadData() async {
        isLoading = true  // Already on main thread

        // Fetch data on background
        let newItems = await fetchItems()

        // Update UI properties - automatically on main thread
        items = newItems
        isLoading = false
    }
}

// Individual method isolation
class NetworkService {
    func fetchData() async -> Data {
        // Runs on background
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }

    @MainActor
    func updateUI(with data: Data) {
        // Guaranteed to run on main thread
        label.text = String(data: data, encoding: .utf8)
    }
}
```

### Sendable Protocol

Sendable marks types safe for concurrent access:

```swift
// Structs with Sendable properties are automatically Sendable
struct User: Sendable {
    let id: UUID
    let name: String
    let email: String
}

// Classes must be final and have immutable properties
final class Configuration: Sendable {
    let apiKey: String
    let baseURL: URL

    init(apiKey: String, baseURL: URL) {
        self.apiKey = apiKey
        self.baseURL = baseURL
    }
}

// Actors are implicitly Sendable
actor MessageQueue: Sendable {
    private var messages: [Message] = []
}

// Use @unchecked Sendable ONLY when you guarantee thread safety manually
class ThreadSafeCounter: @unchecked Sendable {
    private let lock = NSLock()
    private var _count = 0

    var count: Int {
        lock.lock()
        defer { lock.unlock() }
        return _count
    }

    func increment() {
        lock.lock()
        defer { lock.unlock() }
        _count += 1
    }
}
```

### Typed Throws Pattern

Use typed throws for precise error handling:

```swift
enum NetworkError: Error {
    case invalidURL
    case noConnection
    case serverError(statusCode: Int)
    case decodingFailed
}

struct APIClient {
    func fetchUser(id: String) throws(NetworkError) -> User {
        guard let url = URL(string: "https://api.example.com/users/\(id)") else {
            throw .invalidURL
        }

        // Implementation...
        throw .noConnection
    }

    // Can propagate specific errors
    func fetchAndDecodeUser(id: String) throws(NetworkError) -> User {
        let user = try fetchUser(id: id)  // NetworkError propagates
        return user
    }
}

// Never throws - use for functions that can't fail
func calculateSum(_ numbers: [Int]) throws(Never) -> Int {
    return numbers.reduce(0, +)
}

// Generic errors still work
func legacyFunction() throws {
    throw NetworkError.noConnection  // Any Error
}
```

### Strict Concurrency Migration

Enable strict concurrency incrementally:

```swift
// Build Settings or Swift Package manifest

// Level 1: Minimal - only errors for data races
// -strict-concurrency=minimal

// Level 2: Targeted - warnings for Sendable conformance
// -strict-concurrency=targeted

// Level 3: Complete - full enforcement
// -strict-concurrency=complete

// Per-module in Package.swift
.target(
    name: "MyModule",
    swiftSettings: [
        .enableUpcomingFeature("StrictConcurrency")
    ]
)
```

### Nonisolated Pattern

Use `nonisolated` for actor methods that don't need isolation:

```swift
actor DatabaseManager {
    private var connection: Connection?

    func query(_ sql: String) async -> [Row] {
        // Requires actor isolation
        return await connection?.execute(sql) ?? []
    }

    // Doesn't access mutable state - can be called synchronously
    nonisolated func buildQuery(table: String, where condition: String) -> String {
        return "SELECT * FROM \(table) WHERE \(condition)"
    }
}

let db = DatabaseManager()
// No await needed for nonisolated methods
let query = db.buildQuery(table: "users", where: "active = 1")
let results = await db.query(query)
```

## Best Practices

1. **Enable strict concurrency incrementally** - Start with minimal, fix warnings at targeted, then move to complete before switching to Swift 6 mode

2. **Prefer actors over locks** - Actors provide compile-time safety, locks require manual correctness

3. **Use @MainActor for UI code** - Mark view models, view controllers, and UI update methods with @MainActor

4. **Make types Sendable when possible** - Prefer value types (structs) for data shared across actors

5. **Avoid @unchecked Sendable** - Only use when you have manual synchronization and can prove thread safety

6. **Leverage typed throws** - Provide precise error types for better error handling and API clarity

7. **Document isolation strategy** - Comment why certain types are actors vs classes, and isolation boundaries

8. **Check Task cancellation** - Long-running async operations should check `Task.isCancelled`

9. **Minimize actor boundaries** - Group related state in single actors to reduce await suspension points

10. **Use task groups for parallel work** - `withTaskGroup` for concurrent operations with the same type

## Platform-Specific Considerations

### iOS/iPadOS
- UI updates must use `@MainActor` (UIKit and SwiftUI)
- Background tasks need proper actor isolation for data access
- App lifecycle methods should be marked `@MainActor`

### macOS
- Same concurrency rules apply
- Document-based apps benefit from per-document actors
- Menu and toolbar actions typically need `@MainActor`

### watchOS
- Extremely limited background execution
- Keep actor state minimal due to memory constraints
- Most UI code should be `@MainActor`

### tvOS
- Focus on `@MainActor` for focus-based navigation
- Background data processing benefits from actors

### visionOS
- Spatial computing requires careful actor design for 3D state
- RealityKit entities may need actor isolation

## Common Pitfalls

1. **Assuming async means background execution**
   - ❌ `async` doesn't change execution context
   - ✅ Use `Task` or actors to control where code runs

2. **Using @unchecked Sendable without justification**
   - ❌ Marking mutable classes as `@unchecked Sendable` without synchronization
   - ✅ Only use with proper locks/atomics and document why

3. **Forgetting to await actor methods**
   - ❌ Calling actor methods without await (won't compile)
   - ✅ All actor-isolated methods require await

4. **Over-isolating to MainActor**
   - ❌ Marking data processing code as `@MainActor`
   - ✅ Only UI-related code should be `@MainActor`

5. **Not checking Task.isCancelled**
   - ❌ Long operations ignoring cancellation
   - ✅ Periodically check `if Task.isCancelled { return }`

6. **Creating reference cycles with actors**
   - ❌ Actors capturing strong references to each other
   - ✅ Use weak/unowned where appropriate

7. **Mixing completion handlers with async/await**
   - ❌ Using both patterns in the same codebase
   - ✅ Wrap completion-based APIs with `withCheckedContinuation`

8. **Not understanding Sendable requirements**
   - ❌ Passing non-Sendable types across actor boundaries
   - ✅ Make types Sendable or copy data before sharing

## Migration Strategy

### Step 1: Enable Upcoming Features
```swift
// In build settings or Package.swift
.enableUpcomingFeature("StrictConcurrency")
```

### Step 2: Set Minimal Concurrency
Address only definite data race errors first.

### Step 3: Fix Targeted Warnings
Address Sendable conformance and isolation warnings.

### Step 4: Complete Enforcement
Enable complete strict concurrency checking.

### Step 5: Switch to Swift 6 Mode
Once all warnings are resolved, switch language mode to Swift 6.

### Per-Module Migration
Migrate one module at a time rather than the entire project:

```swift
// Package.swift
.target(
    name: "SafeModule",
    swiftSettings: [
        .swiftLanguageMode(.v6)
    ]
),
.target(
    name: "LegacyModule",
    swiftSettings: [
        .swiftLanguageMode(.v5)
    ]
)
```

## Related Skills

- `concurrency-safety` - Deep dive into actors, isolation, and async patterns
- `memory-management` - Understanding reference semantics with actors
- `swiftui-essentials` - Using Swift 6 with SwiftUI's @Observable
- `testing-fundamentals` - Testing concurrent code with Swift Testing

## Example Scenarios

### Scenario 1: Migrating a Network Service

```swift
// Before: Swift 5 with completion handlers
class NetworkService {
    var cache: [String: Data] = [:]

    func fetch(url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                self.cache[url.absoluteString] = data  // Data race!
            }
            completion(data)
        }.resume()
    }
}

// After: Swift 6 with actor isolation
actor NetworkService {
    private var cache: [String: Data] = [:]

    func fetch(url: URL) async throws -> Data {
        // Check cache first
        if let cached = cache[url.absoluteString] {
            return cached
        }

        // Fetch new data
        let (data, _) = try await URLSession.shared.data(from: url)
        cache[url.absoluteString] = data  // Safe - actor isolated
        return data
    }
}
```

### Scenario 2: UI Update Safety

```swift
// Before: Potential main thread issues
class ViewModel: ObservableObject {
    @Published var data: [Item] = []

    func loadData() {
        Task {
            let items = await fetchItems()
            self.data = items  // Warning: Publishing changes from background thread
        }
    }
}

// After: Proper main actor isolation
@MainActor
class ViewModel: ObservableObject {
    @Published var data: [Item] = []

    func loadData() async {
        data = await fetchItems()  // Safe - already on main thread
    }
}
```

### Scenario 3: Sendable Conformance

```swift
// Before: Non-Sendable type
class UserPreferences {
    var theme: String = "light"
    var notifications: Bool = true
}

// After: Sendable value type
struct UserPreferences: Sendable {
    let theme: String
    let notifications: Bool
}

// Or use actor for mutable shared state
actor UserPreferences {
    var theme: String = "light"
    var notifications: Bool = true

    func updateTheme(_ newTheme: String) {
        theme = newTheme
    }
}
```

## Additional Resources

For deeper exploration of specific topics:
- Actor isolation patterns and performance: See `concurrency-safety` skill
- Sendable conformance for complex types: See documentation in `references/sendable-patterns.md`
- Migration guides for large codebases: See `references/migration-guide.md`

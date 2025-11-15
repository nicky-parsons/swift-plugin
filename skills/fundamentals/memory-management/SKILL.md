---
name: memory-management
description: Manage memory in Swift applications using Automatic Reference Counting (ARC), weak and unowned references, avoid retain cycles, prevent memory leaks, and use Memory Graph Debugger. Use when debugging memory issues, implementing delegates, using closures, or preventing crashes from deallocated objects.
version: 1.0.0
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# Memory Management

## What This Skill Does

Provides comprehensive guidance on memory management in Swift, focusing on Automatic Reference Counting (ARC), preventing retain cycles, proper use of weak and unowned references, and debugging memory leaks. Essential for building stable, crash-free applications.

## When to Activate

- Debugging memory leaks or retain cycles
- Implementing delegate patterns
- Using closures that capture self
- Managing object lifetimes
- Investigating crashes from accessing deallocated objects
- Optimizing memory usage
- Understanding reference counting and ownership

## Core Concepts

### Automatic Reference Counting (ARC)

Swift uses **ARC** to manage memory automatically:

- Every instance of a class has a **reference count**
- Each strong reference increases the count by 1
- When count reaches 0, instance is deallocated
- Applies only to **classes** (reference types)
- Structs and enums are value types (copied, not referenced)

```swift
class User {
    let name: String

    init(name: String) {
        self.name = name
        print("User \(name) initialized")
    }

    deinit {
        print("User \(name) deallocated")
    }
}

var user1: User? = User(name: "Alice")  // Ref count: 1
var user2 = user1  // Ref count: 2
user1 = nil  // Ref count: 1
user2 = nil  // Ref count: 0, deallocates
```

### Strong, Weak, and Unowned References

**Strong** (default): Increases reference count, keeps object alive
**Weak**: Does not increase reference count, becomes nil when object deallocates
**Unowned**: Does not increase reference count, assumes object exists (crashes if nil)

```swift
class Person {
    let name: String
    weak var spouse: Person?  // Weak to break cycle
    unowned let birthPlace: City  // Unowned - city must outlive person

    init(name: String, birthPlace: City) {
        self.name = name
        self.birthPlace = birthPlace
    }
}
```

### Retain Cycles

A **retain cycle** occurs when two objects hold strong references to each other:

```swift
// ❌ Retain cycle
class Parent {
    var child: Child?
}

class Child {
    var parent: Parent?  // Strong reference creates cycle
}

let parent = Parent()
let child = Child()
parent.child = child
child.parent = parent  // Cycle: neither can be deallocated
```

**Solution**: Make one reference weak:

```swift
// ✅ No retain cycle
class Child {
    weak var parent: Parent?  // Weak breaks the cycle
}
```

## Implementation Patterns

### Delegate Pattern with Weak Reference

Always make delegates weak to prevent retain cycles:

```swift
protocol DataServiceDelegate: AnyObject {
    func dataDidUpdate(_ data: [Item])
    func dataUpdateFailed(_ error: Error)
}

class DataService {
    weak var delegate: DataServiceDelegate?  // Always weak!

    func fetchData() async {
        do {
            let data = try await performFetch()
            delegate?.dataDidUpdate(data)
        } catch {
            delegate?.dataUpdateFailed(error)
        }
    }
}

class ViewController: UIViewController, DataServiceDelegate {
    let dataService = DataService()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataService.delegate = self  // VC owns service, service has weak delegate
    }

    func dataDidUpdate(_ data: [Item]) {
        // Update UI
    }

    func dataUpdateFailed(_ error: Error) {
        // Show error
    }
}
```

**Why weak?**
- ViewController owns DataService (strong reference)
- If delegate was strong, DataService would own ViewController
- Creates retain cycle: ViewController → DataService → ViewController

### Closure Capture Lists

Closures capture references strongly by default, creating potential cycles:

```swift
// ❌ Retain cycle
class ViewModel {
    var data: [Item] = []
    var onUpdate: (() -> Void)?

    func setupCallback() {
        onUpdate = {
            self.updateUI()  // Strong capture of self creates cycle
        }
    }

    func updateUI() {
        // Update UI
    }
}

// ✅ Use weak self to break cycle
class ViewModel {
    var data: [Item] = []
    var onUpdate: (() -> Void)?

    func setupCallback() {
        onUpdate = { [weak self] in
            self?.updateUI()  // Optional call - self might be nil
        }
    }
}

// ✅ Use unowned when self guaranteed to exist
class ViewModel {
    var data: [Item] = []
    var onUpdate: (() -> Void)?

    func setupCallback() {
        onUpdate = { [unowned self] in
            self.updateUI()  // Non-optional - assumes self exists
        }
    }
}
```

### Guard let Self Pattern

Safely unwrap weak self in closures:

```swift
class NetworkService {
    func fetchData(completion: @escaping (Data) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }

            // Now self is strong for the scope of this closure
            self.processData(data)
            self.updateCache()
            completion(data!)
        }.resume()
    }
}

// Modern Swift: Implicit self after guard
URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
    guard let self else { return }

    processData(data)  // Can omit self. after guard
    updateCache()
}
```

### Unowned vs Weak Decision Matrix

**Use weak when:**
- Reference might become nil during object's lifetime
- Optional relationship
- Delegates, callbacks, parent-child where parent can disappear first

**Use unowned when:**
- Reference will never become nil
- Object guarantees outlive relationship
- Slight performance benefit (no optional unwrapping)
- Crashes if assumption violated (safer to use weak when uncertain)

```swift
class Country {
    let name: String
    var capital: City?

    init(name: String) {
        self.name = name
    }
}

class City {
    let name: String
    unowned let country: Country  // City cannot exist without country

    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
}

let france = Country(name: "France")
let paris = City(name: "Paris", country: france)
france.capital = paris
// paris.country is unowned - france must outlive paris
```

### Notification Observers

Remove observers in deinit to prevent crashes:

```swift
class ViewController: UIViewController {
    var observer: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        observer = NotificationCenter.default.addObserver(
            forName: .dataUpdated,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleUpdate(notification)
        }
    }

    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

// Better: Use Combine for automatic cleanup
import Combine

class ViewController: UIViewController {
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.publisher(for: .dataUpdated)
            .sink { [weak self] notification in
                self?.handleUpdate(notification)
            }
            .store(in: &cancellables)
    }

    // Cancellables automatically cleaned up in deinit
}
```

### Timer Retain Cycles

Timers strongly retain their targets:

```swift
// ❌ Retain cycle
class ViewController: UIViewController {
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Timer retains self strongly!
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(update),
            userInfo: nil,
            repeats: true
        )
    }

    @objc func update() {
        // Update UI
    }

    deinit {
        timer?.invalidate()  // Never called - retain cycle prevents deinit!
    }
}

// ✅ Use weak reference wrapper
class WeakTimerTarget {
    weak var target: AnyObject?
    let selector: Selector

    init(target: AnyObject, selector: Selector) {
        self.target = target
        self.selector = selector
    }

    @objc func fire() {
        _ = target?.perform(selector)
    }
}

class ViewController: UIViewController {
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        let wrapper = WeakTimerTarget(target: self, selector: #selector(update))
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: wrapper,
            selector: #selector(WeakTimerTarget.fire),
            userInfo: nil,
            repeats: true
        )
    }

    deinit {
        timer?.invalidate()  // Now called properly
    }
}

// ✅ Best: Use block-based timer (iOS 10+)
class ViewController: UIViewController {
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.update()
        }
    }

    deinit {
        timer?.invalidate()
    }
}
```

### Lazy Properties and Self Capture

Be careful with lazy properties:

```swift
class ViewModel {
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = self.locale  // Captures self!
        return formatter
    }()

    var locale: Locale = .current
}

// ✅ Avoid capturing self in lazy initializer
class ViewModel {
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        // Don't reference self here
        return formatter
    }()

    func configureFormatter() {
        formatter.locale = locale  // Configure after initialization
    }
}
```

### Array and Dictionary Retain Behavior

Collections hold strong references to their elements:

```swift
class Item {
    let name: String

    init(name: String) {
        self.name = name
        print("Item \(name) created")
    }

    deinit {
        print("Item \(name) deallocated")
    }
}

var items: [Item] = []
items.append(Item(name: "A"))  // Array holds strong reference
items.append(Item(name: "B"))

items.removeAll()  // Items deallocated when removed and no other references exist
```

**Weak reference arrays:**

```swift
class WeakBox<T: AnyObject> {
    weak var value: T?

    init(_ value: T) {
        self.value = value
    }
}

class Cache {
    private var items: [WeakBox<Item>] = []

    func add(_ item: Item) {
        items.append(WeakBox(item))
    }

    func cleanup() {
        items.removeAll { $0.value == nil }
    }

    var activeItems: [Item] {
        items.compactMap { $0.value }
    }
}
```

### Actors and Memory Management

Actors in Swift 6 follow the same ARC rules:

```swift
actor DataCache {
    private var cache: [String: Data] = [:]
    weak var delegate: CacheDelegate?  // Still use weak for delegates

    func store(_ data: Data, forKey key: String) {
        cache[key] = data
        delegate?.cacheDidUpdate()  // Weak reference
    }
}

// Closures in actors
actor ImageLoader {
    func loadImage(from url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)

        // No need for [weak self] in actor methods - actors are reference counted
        return UIImage(data: data)!
    }

    func loadWithCallback(_ url: URL, completion: @escaping (UIImage?) -> Void) {
        Task { [weak self] in  // Use weak if storing task reference
            guard let self = self else { return }
            let image = try? await self.loadImage(from: url)
            completion(image)
        }
    }
}
```

## Best Practices

1. **Always make delegates weak** - Prevents retain cycles in delegate pattern

2. **Use [weak self] in closures** - When closure might outlive the object

3. **Remove observers in deinit** - Prevent crashes from notifications sent to deallocated objects

4. **Invalidate timers** - Timer retains target strongly, must be invalidated

5. **Monitor deinit calls** - Add print/log in deinit to verify deallocation

6. **Use Memory Graph Debugger** - Visual tool for finding retain cycles

7. **Prefer weak over unowned** - Safer, crashes vs optional unwrapping

8. **Clean up strong references** - Set to nil when no longer needed

9. **Understand capture lists** - Know what `[weak self]`, `[unowned self]`, `[weak foo, bar]` mean

10. **Test object deallocation** - Ensure objects deallocate when expected

## Platform-Specific Considerations

### iOS/iPadOS
- Memory warnings trigger `didReceiveMemoryWarning`
- App suspension releases some memory automatically
- Large images and media primary memory consumers
- Background tasks have memory limits

### macOS
- More available memory (generally)
- Memory warnings less frequent
- Long-running applications more susceptible to leaks
- Multiple windows can multiply memory issues

### watchOS
- Extremely limited memory (< 32MB for apps)
- Aggressive memory management critical
- System terminates apps for memory more readily
- Cache sparingly

### tvOS
- Limited memory relative to media size
- Large video buffers and images
- Background memory very limited

## Common Pitfalls

1. **Forgetting weak in delegates**
   - ❌ `var delegate: MyDelegate?`
   - ✅ `weak var delegate: MyDelegate?`

2. **Strong self capture in closures**
   - ❌ `completion { self.update() }`
   - ✅ `completion { [weak self] in self?.update() }`

3. **Not removing notification observers**
   - ❌ Observer registered, never removed
   - ✅ Remove in deinit or use Combine

4. **Timer retain cycles**
   - ❌ Timer with target self, repeating
   - ✅ Use block-based timer with [weak self]

5. **Force unwrapping weak variables**
   - ❌ `weak var delegate: MyDelegate?` then `delegate!.method()`
   - ✅ `delegate?.method()` or guard let

6. **Circular strong references**
   - ❌ A → B, B → A (both strong)
   - ✅ A → B (strong), B → A (weak)

7. **Using unowned incorrectly**
   - ❌ Assuming object exists when it doesn't
   - ✅ Only use when guaranteed to exist

8. **Lazy property capturing self**
   - ❌ Lazy closure references self.property
   - ✅ Avoid self-references in lazy initializers

## Related Skills

- `debugging-basics` - Using Memory Graph Debugger
- `swift-6-essentials` - Memory management with actors
- `instruments-profiling` - Leaks and Allocations instruments
- `swiftui-essentials` - Memory management in view models

## Example Scenarios

### Scenario 1: Fixing Delegate Retain Cycle

```swift
// ❌ Retain cycle
protocol DownloadDelegate {
    func downloadCompleted(_ data: Data)
}

class Downloader {
    var delegate: DownloadDelegate?  // Strong reference!

    func download() {
        // ... download logic
        delegate?.downloadCompleted(data)
    }
}

class ViewController: DownloadDelegate {
    let downloader = Downloader()  // VC owns Downloader

    func setup() {
        downloader.delegate = self  // Downloader owns VC - CYCLE!
    }
}

// ✅ Fixed
protocol DownloadDelegate: AnyObject {  // Must be AnyObject for weak
    func downloadCompleted(_ data: Data)
}

class Downloader {
    weak var delegate: DownloadDelegate?  // Weak breaks cycle

    func download() {
        delegate?.downloadCompleted(data)
    }
}
```

### Scenario 2: Closure Capture in Async Code

```swift
class ImageLoader {
    var currentImage: UIImage?

    func loadImage(from url: URL) {
        // ❌ Strong capture
        Task {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.currentImage = UIImage(data: data)  // Retains self
        }
    }

    // ✅ Weak capture
    func loadImage(from url: URL) {
        Task { [weak self] in
            let (data, _) = try await URLSession.shared.data(from: url)

            guard let self = self else { return }

            self.currentImage = UIImage(data: data)
        }
    }
}
```

### Scenario 3: Using Memory Graph Debugger

```swift
class ViewControllerA {
    var viewControllerB: ViewControllerB?

    deinit {
        print("ViewControllerA deallocated")  // Never prints - leak!
    }
}

class ViewControllerB {
    var viewControllerA: ViewControllerA?  // Strong reference

    deinit {
        print("ViewControllerB deallocated")  // Never prints - leak!
    }
}

// Create cycle:
let vcA = ViewControllerA()
let vcB = ViewControllerB()
vcA.viewControllerB = vcB
vcB.viewControllerA = vcA  // Cycle created

// Debug using Memory Graph:
// 1. Run app and create the cycle
// 2. Click Debug Memory Graph button (⌘⇧M) in Xcode
// 3. Look for purple ! marks indicating leaks
// 4. Select object to see reference graph
// 5. Fix by making one reference weak

class ViewControllerB {
    weak var viewControllerA: ViewControllerA?  // Fixed!
}
```

### Scenario 4: Combine Subscription Lifecycle

```swift
import Combine

class DataViewModel {
    var cancellables = Set<AnyCancellable>()
    var items: [Item] = []

    func subscribeToUpdates() {
        // ❌ Without [weak self] - might retain
        NotificationCenter.default
            .publisher(for: .dataUpdated)
            .sink { notification in
                self.handleUpdate(notification)  // Captures self
            }
            .store(in: &cancellables)

        // ✅ With [weak self]
        NotificationCenter.default
            .publisher(for: .dataUpdated)
            .sink { [weak self] notification in
                self?.handleUpdate(notification)
            }
            .store(in: &cancellables)
    }

    deinit {
        // Cancellables automatically cancelled
        print("DataViewModel deallocated")
    }
}
```

### Scenario 5: Parent-Child Relationship

```swift
class Parent {
    var children: [Child] = []

    func addChild(_ child: Child) {
        children.append(child)
        child.parent = self  // Parent owns children, children reference parent
    }

    deinit {
        print("Parent deallocated")
    }
}

class Child {
    weak var parent: Parent?  // Weak to prevent cycle

    deinit {
        print("Child deallocated")
    }
}

// Usage:
var parent: Parent? = Parent()
let child1 = Child()
let child2 = Child()

parent?.addChild(child1)
parent?.addChild(child2)

parent = nil
// Output:
// Parent deallocated
// Child deallocated (if no other references)
// Child deallocated
```

### Scenario 6: Cache with Weak References

```swift
class ImageCache {
    private var cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024  // 50 MB
        return cache
    }()

    func store(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func retrieve(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    // NSCache automatically removes objects under memory pressure
    // Objects are not strongly retained beyond memory limits
}
```

### Scenario 7: Debugging with Deinit Logging

```swift
class NetworkManager {
    init() {
        print("✅ NetworkManager init - \(Unmanaged.passUnretained(self).toOpaque())")
    }

    deinit {
        print("🗑️ NetworkManager deinit")
    }
}

class ViewController {
    var networkManager: NetworkManager?

    init() {
        print("✅ ViewController init")
        networkManager = NetworkManager()
    }

    deinit {
        print("🗑️ ViewController deinit")
    }
}

// If you see init without matching deinit = memory leak
// Use memory address from Unmanaged to track specific instances
```

---
name: debugging-basics
description: Debug Swift applications using Xcode debugging tools including breakpoints, LLDB commands, View Debugger, Console, and crash analysis. Use when investigating bugs, crashes, unexpected behavior, or runtime issues in iOS, macOS, watchOS, tvOS, or visionOS applications.
version: 1.0.0
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# Debugging Basics

## What This Skill Does

Provides comprehensive guidance on debugging Swift applications using Xcode's powerful debugging tools. Covers breakpoints, LLDB commands, View Debugger, console output, crash analysis, and common debugging scenarios across all Apple platforms.

## When to Activate

- Investigating crashes or unexpected behavior
- Examining runtime values and state
- Stepping through code execution
- Analyzing UI layout issues
- Debugging memory problems
- Understanding control flow
- Fixing race conditions or concurrency bugs
- Analyzing crash logs and stack traces

## Core Concepts

### Xcode Debugging Tools

Xcode provides integrated debugging tools:

**Breakpoints**: Pause execution at specific locations
**LLDB**: Powerful debugger with command-line interface
**View Debugger**: 3D visualization of view hierarchy
**Console**: View print statements and LLDB output
**Debug Navigator**: Inspect threads, variables, and call stacks
**Instruments**: Profiling tools for performance analysis

### Debug vs Release Builds

**Debug builds**:
- No optimization (easier to debug)
- Debug symbols included
- Assertions enabled
- Slower execution

**Release builds**:
- Optimized code
- Stripped symbols (unless preserved)
- Better performance
- Harder to debug

## Implementation Patterns

### Basic Breakpoints

```swift
func processData(_ items: [Item]) {
    var result: [ProcessedItem] = []

    for item in items {  // Set breakpoint here
        let processed = transform(item)
        result.append(processed)
    }

    return result
}
```

**Setting breakpoints:**
1. Click line number gutter in Xcode
2. Blue arrow appears when breakpoint is set
3. Execution pauses when breakpoint hits
4. Use debug bar to step through code

**Debug bar controls:**
- **Continue** (⌃⌘Y): Resume execution
- **Step Over** (F6): Execute current line
- **Step Into** (F7): Enter function call
- **Step Out** (F8): Exit current function

### Conditional Breakpoints

Pause only when specific conditions are met:

```swift
func processItems(_ items: [Item]) {
    for item in items {
        // Set breakpoint here with condition: item.id == "problem-id"
        process(item)
    }
}
```

**Setting condition:**
1. Right-click breakpoint
2. Select "Edit Breakpoint"
3. Add condition: `item.id == "problem-id"`
4. Breakpoint only triggers when condition is true

### Breakpoint Actions

Execute LLDB commands without stopping:

```swift
func updateBalance(_ amount: Double) {
    balance += amount  // Breakpoint with action
    saveBalance()
}
```

**Useful actions:**
- **Log message**: Print values without editing code
- **Debugger command**: Run LLDB commands
- **Play sound**: Alert when code reaches point
- **Automatically continue**: Don't pause execution

Example action: `po balance` to print current balance

### LLDB Commands

Essential LLDB commands for debugging:

```lldb
# Print object description
(lldb) po myObject
(lldb) po myArray.count
(lldb) po self.username

# Print variable (formatted)
(lldb) p myVariable
(lldb) p/x 255  # Hexadecimal: 0xff
(lldb) p/t 8    # Binary: 0b1000

# Expression evaluation
(lldb) e myVariable = 10
(lldb) e self.isEnabled = false
(lldb) expression -- import UIKit

# Show call stack
(lldb) bt
(lldb) bt all  # All threads

# Thread control
(lldb) thread list
(lldb) thread select 1
(lldb) thread return false  # Return early with value
(lldb) thread jump --by 1   # Skip next line

# Frame control
(lldb) frame variable  # Show local variables
(lldb) frame select 0
(lldb) up  # Move up call stack
(lldb) down  # Move down call stack

# Breakpoints
(lldb) breakpoint list
(lldb) breakpoint delete 1
(lldb) breakpoint disable 2
(lldb) br set -n viewDidLoad  # Set on method name
(lldb) br set -f ViewController.swift -l 42  # File:line

# Continue execution
(lldb) continue
(lldb) c
```

### Symbolic Breakpoints

Break on method/function names across all classes:

```swift
// Break whenever any viewDidLoad is called
// Symbolic breakpoint: viewDidLoad

// Break on specific class method
// Symbolic breakpoint: MyViewController.viewDidLoad

// Break on Swift error throws
// Symbolic breakpoint: Swift runtime failure

// Break on Objective-C exceptions
// Symbolic breakpoint: objc_exception_throw
```

**Common symbolic breakpoints:**
- `UIViewAlertForUnsatisfiableConstraints` - Auto Layout conflicts
- `malloc_error_break` - Memory allocation errors
- `objc_exception_throw` - Objective-C exceptions

### Exception Breakpoints

Automatically break when exceptions occur:

1. Breakpoint Navigator (⌘8)
2. Click '+' button
3. Select "Exception Breakpoint"
4. Configure:
   - Exception: All or Objective-C
   - Break: On Throw
   - Continue after evaluating: Optional

**Critical for finding:**
- Uncaught exceptions
- Crashes before they happen
- Exception source location

### View Debugger

Inspect UI hierarchy in 3D:

```swift
// Any SwiftUI or UIKit view hierarchy
struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello")
            Button("Tap") { }
        }
        .background(.red)  // Debug layout issues
    }
}
```

**Using View Debugger:**
1. Run app and navigate to problematic view
2. Click "Debug View Hierarchy" button (or Debug → View Debugging → Capture View Hierarchy)
3. 3D view shows all layers
4. Rotate and zoom to inspect
5. Select view to see properties

**What to look for:**
- Hidden views blocking touches
- Incorrect frames or bounds
- Constraint conflicts (purple warnings)
- Overlapping views
- Clipped content

### Console Debugging

Strategic print statements:

```swift
func loadData() async {
    print("🔵 loadData started")

    do {
        let data = try await networkService.fetch()
        print("✅ Fetched \(data.count) items")

        await processData(data)
        print("✅ Processing complete")
    } catch {
        print("❌ Error: \(error)")
    }

    print("🔵 loadData finished")
}

// Better: Use OSLog for production
import os

let logger = Logger(subsystem: "com.app.myapp", category: "networking")

func loadData() async {
    logger.info("loadData started")

    do {
        let data = try await networkService.fetch()
        logger.debug("Fetched \(data.count) items")
    } catch {
        logger.error("Failed to load data: \(error.localizedDescription)")
    }
}
```

### Debugging Async Code

Debug async/await and actors:

```swift
func fetchData() async throws -> Data {
    logger.debug("Starting fetch")

    // Set breakpoint here - shows async context
    let (data, response) = try await URLSession.shared.data(from: url)

    logger.debug("Received \(data.count) bytes")

    // Examine response in debugger
    guard let httpResponse = response as? HTTPURLResponse else {
        throw NetworkError.invalidResponse
    }

    // Check status code
    guard (200...299).contains(httpResponse.statusCode) else {
        throw NetworkError.serverError(httpResponse.statusCode)
    }

    return data
}

// Debugging actors
actor DataStore {
    private var cache: [String: Data] = [:]

    func store(_ data: Data, forKey key: String) {
        // Set breakpoint - shows actor isolation context
        cache[key] = data
        print("Stored \(data.count) bytes for key: \(key)")
    }
}
```

**Async debugging tips:**
- Task Local Values visible in debugger
- Actor isolation shown in stack frames
- Use `print()` liberally for state tracking
- Check Task.isCancelled for cancellation issues

### Debugging SwiftUI

SwiftUI debugging techniques:

```swift
struct DebugView: View {
    @State private var count = 0

    var body: some View {
        VStack {
            Text("Count: \(count)")
                .background(.red)  // Visual debugging
                .border(.blue, width: 2)  // Check bounds

            Button("Increment") {
                count += 1
                print("Count is now: \(count)")  // State changes
            }
        }
        .onAppear {
            print("View appeared")  // Lifecycle
        }
        .onChange(of: count) { oldValue, newValue in
            print("Count changed from \(oldValue) to \(newValue)")
        }
        // Force view update to check issue
        .id(UUID())  // Creates new view each time (debugging only!)
    }
}

// Self sizing inspector
struct ContentView: View {
    var body: some View {
        Text("Hello")
            ._printChanges()  // Prints why view updated (debug only)
    }
}
```

### Crash Log Analysis

Understanding crash logs:

```
Exception Type: EXC_BAD_ACCESS (SIGSEGV)
Exception Subtype: KERN_INVALID_ADDRESS at 0x0000000000000010

Thread 0 Crashed:
0   MyApp                  0x000000010234abcd -[ViewController updateLabel] + 42
1   MyApp                  0x000000010234def0 -[ViewController viewDidLoad] + 128
2   UIKitCore              0x00007fff4a123456 -[UIViewController loadViewIfRequired] + 1234

Thread 0 crashed with ARM Thread State (64-bit):
    x0: 0x0000000000000000   x1: 0x00007fff8123456
```

**Analyzing crashes:**
1. **Exception Type**: What went wrong (BAD_ACCESS, breakpoint, assertion)
2. **Crashed Thread**: Which thread crashed (usually Thread 0 = main)
3. **Stack Trace**: Sequence of function calls leading to crash
4. **Symbolication**: Convert addresses to readable function names

**Common exception types:**
- `EXC_BAD_ACCESS`: Accessing deallocated memory (most common)
- `EXC_BREAKPOINT`: Assertion failure or force unwrap of nil
- `EXC_CRASH`: abort() called, often from failed assertion

## Best Practices

1. **Use exception breakpoints** - Catch crashes at the source before they propagate

2. **Master LLDB basics** - `po`, `p`, `bt`, `frame variable` cover 80% of needs

3. **Add strategic logging** - Use OSLog for production, print() for development

4. **Use View Debugger for UI issues** - Faster than guessing layout problems

5. **Set conditional breakpoints** - Only pause for problematic data

6. **Leverage breakpoint actions** - Log without modifying code

7. **Understand the call stack** - Essential for tracing execution flow

8. **Symbolicate crash logs** - Keep debug symbols for release builds

9. **Reproduce consistently** - Fix is easier when you can trigger bug reliably

10. **Use Swift error handling** - Catch errors before they become crashes

## Platform-Specific Considerations

### iOS/iPadOS
- Test on both iPhone and iPad when using size classes
- Check different orientations
- Verify behavior during app backgrounding
- Test with different memory warnings

### macOS
- Coordinate system origin at bottom-left (unlike iOS)
- Multi-window scenarios can reveal state bugs
- Test keyboard shortcuts thoroughly
- Memory management differs (less aggressive)

### watchOS
- Extremely limited debugging (minimal console output)
- Use notifications for debugging breadcrumbs
- Test under severe memory pressure
- Background execution very limited

### tvOS
- Focus-based navigation requires special attention
- Test with Siri Remote and game controllers
- No local storage to debug
- Limited console output

### visionOS
- 3D coordinate debugging more complex
- Eye tracking and gesture debugging
- Spatial relationships need careful verification

## Common Pitfalls

1. **Force unwrapping optionals**
   - ❌ `let name = user!.name` crashes if user is nil
   - ✅ `guard let user = user else { return }`

2. **Ignoring weak references**
   - ❌ Strong reference cycles causing crashes
   - ✅ Use `[weak self]` in closures

3. **Not checking array bounds**
   - ❌ `array[5]` crashes if array has < 6 elements
   - ✅ `guard array.indices.contains(5) else { return }`

4. **Main thread violations**
   - ❌ Updating UI from background thread
   - ✅ Use `@MainActor` or `DispatchQueue.main.async`

5. **Ignoring console warnings**
   - ❌ Purple runtime warnings (constraint conflicts)
   - ✅ Fix warnings immediately

6. **Not using exception breakpoints**
   - ❌ Crashes without knowing where
   - ✅ Exception breakpoint shows exact location

7. **Debugging optimized code**
   - ❌ Variables "optimized out" in release builds
   - ✅ Use debug builds for debugging

8. **Not saving lldb command aliases**
   - ❌ Typing long commands repeatedly
   - ✅ Create aliases in ~/.lldbinit

## Related Skills

- `memory-management` - Debugging memory leaks and retain cycles
- `instruments-profiling` - Performance debugging with Instruments
- `testing-fundamentals` - Preventing bugs through testing
- `swift-6-essentials` - Debugging concurrent code and actors

## Example Scenarios

### Scenario 1: Debugging a Crash

```swift
class UserViewController: UIViewController {
    var user: User!  // Force unwrapped - potential crash

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set exception breakpoint to catch crash here
        nameLabel.text = user.name  // Crashes if user is nil
    }
}

// Fix with proper optional handling
class UserViewController: UIViewController {
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let user = user else {
            logger.error("No user provided")
            dismiss(animated: true)
            return
        }

        nameLabel.text = user.name
    }
}
```

### Scenario 2: LLDB Session Example

```swift
func calculateDiscount(price: Double, couponCode: String?) -> Double {
    var finalPrice = price  // Breakpoint here

    if let code = couponCode {
        let discount = lookupDiscount(code)
        finalPrice -= discount
    }

    return finalPrice
}

// LLDB session at breakpoint:
// (lldb) po price
// 99.99
// (lldb) po couponCode
// Optional("SAVE20")
// (lldb) e let discount = lookupDiscount(couponCode!)
// (lldb) po discount
// 20.0
// (lldb) e finalPrice = price - discount
// (lldb) po finalPrice
// 79.99
// (lldb) thread return 79.99
// Function returns 79.99 immediately
```

### Scenario 3: View Debugger Usage

```swift
struct OverlappingView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 200, height: 200)

            Rectangle()
                .fill(.red)
                .frame(width: 150, height: 150)
                .offset(x: 50)  // Layout issue

            Text("Hidden?")  // Is this visible?
                .foregroundColor(.white)
        }
    }
}

// Steps:
// 1. Run app, show this view
// 2. Debug → View Debugging → Capture View Hierarchy
// 3. Rotate 3D view to see layers
// 4. Select "Hidden?" text view
// 5. Check if other views are blocking it
// 6. Inspect frame/bounds of all elements
```

### Scenario 4: Debugging Async Race Condition

```swift
class DataManager {
    private var cache: [String: Data] = [:]  // Race condition!

    func fetchData(for key: String) async -> Data? {
        // Multiple calls can race here
        if let cached = cache[key] {
            return cached
        }

        let data = await networkFetch(key)
        cache[key] = data  // Race condition: simultaneous writes
        return data
    }
}

// Debug:
// 1. Add print statements
// 2. Run multiple concurrent calls
// 3. See interleaved logs showing race

// Fix with actor:
actor DataManager {
    private var cache: [String: Data] = [:]

    func fetchData(for key: String) async -> Data? {
        print("[\(Thread.current)] Checking cache for \(key)")

        if let cached = cache[key] {
            print("[\(Thread.current)] Cache hit for \(key)")
            return cached
        }

        print("[\(Thread.current)] Fetching \(key)")
        let data = await networkFetch(key)

        print("[\(Thread.current)] Storing \(key)")
        cache[key] = data

        return data
    }
}
```

### Scenario 5: Conditional Breakpoint Example

```swift
func processOrders(_ orders: [Order]) {
    for order in orders {
        // Breakpoint with condition: order.amount > 1000
        // Only pauses for large orders

        let processed = process(order)
        save(processed)
    }
}

// Breakpoint conditions:
// order.amount > 1000
// order.status == .pending
// order.customerId == "ABC123"
// order.items.count > 5
```

### Scenario 6: Memory Debug Logging

```swift
class ViewModel {
    init() {
        print("✅ ViewModel allocated: \(Unmanaged.passUnretained(self).toOpaque())")
    }

    deinit {
        print("🗑️ ViewModel deallocated")
    }
}

// If you see allocation but no deallocation = memory leak
// Use Memory Graph Debugger to find retain cycle
```

### Scenario 7: Auto Layout Debugging

```swift
// Constraint conflict warning in console
func setupConstraints() {
    view.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
        label.widthAnchor.constraint(equalToConstant: 200),
        label.widthAnchor.constraint(equalToConstant: 150),  // Conflict!
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
}

// Console shows:
// [LayoutConstraints] Unable to simultaneously satisfy constraints.
// Probably at least one of the constraints in the following list is one you don't want...

// Solution:
// 1. Read the constraint identifiers in console
// 2. Set symbolic breakpoint: UIViewAlertForUnsatisfiableConstraints
// 3. Examine stack trace to find where constraints are created
// 4. Fix the conflict
```

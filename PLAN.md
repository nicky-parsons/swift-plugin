# Swift/Xcode Multi-Platform Plugin for Claude Code

## Comprehensive Research Report and Implementation Guide

Apple ecosystem developers need instant access to deep knowledge across platforms, frameworks, and best practices. This research establishes a complete framework for building a Claude Code plugin that transforms Claude into an expert Swift/Xcode development assistant, capable of building production-ready multi-platform Apple applications.

**Bottom line:** Claude Code plugins use a simple directory structure with markdown skill files that Claude autonomously invokes based on context. The Swift/Xcode plugin should contain 25-30 focused skills organized into categories covering Swift 6, platform differences, SwiftUI, testing, debugging, and deployment—providing comprehensive guidance while maintaining efficient context usage through progressive disclosure.

## Phase 1: Understanding Claude Code plugin architecture

### The plugin system explained

Claude Code plugins are shareable packages that bundle custom functionality into installable units distributed through Git-based marketplaces. Users install with a single command: `/plugin install plugin-name@marketplace-name`. The system is **lightweight by design**, built on existing Claude Code extension points rather than creating new infrastructure.

Plugins solve the "how do I share my setup" problem by packaging slash commands, subagents, MCP servers, hooks, and most importantly **skills**—modular capabilities that Claude autonomously invokes based on context. Unlike commands that users explicitly trigger, skills work invisibly in the background, activating when Claude determines they're relevant to the task at hand.

### File structure and organization

A Claude Code plugin follows this standard directory layout:

```
swift-xcode-plugin/
├── .claude-plugin/
│   └── plugin.json              # REQUIRED: Metadata
├── skills/                       # Model-invoked capabilities
│   ├── fundamentals/
│   │   ├── swift-6-essentials/
│   │   │   └── SKILL.md
│   │   ├── cross-platform-patterns/
│   │   │   └── SKILL.md
│   │   └── concurrency-safety/
│   │       └── SKILL.md
│   ├── frameworks/
│   │   ├── swiftui-patterns/
│   │   │   └── SKILL.md
│   │   ├── swiftdata-integration/
│   │   │   └── SKILL.md
│   │   └── combine-reactive/
│   │       └── SKILL.md
│   ├── testing/
│   ├── debugging/
│   └── deployment/
├── commands/                     # User-invoked shortcuts
│   ├── new-swiftui-view.md
│   └── review-memory.md
├── hooks/
│   └── hooks.json               # Auto-behavior
└── README.md
```

The **plugin.json** file defines metadata:

```json
{
  "name": "swift-xcode-multiplatform",
  "description": "Expert Swift 6 and multi-platform Apple development skills: SwiftUI, testing, debugging, deployment guidance",
  "version": "1.0.0",
  "author": {
    "name": "Your Name",
    "email": "your@email.com"
  },
  "homepage": "https://github.com/user/swift-plugin",
  "repository": "https://github.com/user/swift-plugin",
  "license": "MIT",
  "keywords": ["swift", "swift6", "swiftui", "xcode", "ios", "macos", "testing", "multiplatform"]
}
```

### How skills work and progressive disclosure

Skills are the heart of a plugin. Each skill lives in its own directory with a mandatory **SKILL.md** file containing YAML frontmatter and Markdown body:

```markdown
---
name: swift-6-data-race-safety
description: Implement Swift 6 data race safety with actors, @MainActor, Sendable protocol, and strict concurrency checking. Use when building concurrent code or migrating to Swift 6.
version: 1.0.0
allowed-tools: Read, Write, Edit, Bash, Grep
---

# Swift 6 Data Race Safety

## What This Skill Does
Guides implementation of Swift 6's compile-time data race safety through proper actor isolation, @MainActor usage, and Sendable conformance.

## When to Use
- Writing concurrent code in Swift 6
- Migrating Swift 5 code to Swift 6 mode
- Fixing data race warnings
- Designing thread-safe architectures

## Core Concepts

**Actor Isolation:** Actors provide mutually exclusive access to mutable state...

## Implementation Patterns

[Detailed patterns with code examples]

## Common Pitfalls
1. Assuming async automatically means concurrent...
2. Using @unchecked Sendable without justification...
```

Skills use **progressive disclosure**: Claude first sees only the `name` and `description` from frontmatter (consuming minimal tokens). If relevant, Claude reads the full SKILL.md. For complex skills, detailed documentation can live in separate files within the skill directory (`references/`, `scripts/`, `assets/`) that Claude accesses only when needed. This keeps context efficient across many installed skills.

The **superpowers** example plugin demonstrates excellent organization: skills grouped by category (testing/, debugging/, collaboration/), descriptive names using lowercase-with-hyphens, and clear descriptions that help Claude select the right skill for each situation.

### Best practices for skill authoring

**Description quality is critical.** Claude uses descriptions to decide when to invoke skills. Compare these:

❌ **Vague:** "Work with SwiftUI views"  
✅ **Specific:** "Build SwiftUI views with proper state management using @State, @Binding, @StateObject, and @ObservedObject. Use when creating UI components, handling user input, or managing view state in SwiftUI applications."

**Keep SKILL.md under 5,000 words.** Move extensive documentation to separate reference files. For the Swift plugin, each skill should focus on one clear objective: Swift 6 migration patterns, SwiftUI lifecycle, testing with XCTest, debugging with LLDB, etc.

**Specify appropriate tools** using the `allowed-tools` field:
- Read-only skills: `Read, Grep, Glob, Bash`
- Code generation: `Read, Write, Edit, Grep, Glob, Bash`
- Analysis only: `Read, Grep, Glob`

**Organize hierarchically** with clear category boundaries. The Swift plugin structure separates fundamentals (Swift 6, platforms, concurrency) from frameworks (SwiftUI, SwiftData, UIKit) from practices (testing, debugging, deployment), preventing overlap while ensuring comprehensive coverage.

## Phase 2: Apple developer ecosystem coverage

### Platform fundamentals and Swift 6

**Swift 6's flagship feature is compile-time data race safety**, making it 30% safer according to Apple's data. The language mode enforces actor isolation, Sendable conformance, and proper concurrency patterns. Key concepts for skill documentation:

**Data race safety implementation:**
- Actor isolation protects mutable state with automatic synchronization
- @MainActor marks UI-related code for main thread execution
- Sendable protocol indicates thread-safe type sharing
- Strict concurrency checking (minimal → targeted → complete migration path)
- nonisolated for methods that don't need actor protection

**Typed throws** (SE-0413) eliminate type erasure in error handling:
```swift
enum CopierError: Error {
    case outOfPaper, jammed
}

func photocopy() throws(CopierError) {
    throw .outOfPaper  // Type inferred
}
```

**Swift 6.2 performance features:**
- InlineArray for stack-allocated fixed-size arrays
- Span type for safe buffer operations
- Pack iteration for variadic generics

**Migration strategy:** Enable upcoming features incrementally, set strict concurrency to minimal/targeted/complete, fix warnings at each level, then switch to Swift 6 mode per module.

**Platform architecture differences** require distinct skills:

**iOS/iPadOS:** Touch-based interaction, UIKit/SwiftUI, mobile constraints (battery, memory), multitasking (Split View, Slide Over), widgets

**macOS:** AppKit/SwiftUI, multiple windows, menu bars, mouse/keyboard/trackpad, full file system access, different coordinate system (bottom-left origin vs top-left)

**watchOS:** Severely constrained (CPU, memory, battery), SwiftUI only (Xcode 14+), Digital Crown navigation, complications, background execution extremely limited, HealthKit integration

**tvOS:** Focus-based navigation (not touch), Siri Remote input, 10-foot UI design, no local storage (iCloud only), no WebViews

**visionOS:** Spatial computing, eye tracking + hand gestures, RealityKit for 3D, Windows/Volumes/Spaces, ARKit for spatial understanding

**Cross-platform strategies** center on SwiftUI with platform-specific adaptations:

```swift
#if os(iOS)
import UIKit
typealias PlatformColor = UIColor
#elseif os(macOS)
import AppKit
typealias PlatformColor = NSColor
#endif
```

Better: Use protocol-oriented abstraction to minimize conditional compilation scattered through code. Create platform adapters that implement common protocols with platform-specific implementations.

### UI/UX design and Liquid Glass

**Apple's Human Interface Guidelines** organize into Platforms, Foundations (color, typography, layout), Patterns (navigation, search, feedback), Components (buttons, toolbars), Inputs (touch, keyboard, gestures), and Technologies (Apple Pay, iCloud).

**Three fundamental design principles:**
- **Clarity:** Legible, precise, easy-to-understand interfaces
- **Deference:** UI helps users focus on content by minimizing clutter
- **Depth:** Visual layers and realistic motion convey hierarchy

**Liquid Glass** is Apple's 2025 design language unifying all platforms. This "digital meta-material" dynamically bends light in real-time, creating translucent surfaces that adapt to surrounding content. Key properties:

**Lensing** provides visual definition through dynamic light bending. Objects materialize in/out by modulating refraction, not fading. **Multiple adaptive layers** work together: highlights respond to geometry and motion, shadows adjust opacity based on background, tint continuously adapts to content, refraction bends underlying content, glow illuminates during interaction.

**When to use Liquid Glass:**
✅ Navigation layers floating above content (tab bars, toolbars, sidebars)  
✅ Buttons, switches, sliders  
✅ System UI (Lock Screen, Control Center, notifications)  
❌ Content layer (tables, lists, scrollable content)—muddies hierarchy  
❌ Glass-on-glass stacking—breaks illusion  
❌ Over-tinting—reduces contrast

Implementation is straightforward:
```swift
// SwiftUI
.background(.liquidGlass)

// UIKit
view.backgroundColor = .liquidGlass
```

**Accessibility is built-in:** Liquid Glass automatically supports Reduced Transparency (frostier), Increased Contrast (black/white with borders), and Reduced Motion (decreased intensity).

**Platform-specific UI patterns** must be respected:

**iOS:** Tab bars at bottom (44pt minimum), hierarchical push navigation, swipe actions, pull-to-refresh, context menus (long press)

**macOS:** Sidebars for navigation, menu bar for global functions, toolbars for context actions, right-click context menus, keyboard shortcuts essential

**watchOS:** Digital Crown for scrolling, full-screen interfaces, complications for watch face, vertical pagination (watchOS 10+), minimal chrome

**tvOS:** Focus-based navigation with parallax effects, tab bars at top, no touch input, 10-foot viewing distance design

**visionOS:** Floating windows in 3D space, ornaments (persistent UI outside windows), eye gaze + pinch gestures, depth and spatial relationships

### Core frameworks mastery

**SwiftUI** is the declarative, compositional UI framework for all Apple platforms. Key architectural concepts:

**State management hierarchy:**
- @State for local view state (internal source of truth)
- @Binding for two-way reference to another view's state
- @StateObject to create and own ObservableObject
- @ObservedObject for externally-owned ObservableObject reference
- @EnvironmentObject for shared objects through view hierarchy
- @Environment for system-provided values

**Best practices:**
- Embrace native SwiftUI patterns (don't force UIKit architectures like VIPER)
- Use Model-View pattern: business logic in models with @Observable
- Break views into small, reusable components without performance penalty
- Keep views under 10 lines when possible by extracting subviews
- Use LazyVStack/LazyHStack for large lists
- Implement Identifiable for efficient list updates

**Platform integration:**
```swift
// UIKit in SwiftUI
struct MapView: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView { MKMapView() }
    func updateUIView(_ uiView: MKMapView, context: Context) { }
}

// SwiftUI in UIKit
let swiftUIView = ContentView()
let hostingController = UIHostingController(rootView: swiftUIView)
```

**SwiftData** provides Swift-native persistence (iOS 17+) built on Core Data:

```swift
@Model
class Trip {
    var name: String
    var startDate: Date
    @Relationship(.cascade) var items: [Item]?
}

// SwiftUI integration
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Trip.self])
    }
}

struct ContentView: View {
    @Query(sort: \.startDate) var trips: [Trip]
    @Environment(\.modelContext) var context
}
```

**MapKit** received major SwiftUI enhancements in iOS 17+:

```swift
Map(position: $position) {
    Marker("Coffee", coordinate: location)
    MapPolyline(coordinates: route)
        .stroke(.blue, lineWidth: 5)
    MapCircle(center: center, radius: 1000)
        .foregroundStyle(.blue.opacity(0.3))
}
.mapControls {
    MapUserLocationButton()
    MapCompass()
}
```

**UIKit** remains relevant for complex UIs, iOS 12 support, and maximum performance. iOS 18 brings SwiftUI animation interoperability and unified gestures. Integration via UIViewRepresentable with Coordinator pattern for stateful components.

**AppKit** for macOS has critical differences: NSWindow is not a view (contains contentView), coordinate origin at bottom-left, layer backing opt-in, window management paramount. Enable layers via `wantsLayer = true` on content view, use animator proxy for animations.

**Combine** provides reactive programming with Publishers, Subscribers, and Operators. Essential patterns:

```swift
@Published var isEnabled: Bool = false

cancellable = viewModel.$isEnabled
    .receive(on: DispatchQueue.main)
    .assign(to: \.isEnabled, on: button)
```

**Always store cancellables:** `var cancellables = Set<AnyCancellable>()`

**Swift Concurrency** (async/await) transforms asynchronous code:

```swift
func fetchData() async throws -> Data {
    let (data, _) = try await URLSession.shared.data(from: url)
    return data
}

// Parallel execution
async let image1 = fetchImage1()
async let image2 = fetchImage2()
return try await (image1, image2)

// Actor for thread safety
actor Counter {
    private var value = 0
    func increment() { value += 1 }
}

// UI updates
@MainActor
class ViewModel: ObservableObject {
    @Published var data: [Item] = []
}
```

**Use Swift Concurrency for I/O-bound work** (network, files, databases). Use GCD for CPU-bound computations. They complement each other.

### Testing, debugging, and quality assurance

**Swift Testing** (WWDC 2024, Xcode 16) modernizes testing with macro-based approach:

```swift
@Test(arguments: [1, 2, 3])
func testValues(_ value: Int) {
    #expect(value > 0)
}

@Test(.tags(.critical), .bug("FB12345"))
func importantTest() async throws {
    let result = await fetchData()
    #expect(result.count > 0)
}
```

**Advantages over XCTest:** Single expressive `#expect` vs XCTAssert family, captures source code and values on failure, parallel execution by default, traits for metadata, Swift 6 native.

**XCTest** still needed for UI testing (XCUITest), performance testing with `measure` blocks, and existing codebases. Best practices: mark test methods as `throws`, use Page Object Model for UI tests, always use accessibility identifiers, wait for elements with `waitForExistence(timeout:)`.

**Test-Driven Development cycle:**
1. **Red:** Write failing test first
2. **Green:** Implement minimal code to pass
3. **Refactor:** Improve code while keeping tests passing

Write tests in order: When, Then, Given. One test per edge case. Test method count should equal or exceed requirement bullet points.

**Xcode debugging tools:**

**Breakpoints:** Line, symbolic (break on method name), exception (auto-break on crashes), conditional, watchpoints. Add actions to execute LLDB commands, play sounds, or log without pausing.

**LLDB commands:**
- `p/po` - Print values
- `expression/e` - Evaluate and modify at runtime
- `thread return` - Override function return
- `thread jump` - Skip code lines
- `bt` - Show call stack

**Memory Graph Debugger** finds retain cycles: Run flows, capture graph, look for purple exclamation marks indicating leaks, trace strong references keeping objects alive.

**View Debugger:** 3D view hierarchy, constraint inspection, color blended layers to identify overdraw.

**Instruments profiling:**

**Time Profiler:** Samples 1000x/second, shows CPU bottlenecks. Enable "Hide System Libraries" and sort by "Self" to find direct bottlenecks.

**Allocations:** Track memory usage. Use generation analysis: perform action multiple times, mark generations, look for unbounded growth between generations.

**Leaks:** Automatically detects memory leaks and retain cycles with red flags and stack traces.

**Network:** Monitor request/response times, data transferred, failed requests. Optimize by reducing frequency, implementing caching, batching operations.

**Memory management patterns:**

```swift
// Delegate - use weak
class Parent {
    weak var delegate: ChildDelegate?
}

// Closure capture - use [weak self]
viewModel.onUpdate = { [weak self] in
    self?.updateUI()
}

// Remove observers
deinit {
    NotificationCenter.default.removeObserver(token)
}
```

**Common leak sources:** Strong delegate references, closure captures without [weak self], notification observers not removed, timers strongly referencing targets.

### Essential development topics

**App lifecycle management** uses SwiftUI's App protocol with ScenePhase for iOS 14+:

```swift
@main
struct MyApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup { ContentView() }
            .onChange(of: scenePhase) { old, new in
                switch new {
                case .background: saveState()
                case .active: refreshData()
                default: break
                }
            }
    }
}
```

**Platform differences:** iOS apps suspend/terminate, macOS apps run until quit, watchOS extremely limited background, tvOS foreground-focused.

**Data persistence strategies:**

**SwiftData** (iOS 17+): `@Model` macro, ModelContainer, @Query for fetching. Best for new projects.

**Core Data:** NSPersistentContainer, NSManagedObjectContext. Still relevant for existing apps and iOS versions below 17. Migration to SwiftData requires matching schemas.

**UserDefaults:** Simple key-value for preferences only. Never store sensitive data.

**Keychain:** Secure storage for credentials. Use appropriate kSecAttrAccessible values:
```swift
kSecAttrAccessibleWhenUnlocked  // Most secure
kSecAttrAccessibleAfterFirstUnlock  // Balanced
kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly  // Requires passcode
```

**Networking with async/await:**

```swift
func fetchData() async throws -> Model {
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
        throw NetworkError.invalidResponse
    }
    
    return try JSONDecoder().decode(Model.self, from: data)
}
```

**Security best practices:**

**Privacy Manifests** (PrivacyInfo.xcprivacy) required iOS 17+ documenting data collection, required reason APIs, third-party SDKs, tracking domains.

**CryptoKit** for modern cryptography: AES-256-GCM symmetric, P256/P384 asymmetric, HKDF key derivation. Never roll your own crypto.

**Certificate pinning** for sensitive apps. Always HTTPS. OAuth 2.0 properly implemented.

**App Store submission requirements:**

**Review process:** 90% reviewed within 24 hours. Complete metadata required: name, description, keywords, screenshots showing app in use, privacy policy link, demo account credentials.

**Common rejections:** Crashes/bugs (2.1), missing privacy policy, unauthorized data collection, intellectual property violations (5.2), misleading metadata (2.3).

**Design requirements:** iPhone apps must run on iPad, support latest SDK (iOS 18 SDK required April 2026), dark mode recommended, accessibility support documented.

**Code signing and provisioning:**

**Certificates:** Development (testing) and Distribution (App Store/Ad Hoc/Enterprise).

**Provisioning profiles** link: App ID + Certificate + Device UUIDs + Entitlements.

Use Xcode automatic signing for simple projects, manual for teams/CI/CD. Store certificates securely, use fastlane match for team management.

**Dependency management:**

**Swift Package Manager (recommended):** Native Xcode integration, no external tools, version-based or branch-based dependencies.

```swift
dependencies: [
    .package(url: "https://github.com/realm/realm-swift.git", from: "10.0.0")
]
```

**CocoaPods:** Established ecosystem, modifies project. **Carthage:** Decentralized, manual integration.

**CloudKit integration:**

Databases: Public (shared across users), Private (user-specific), Shared (collaborative).

**CKSyncEngine** (iOS 17+) simplifies sync with automatic conflict resolution, error handling, background sync.

Best practices: Use custom zones for atomic operations, implement offline support with local caching, handle network errors gracefully, check iCloud availability.

**Push notifications:**

**Local:** App-scheduled with UNUserNotificationCenter, time/calendar/location triggers.

**Remote:** Server-sent via APNs, requires device token registration:

```swift
UIApplication.shared.registerForRemoteNotifications()

func application(_ application: UIApplication,
                didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // Send token to server
}
```

Request permission at appropriate time (not on launch), implement provisional authorization for quiet notifications, use categories for actions.

**Background tasks:**

**Background URL Session** for long downloads/uploads continues even if app terminated:

```swift
let config = URLSessionConfiguration.background(withIdentifier: "unique.id")
config.isDiscretionary = true  // System schedules optimally
let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
```

**BGTaskScheduler** (iOS 13+): BGAppRefreshTask (30 seconds) and BGProcessingTask (minutes) for scheduled operations.

**Finite-length tasks:** `beginBackgroundTask/endBackgroundTask` for up to 30 seconds after backgrounding to complete in-progress work.

## Recommended plugin structure

### Skill organization framework

Based on research and the superpowers example, organize the Swift/Xcode plugin with **25-30 skills** across **7 categories:**

**1. fundamentals/ (6 skills)**
- swift-6-essentials - Language features, migration, data race safety
- swift-6-typed-throws - Error handling patterns
- cross-platform-patterns - Conditional compilation, platform abstraction
- platform-differences - iOS/iPadOS/macOS/watchOS/tvOS/visionOS specifics
- concurrency-safety - Actors, @MainActor, Sendable, async/await
- memory-management - ARC, weak/unowned, leak prevention

**2. ui-design/ (5 skills)**
- human-interface-guidelines - Core HIG principles per platform
- liquid-glass-design - When and how to use Liquid Glass
- swiftui-accessibility - VoiceOver, Dynamic Type, contrast
- platform-ui-patterns - Navigation, interaction models per platform
- design-anti-patterns - Common mistakes to avoid

**3. frameworks/ (7 skills)**
- swiftui-essentials - Views, state management, lifecycle
- swiftui-advanced - Animations, custom views, performance
- swiftdata-persistence - Models, queries, relationships
- mapkit-integration - Maps, annotations, directions
- uikit-appkit-legacy - When to use, migration patterns
- combine-reactive - Publishers, operators, integration
- foundation-networking - URLSession, async patterns, error handling

**4. testing/ (4 skills)**
- swift-testing-framework - @Test, #expect, parameterized tests
- xctest-patterns - Unit tests, mocking, assertions
- ui-testing - XCUITest, Page Object Model, accessibility IDs
- test-driven-development - Red-Green-Refactor cycle, best practices

**5. debugging/ (4 skills)**
- xcode-debugging-tools - Breakpoints, LLDB, view debugger
- instruments-profiling - Time Profiler, Allocations, Leaks
- memory-leak-detection - Memory Graph, retain cycles, analysis
- crash-debugging - Exception types, symbolication, reproduction

**6. deployment/ (4 skills)**
- app-store-submission - Requirements, review process, metadata
- code-signing-provisioning - Certificates, profiles, troubleshooting
- dependency-management - SPM, CocoaPods, version management
- cloudkit-sync - Databases, CKSyncEngine, sharing

**7. security-privacy/ (3 skills)**
- keychain-security - Secure storage, access control
- privacy-manifests - Required reason APIs, documentation
- cryptography-best-practices - CryptoKit, encryption patterns

### Skill template and authoring guidance

Each skill follows this template:

```markdown
---
name: [lowercase-with-hyphens]
description: [What it does, when to use it, key terms for discovery - 2-3 sentences, 50-100 words]
version: 1.0.0
allowed-tools: [Read, Write, Edit, Bash, Grep] or [Read, Grep, Glob, Bash]
---

# [Human-Readable Title]

## What This Skill Does
Clear 2-3 sentence explanation of the skill's purpose and value.

## When to Activate
- User says "implement Swift 6 concurrency"
- Working with actors or @MainActor
- Fixing data race warnings
- Migrating from Swift 5 to Swift 6

## Core Concepts
Essential background knowledge presented clearly:
- **Concept 1:** Explanation with practical context
- **Concept 2:** Why it matters and how it's used

## Implementation Patterns
Concrete, actionable code patterns:

```swift
// Pattern name
actor DataStore {
    private var cache: [String: Data] = [:]
    
    func store(_ data: Data, forKey key: String) {
        cache[key] = data
    }
}
```

Explanation of the pattern, when to use it, and variations.

## Best Practices
Numbered list of specific, actionable recommendations:
1. **Use descriptive actor names** - Convey what state is being protected
2. **Minimize actor boundaries** - Reduce suspension points for performance
3. **Document isolation strategy** - Help future maintainers understand design

## Platform-Specific Considerations
How this differs across iOS/macOS/watchOS/tvOS/visionOS.

## Common Pitfalls
Mistakes developers frequently make:
1. **Assuming async means background** - async doesn't change execution context
2. **Using @unchecked Sendable** - Only use with manual synchronization
3. **Not checking cancellation** - Long-running tasks should check `Task.isCancelled`

## Related Skills
- concurrency-safety - For broader concurrency patterns
- memory-management - Understanding reference semantics with actors

## Example Scenarios
Brief real-world scenarios showing when and how to apply this skill.
```

**Authoring principles:**

**Descriptions must enable discovery.** Include key terms developers might use: "async/await", "actor isolation", "data race", "Sendable protocol", "Swift 6 migration". Be specific about contexts: "Use when implementing concurrent code, migrating to Swift 6, or fixing strict concurrency warnings."

**Keep skills focused.** One clear objective per skill. "swift-6-essentials" covers language basics and migration. "concurrency-safety" goes deep on actors and isolation. "swift-6-typed-throws" focuses specifically on error handling.

**Provide executable patterns.** Every skill should include 3-5 code examples that developers can adapt immediately. Show the pattern, explain it, note when to use it.

**Document anti-patterns explicitly.** Developers learn from mistakes. Show the ❌ wrong way and ✅ correct way side-by-side.

**Link related skills.** Help Claude navigate the knowledge graph by indicating which skills complement each other.

**Progressive detail levels:**
- Frontmatter: Essential discovery metadata (100 tokens)
- Core sections: Immediate practical guidance (2000-3000 words)
- Reference files: Deep dives, advanced patterns, migration guides (external files)

### Command recommendations

Create 5-10 user-invoked commands for common workflows:

**commands/new-swiftui-view.md**
```markdown
---
name: new-swiftui-view
description: Generate a new SwiftUI view with proper structure, state management, and preview
---

Create a new SwiftUI view following best practices:
1. Ask for view name and purpose
2. Determine appropriate state management (@State, @StateObject, etc.)
3. Generate view with:
   - Proper naming (ContentView, not contentView)
   - State properties if needed
   - Basic body structure
   - Xcode preview with sample data
4. Follow SwiftUI conventions
5. Use the swiftui-essentials skill for guidance
```

**commands/review-memory.md** - Analyze code for potential memory leaks
**commands/optimize-performance.md** - Profile and suggest optimizations
**commands/platform-adapt.md** - Convert code for different Apple platforms
**commands/test-coverage.md** - Generate tests for existing code

### Distribution setup

Create marketplace configuration:

```
marketplace/
├── .claude-plugin/
│   └── marketplace.json
└── README.md
```

**marketplace.json:**
```json
{
  "name": "apple-dev-marketplace",
  "owner": {
    "name": "Your Name or Organization"
  },
  "plugins": [
    {
      "name": "swift-xcode-multiplatform",
      "source": "../swift-xcode-plugin",
      "description": "Comprehensive Swift 6 and multi-platform Apple development expertise"
    }
  ]
}
```

Users install with:
```
/plugin marketplace add user/apple-dev-marketplace
/plugin install swift-xcode-multiplatform@apple-dev-marketplace
```

## Key recommendations and next steps

### Development priorities

**Phase 1: Core skills**
Create the essential 10 skills that cover 80% of use cases:
- swift-6-essentials
- swiftui-essentials
- cross-platform-patterns
- testing fundamentals (combine Swift Testing and XCTest)
- debugging-basics (breakpoints, LLDB, common scenarios)
- memory-management
- data-persistence (SwiftData + Core Data)
- networking-patterns
- app-lifecycle
- deployment-essentials

**Phase 2: Specialized skills)**
Add framework-specific and advanced skills:
- Framework deep-dives (MapKit, Combine, UIKit/AppKit)
- Advanced testing and profiling
- Security and privacy
- Platform-specific patterns
- Performance optimization

**Phase 3: Polish and commands**
- Create user commands
- Add session hooks if needed
- Write comprehensive README
- Test on real development scenarios
- Gather feedback and iterate

### Quality standards

**Every skill must:**
- Have discovery-optimized description with key search terms
- Provide 3+ executable code patterns
- Document common pitfalls explicitly
- Include platform-specific considerations
- Stay under 5000 words (move extras to reference files)
- Be testable in isolation

**Code examples must:**
- Compile without errors (verify in Xcode)
- Follow Swift API Design Guidelines
- Use Swift 6 when appropriate
- Show both simple and realistic complexity
- Include comments explaining key decisions

**Documentation must:**
- Use active voice and direct instructions
- Provide specific, actionable guidance
- Explain *why* not just *what*
- Include examples from Apple's own frameworks
- Reference official documentation where appropriate

## Conclusion

This research establishes a complete framework for building a comprehensive Claude Code plugin that transforms Claude into an expert Swift and Xcode development assistant. The plugin architecture is elegantly simple—markdown files in a directory structure—yet powerful through progressive disclosure and autonomous skill activation.

The proposed Swift/Xcode plugin contains 25-30 focused skills organized into seven categories covering fundamentals, UI design, frameworks, testing, debugging, deployment, and security. Each skill follows a consistent template optimized for Claude's discovery and application, with descriptions that enable contextual activation and content structured for progressive detail levels.

Success depends on three factors: **discovery-optimized descriptions** that help Claude find relevant skills, **executable patterns** that developers can apply immediately, and **comprehensive coverage** across the Apple ecosystem without overwhelming individual skill files. The progressive disclosure system ensures efficient context usage even with dozens of installed skills.

The result will be a tool that accelerates Apple platform development for individuals and teams, captures organizational knowledge, and ensures best practices are consistently applied across projects.
By following the structure and principles outlined in this research, you will have created a plugin that serves as a persistent expert assistant for the entire Apple development lifecycle—from initial Swift 6 migration through UI design, testing, debugging, and App Store deployment.

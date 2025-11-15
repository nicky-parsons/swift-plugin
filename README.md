# Swift/Xcode Multi-Platform Plugin for Claude Code

A comprehensive Claude Code plugin that transforms Claude into an expert Swift and Xcode development assistant. Get instant access to deep knowledge across Swift 6, SwiftUI, multi-platform development, testing, debugging, and deployment for all Apple platforms.

## Overview

This plugin provides **23 comprehensive skills** covering the complete Apple development lifecycle from fundamentals to advanced frameworks. Claude autonomously activates these skills based on your development context, providing expert guidance exactly when you need it.

Built following the research and architecture outlined in [PLAN.md](PLAN.md), this plugin implements:
- **Phase 1: Core Skills** (10 skills) - Essential foundation covering 80% of use cases
- **Phase 2: Specialized Skills** (13 skills) - Advanced frameworks, performance, security, and platform-specific patterns

## What This Plugin Provides

### Intelligent, Context-Aware Assistance

Unlike traditional documentation, Claude with this plugin:
- **Understands your code** - Analyzes your project and provides relevant guidance
- **Activates skills automatically** - No need to search for information
- **Provides executable patterns** - Copy-paste-ready code examples
- **Explains the why** - Not just what to do, but why it matters
- **Covers all platforms** - iOS, iPadOS, macOS, watchOS, tvOS, visionOS

### Phase 1: Core Skills (10 Essential Skills)

#### Fundamentals (4 skills)
1. **swift-6-essentials** - Swift 6 language features, data race safety, typed throws, actor isolation, Sendable protocol, and migration strategies
2. **cross-platform-patterns** - Build apps for multiple Apple platforms with conditional compilation, platform abstractions, and adaptive UI
3. **memory-management** - ARC, weak/unowned references, retain cycles, leak prevention, and Memory Graph Debugger
4. **app-lifecycle** - App states, scene phases, background tasks, state preservation across all platforms

#### Frameworks (2 skills)
5. **swiftui-essentials** - Declarative UI with proper state management (@State, @Binding, @Observable), view composition, and performance
6. **networking-patterns** - URLSession with async/await, REST APIs, JSON decoding, error handling, authentication

#### Testing & Debugging (2 skills)
7. **testing-fundamentals** - Swift Testing framework and XCTest, TDD practices, mocking, UI testing, async testing
8. **debugging-basics** - Xcode debugging tools, breakpoints, LLDB commands, View Debugger, crash analysis

#### Deployment (2 skills)
9. **data-persistence** - SwiftData, Core Data, UserDefaults, Keychain, file storage, CloudKit integration
10. **deployment-essentials** - App Store submission, code signing, provisioning, TestFlight, review guidelines

### Phase 2: Specialized Skills (13 Advanced Skills)

#### Advanced Frameworks (5 skills)
11. **combine-reactive** - Reactive programming with Combine: publishers, subscribers, operators, subjects, schedulers, and SwiftUI integration
12. **mapkit-location** - Maps and location services: MapKit, CoreLocation, annotations, geocoding, routing, geofencing
13. **storekit-monetization** - In-app purchases and subscriptions: StoreKit 2, products, transactions, subscriptions, App Store Server API
14. **uikit-appkit-advanced** - Advanced UIKit/AppKit patterns: custom view controllers, collection views, coordinators, custom transitions
15. **realitykit-spatial** - Spatial computing with RealityKit: 3D models, entities, visionOS, AR experiences, spatial audio

#### Performance & Optimization (2 skills)
16. **instruments-profiling** - Performance profiling with Instruments: Time Profiler, Allocations, Leaks, Network, Energy Log
17. **performance-optimization** - App optimization: launch time, memory usage, battery efficiency, scrolling performance, Core Data

#### Security & Privacy (2 skills)
18. **security-patterns** - Security implementation: CryptoKit, Keychain, certificate pinning, biometric authentication, secure data handling
19. **privacy-compliance** - Privacy requirements: Privacy Manifests, App Tracking Transparency, permissions, privacy labels

#### Platform-Specific UI (3 skills)
20. **ios-ui-patterns** - iOS-specific patterns: navigation, tab bars, modals, sheets, swipe actions, context menus
21. **macos-ui-patterns** - macOS-specific patterns: menu bars, toolbars, preferences windows, keyboard shortcuts, multiple windows
22. **watchos-complications** - watchOS complications: WidgetKit, timeline providers, complication families, watch face integration

#### Accessibility (1 skill)
23. **accessibility-implementation** - Accessibility features: VoiceOver, Dynamic Type, labels, hints, assistive technologies

## Installation

### Prerequisites

- Claude Code installed and configured
- Active Apple Developer account (for deployment skills)
- Xcode installed (for development)

### Install from Marketplace

```bash
# Add the marketplace (when available)
/plugin marketplace add <marketplace-name>

# Install the plugin
/plugin install swift-xcode-multiplatform@<marketplace-name>
```

### Manual Installation

```bash
# Clone the repository
git clone https://github.com/user/swift-plugin.git

# Link to Claude Code plugins directory
ln -s $(pwd)/swift-plugin ~/.claude/plugins/swift-xcode-multiplatform
```

## Usage

The plugin works in two ways: **automatic skill activation** based on context, and **user commands** for common tasks.

### User Commands

Invoke these commands by typing them in your conversation:

- `/new-swiftui-view` - Scaffold a new SwiftUI view with proper state management
- `/review-memory` - Analyze code for memory leaks and retain cycles
- `/optimize-performance` - Performance analysis and optimization recommendations
- `/add-tests` - Generate comprehensive test coverage for existing code
- `/fix-accessibility` - Accessibility audit and improvements for VoiceOver and Dynamic Type
- `/setup-storekit` - Complete in-app purchase infrastructure setup

### Automatic Skills & Example Interactions

**Implementing Swift 6 concurrency:**
```
You: "Help me make this class thread-safe for Swift 6"
Claude: [Activates swift-6-essentials skill]
        "I'll help you implement actor isolation for Swift 6 data race safety..."
```

**Building cross-platform UI:**
```
You: "I need this SwiftUI view to work on both iOS and macOS"
Claude: [Activates cross-platform-patterns skill]
        "Here's how to create an adaptive layout that works across platforms..."
```

**Debugging memory issues:**
```
You: "I think I have a retain cycle in my view controller"
Claude: [Activates memory-management skill]
        "Let's identify and fix that retain cycle using Memory Graph Debugger..."
```

**Preparing for App Store:**
```
You: "I'm ready to submit to the App Store. What do I need?"
Claude: [Activates deployment-essentials skill]
        "Here's your complete pre-submission checklist..."
```

## Skill Descriptions

### swift-6-essentials
Master Swift 6's groundbreaking features including compile-time data race safety, typed throws, and strict concurrency. Learn actor isolation, @MainActor, Sendable conformance, and migration strategies from Swift 5.

**Use when:** Writing concurrent code, migrating to Swift 6, fixing data race warnings

### swiftui-essentials
Build modern declarative UIs with SwiftUI. Master state management (@State, @Binding, @StateObject, @Observable), view composition, navigation, forms, animations, and performance optimization.

**Use when:** Creating SwiftUI views, managing state, handling user input, building UIs

### cross-platform-patterns
Develop applications that run seamlessly across iOS, iPadOS, macOS, watchOS, tvOS, and visionOS. Use conditional compilation, protocol abstraction, and adaptive design patterns.

**Use when:** Targeting multiple platforms, adapting existing apps, creating universal code

### testing-fundamentals
Write effective tests using Swift Testing framework and XCTest. Practice TDD, create mocks, write UI tests, and test async code. Achieve comprehensive coverage.

**Use when:** Writing tests, implementing TDD, improving test quality, testing async code

### debugging-basics
Debug effectively using Xcode's powerful tools: breakpoints, LLDB, View Debugger, and console. Analyze crashes, inspect state, and solve runtime issues.

**Use when:** Investigating bugs, crashes, unexpected behavior, UI issues, runtime problems

### memory-management
Manage memory with ARC, prevent retain cycles, use weak/unowned correctly, and debug leaks. Master delegate patterns, closure captures, and the Memory Graph Debugger.

**Use when:** Debugging memory leaks, implementing delegates, using closures, preventing crashes

### data-persistence
Persist data using SwiftData, Core Data, UserDefaults, Keychain, files, and CloudKit. Implement offline-first apps, secure storage, and cross-device sync.

**Use when:** Saving data, caching, storing credentials, implementing offline support, syncing

### networking-patterns
Implement networking with URLSession and async/await. Handle REST APIs, JSON encoding/decoding, authentication, error handling, retries, and caching.

**Use when:** Making HTTP requests, consuming APIs, downloading files, implementing network layers

### app-lifecycle
Manage application lifecycle across platforms. Handle state transitions, background tasks, scene phases, state preservation, and platform-specific behaviors.

**Use when:** Handling app states, saving on background, implementing background tasks, state management

### deployment-essentials
Deploy to the App Store: code signing, provisioning, certificates, TestFlight distribution, App Store Connect, review guidelines, and submission process.

**Use when:** Preparing for submission, setting up certificates, distributing via TestFlight, understanding rejections

## Project Structure

```
swift-xcode-plugin/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── skills/
│   ├── fundamentals/
│   │   ├── swift-6-essentials/
│   │   ├── cross-platform-patterns/
│   │   ├── memory-management/
│   │   └── app-lifecycle/
│   ├── frameworks/
│   │   ├── swiftui-essentials/
│   │   └── networking-patterns/
│   ├── testing/
│   │   └── testing-fundamentals/
│   ├── debugging/
│   │   └── debugging-basics/
│   └── deployment/
│       ├── data-persistence/
│       └── deployment-essentials/
├── commands/                  # Future: User-invoked commands
├── PLAN.md                   # Complete research and architecture
└── README.md                 # This file
```

## Skill Authoring Principles

Each skill follows consistent patterns for maximum effectiveness:

1. **Discovery-optimized descriptions** - Include key terms developers search for
2. **Executable patterns** - 3-5 copy-paste-ready code examples per skill
3. **Platform-specific guidance** - iOS, macOS, watchOS, tvOS, visionOS considerations
4. **Common pitfalls** - ❌ Wrong way vs ✅ Right way comparisons
5. **Best practices** - Actionable, specific recommendations
6. **Related skills** - Navigate the knowledge graph

## Plugin Features

### ✅ Complete Implementation (All 3 Phases)

**Phase 1: Core Skills** (10 skills)
- Essential foundation covering 80% of use cases
- Swift 6, SwiftUI, testing, debugging, deployment

**Phase 2: Specialized Skills** (13 skills)
- Advanced frameworks (Combine, MapKit, StoreKit, UIKit/AppKit, RealityKit)
- Performance optimization and profiling
- Security and privacy patterns
- Platform-specific UI (iOS, macOS, watchOS)
- Accessibility implementation

**Phase 3: Commands & Polish** ✨
- 6 user-invoked commands for common tasks
- Session hook for Swift project detection
- Quick reference guides
- Complete documentation

### What's Next?

The plugin is feature-complete and production-ready! Future enhancements could include:
- Additional specialized skills (ARKit deep-dive, Core ML, HealthKit)
- More automation commands
- IDE integration improvements
- Community-contributed skills

## Contributing

Contributions welcome! This plugin follows the architecture established in PLAN.md.

### Adding a New Skill

1. Create skill directory: `skills/<category>/<skill-name>/`
2. Create `SKILL.md` with YAML frontmatter
3. Follow the skill template in PLAN.md
4. Test skill activation with relevant queries
5. Submit PR with skill documentation

### Improving Existing Skills

1. Keep SKILL.md under 5,000 words
2. Add executable code patterns
3. Document platform differences
4. Include common pitfalls
5. Link related skills

## Requirements

- **macOS**: 12.0+ (for Xcode)
- **Xcode**: 14.0+ (15.0+ for Swift Testing)
- **Swift**: 5.9+ (6.0+ for Swift 6 features)
- **Claude Code**: Latest version

## Supported Platforms

- iOS 14.0+
- iPadOS 14.0+
- macOS 11.0+
- watchOS 7.0+
- tvOS 14.0+
- visionOS 1.0+

## License

MIT License - see LICENSE file for details

## Resources

- [PLAN.md](PLAN.md) - Complete research and implementation guide
- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [Swift Evolution](https://github.com/apple/swift-evolution)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)

## Support

- **Issues**: [GitHub Issues](https://github.com/user/swift-plugin/issues)
- **Discussions**: [GitHub Discussions](https://github.com/user/swift-plugin/discussions)
- **Documentation**: See PLAN.md for detailed architecture

## Acknowledgments

Built following Claude Code plugin architecture and best practices. Based on comprehensive research of Apple's development ecosystem, Swift 6, and modern iOS/macOS development patterns.

---

**Transform Claude into your expert Swift development partner** - Install this plugin and experience intelligent, context-aware assistance across the entire Apple development lifecycle.

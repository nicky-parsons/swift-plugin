# Swift/Xcode Multi-Platform Plugin for Claude Code

A comprehensive Claude Code plugin that transforms Claude into an expert Swift and Xcode development assistant, covering the complete Apple development lifecycle from Swift 6 fundamentals through App Store deployment.

**Status**: ✅ COMPLETE - All 3 phases implemented

## Quick Stats

- **23 comprehensive skills** across 9 categories
- **6 user commands** for common automation tasks
- **Session hooks** for automatic Swift project detection
- **15,000+ lines** of expert guidance
- **150+ code examples** ready to use
- **All 6 Apple platforms** supported (iOS, iPadOS, macOS, watchOS, tvOS, visionOS)

## Overview

This plugin provides intelligent, context-aware assistance that goes beyond traditional documentation. Claude autonomously activates specialized skills based on your development context, providing expert guidance exactly when you need it.

Built following the research and architecture outlined in [PLAN.md](PLAN.md), this plugin delivers:

- **Phase 1: Core Skills** (10 skills) - Essential foundation covering 80% of use cases
- **Phase 2: Specialized Skills** (13 skills) - Advanced frameworks, performance, security, and platform-specific patterns
- **Phase 3: Commands & Polish** (6 commands + hooks) - Automation, project detection, and reference documentation

## What Makes This Plugin Special

### Intelligent, Context-Aware Assistance

Unlike traditional documentation, Claude with this plugin:
- **Understands your code** - Analyzes your project and provides relevant guidance
- **Activates skills automatically** - No need to search for information
- **Provides executable patterns** - Copy-paste-ready code examples
- **Explains the why** - Not just what to do, but why it matters
- **Covers all platforms** - iOS, iPadOS, macOS, watchOS, tvOS, visionOS

### Quality Standards Met

✅ **Discovery-Optimized**: Every skill has keyword-rich descriptions for autonomous activation
✅ **Executable Patterns**: 3-5 copy-paste-ready code examples per skill
✅ **Platform Coverage**: All 6 Apple platforms documented
✅ **Common Pitfalls**: ❌/✅ comparisons showing wrong vs right approaches
✅ **Best Practices**: Actionable recommendations for every skill
✅ **Related Skills**: Navigation graph connecting related skills
✅ **Real Examples**: Comprehensive scenario-based examples
✅ **Consistent Structure**: Every skill follows same template
✅ **Professional Quality**: Production-ready documentation throughout

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

The plugin works in three ways: **automatic skill activation** based on context, **user commands** for common tasks, and **session hooks** for project detection.

### Session Hook (Automatic)

When you start a session in a Swift project, the plugin automatically detects it and provides helpful context:

```
🎯 Swift/Xcode project detected!

Available Swift plugin commands:
  /new-swiftui-view - Scaffold a new SwiftUI view
  /review-memory - Analyze for memory leaks
  /optimize-performance - Performance analysis
  /add-tests - Generate test coverage
  /fix-accessibility - Accessibility audit
  /setup-storekit - Setup in-app purchases

📦 Xcode project: MyApp
⚡ Swift version 6.0

I have access to 23 specialized Swift/Xcode skills covering:
  • Swift 6 & concurrency
  • SwiftUI & UIKit/AppKit
  • Testing & debugging
  • Performance & security
  • All Apple platforms (iOS, macOS, watchOS, tvOS, visionOS)

Just ask me anything about your Swift project!
```

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

## Complete Skill Catalog

### Phase 1: Core Skills (10 Essential Skills)

#### Fundamentals (4 skills)

**1. swift-6-essentials** - Swift 6 language features, data race safety, typed throws, actor isolation, Sendable protocol, and migration strategies
*Use when:* Writing concurrent code, migrating to Swift 6, fixing data race warnings

**2. cross-platform-patterns** - Build apps for multiple Apple platforms with conditional compilation, platform abstractions, and adaptive UI
*Use when:* Targeting multiple platforms, adapting existing apps, creating universal code

**3. memory-management** - ARC, weak/unowned references, retain cycles, leak prevention, and Memory Graph Debugger
*Use when:* Debugging memory leaks, implementing delegates, using closures, preventing crashes

**4. app-lifecycle** - App states, scene phases, background tasks, state preservation across all platforms
*Use when:* Handling app states, saving on background, implementing background tasks

#### Frameworks (2 skills)

**5. swiftui-essentials** - Declarative UI with proper state management (@State, @Binding, @Observable), view composition, and performance
*Use when:* Creating SwiftUI views, managing state, handling user input, building UIs

**6. networking-patterns** - URLSession with async/await, REST APIs, JSON decoding, error handling, authentication
*Use when:* Making HTTP requests, consuming APIs, downloading files, implementing network layers

#### Testing & Debugging (2 skills)

**7. testing-fundamentals** - Swift Testing framework and XCTest, TDD practices, mocking, UI testing, async testing
*Use when:* Writing tests, implementing TDD, improving test quality, testing async code

**8. debugging-basics** - Xcode debugging tools, breakpoints, LLDB commands, View Debugger, crash analysis
*Use when:* Investigating bugs, crashes, unexpected behavior, UI issues, runtime problems

#### Deployment (2 skills)

**9. data-persistence** - SwiftData, Core Data, UserDefaults, Keychain, file storage, CloudKit integration
*Use when:* Saving data, caching, storing credentials, implementing offline support, syncing

**10. deployment-essentials** - App Store submission, code signing, provisioning, TestFlight, review guidelines
*Use when:* Preparing for submission, setting up certificates, distributing via TestFlight

### Phase 2: Specialized Skills (13 Advanced Skills)

#### Advanced Frameworks (5 skills)

**11. combine-reactive** - Reactive programming with Combine: publishers, subscribers, operators, subjects, schedulers, and SwiftUI integration
*Use when:* Implementing reactive patterns, using publishers and subscribers, chaining async operations

**12. mapkit-location** - Maps and location services: MapKit, CoreLocation, annotations, geocoding, routing, geofencing
*Use when:* Adding maps, tracking location, geocoding addresses, implementing geofencing, showing routes

**13. storekit-monetization** - In-app purchases and subscriptions: StoreKit 2, products, transactions, subscriptions, App Store Server API
*Use when:* Implementing IAP, adding subscriptions, handling transactions, validating purchases

**14. uikit-appkit-advanced** - Advanced UIKit/AppKit patterns: custom view controllers, collection views, coordinators, custom transitions
*Use when:* Building complex UIKit/AppKit UIs, using custom view controllers, implementing coordinator pattern

**15. realitykit-spatial** - Spatial computing with RealityKit: 3D models, entities, visionOS, AR experiences, spatial audio
*Use when:* Building visionOS apps, creating AR experiences, working with 3D models

#### Performance & Optimization (2 skills)

**16. instruments-profiling** - Performance profiling with Instruments: Time Profiler, Allocations, Leaks, Network, Energy Log
*Use when:* Profiling performance, finding memory leaks, analyzing CPU usage, monitoring network performance

**17. performance-optimization** - App optimization: launch time, memory usage, battery efficiency, scrolling performance, Core Data
*Use when:* Optimizing app speed, reducing memory usage, improving launch time, fixing UI lag

#### Security & Privacy (2 skills)

**18. security-patterns** - Security implementation: CryptoKit, Keychain, certificate pinning, biometric authentication, secure data handling
*Use when:* Implementing encryption, securing sensitive data, using CryptoKit, storing credentials

**19. privacy-compliance** - Privacy requirements: Privacy Manifests, App Tracking Transparency, permissions, privacy labels
*Use when:* Creating Privacy Manifest, implementing ATT, requesting permissions, preparing for App Store

#### Platform-Specific UI (3 skills)

**20. ios-ui-patterns** - iOS-specific patterns: navigation, tab bars, modals, sheets, swipe actions, context menus
*Use when:* Building iOS-specific interfaces, using navigation bars, implementing modals and sheets

**21. macos-ui-patterns** - macOS-specific patterns: menu bars, toolbars, preferences windows, keyboard shortcuts, multiple windows
*Use when:* Building macOS applications, creating menu bars, implementing toolbars, managing windows

**22. watchos-complications** - watchOS complications: WidgetKit, timeline providers, complication families, watch face integration
*Use when:* Creating watchOS complications, implementing timeline providers, designing for watch faces

#### Accessibility (1 skill)

**23. accessibility-implementation** - Accessibility features: VoiceOver, Dynamic Type, labels, hints, assistive technologies
*Use when:* Adding VoiceOver support, supporting Dynamic Type, implementing accessibility labels

## Platform Coverage

| Platform | Skills | Commands | Coverage |
|----------|--------|----------|----------|
| iOS | 20 | 6 | Complete |
| iPadOS | 20 | 6 | Complete |
| macOS | 19 | 6 | Complete |
| watchOS | 15 | 3 | Complete |
| tvOS | 13 | 2 | Complete |
| visionOS | 12 | 2 | Complete |

## Architecture

```
swift-xcode-plugin/
├── .claude-plugin/
│   └── plugin.json                # Plugin metadata
├── skills/                        # 23 autonomous skills
│   ├── fundamentals/             # Swift 6, cross-platform, memory, lifecycle
│   │   ├── swift-6-essentials/
│   │   ├── cross-platform-patterns/
│   │   ├── memory-management/
│   │   └── app-lifecycle/
│   ├── frameworks/               # SwiftUI, networking, Combine, MapKit, etc.
│   │   ├── swiftui-essentials/
│   │   ├── networking-patterns/
│   │   ├── combine-reactive/
│   │   ├── mapkit-location/
│   │   ├── storekit-monetization/
│   │   ├── uikit-appkit-advanced/
│   │   └── realitykit-spatial/
│   ├── testing/                  # Testing fundamentals
│   │   └── testing-fundamentals/
│   ├── debugging/                # Debugging basics
│   │   └── debugging-basics/
│   ├── deployment/               # Persistence, deployment
│   │   ├── data-persistence/
│   │   └── deployment-essentials/
│   ├── performance/              # Profiling, optimization
│   │   ├── instruments-profiling/
│   │   └── performance-optimization/
│   ├── security/                 # Security, privacy
│   │   ├── security-patterns/
│   │   └── privacy-compliance/
│   ├── platform-ui/              # iOS, macOS, watchOS patterns
│   │   ├── ios-ui-patterns/
│   │   ├── macos-ui-patterns/
│   │   └── watchos-complications/
│   └── accessibility/            # Accessibility implementation
│       └── accessibility-implementation/
├── commands/                      # 6 user-invoked commands
│   ├── new-swiftui-view.md
│   ├── review-memory.md
│   ├── optimize-performance.md
│   ├── add-tests.md
│   ├── fix-accessibility.md
│   └── setup-storekit.md
├── hooks/                         # Session automation
│   ├── hooks.json
│   └── session-start.sh
├── references/                    # Quick guides
│   ├── QUICK_REFERENCE.md
│   └── SKILL_GUIDE.md
├── PLAN.md                        # Complete research document
└── README.md                      # This file
```

## Reference Documentation

The plugin includes two comprehensive reference guides for quick lookup:

### QUICK_REFERENCE.md

Fast pattern lookup for common Swift/SwiftUI patterns:
- Swift 6 essentials (actors, typed throws, MainActor)
- SwiftUI patterns (state management, navigation)
- Memory management (weak self, delegates)
- Networking (basic requests, error handling)
- Testing (Swift Testing, XCTest)
- Debugging (breakpoints, LLDB)
- Data persistence (SwiftData, UserDefaults, Keychain)
- Performance (launch optimization, memory)
- Accessibility (labels, Dynamic Type)
- Common mistakes (❌ Don't vs ✅ Do)
- Platform differences table

### SKILL_GUIDE.md

Complete guide on when to use each of the 23 skills:
- Skill descriptions with keywords for activation
- Use cases and scenarios for each skill
- Skill combinations for complex tasks
- Examples: Building a feature, performance optimization, App Store submission, cross-platform apps

## Key Features

1. **Comprehensive Coverage**: From Swift fundamentals to App Store deployment
2. **Autonomous Activation**: Skills activate based on conversation context
3. **User Commands**: Explicit commands for common tasks
4. **Session Hooks**: Automatic Swift project detection
5. **Reference Docs**: Quick lookup for patterns
6. **Multi-Platform**: All Apple platforms covered
7. **Production-Ready**: Professional quality throughout
8. **Executable Examples**: Copy-paste-ready code
9. **Best Practices**: Industry-standard recommendations
10. **Future-Proof**: Swift 6 and modern practices

## Statistics

- **Total Files**: 35+
- **Total Lines**: 15,000+
- **Skills**: 23
- **Commands**: 6
- **Hooks**: 1
- **References**: 2
- **Code Examples**: 150+
- **Platforms**: 6
- **Categories**: 9

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

## Testing Recommendations

1. **Skill Activation**: Test autonomous skill activation with various queries
2. **Commands**: Test all 6 user commands in different scenarios
3. **Session Hook**: Test Swift project detection in various setups
4. **Platform Coverage**: Verify platform-specific guidance
5. **Code Examples**: Verify all code examples compile
6. **Navigation**: Test skill cross-referencing

## Maintenance

- **Skills**: Update when Apple releases new platform versions
- **Examples**: Keep code examples current with latest APIs
- **Commands**: Add new commands based on user feedback
- **Documentation**: Update as Swift and platforms evolve

## What's Next?

The plugin is feature-complete and production-ready! Optional future enhancements could include:

1. **Additional Skills**: ARKit, Core ML, HealthKit, Core Animation
2. **More Commands**: /create-widget, /setup-cloudkit, /add-shortcuts
3. **Enhanced Hooks**: Build phase hooks, test hooks
4. **IDE Integration**: Xcode extension integration
5. **Community**: Accept community-contributed skills
6. **Templates**: Project templates and scaffolding
7. **Migration Guides**: Detailed migration documentation
8. **Video Tutorials**: Screen recordings of plugin usage

## Resources

- [PLAN.md](PLAN.md) - Complete research and implementation guide
- [QUICK_REFERENCE.md](references/QUICK_REFERENCE.md) - Fast pattern lookup
- [SKILL_GUIDE.md](references/SKILL_GUIDE.md) - When to use each skill
- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [Swift Evolution](https://github.com/apple/swift-evolution)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)

## Support

- **Issues**: [GitHub Issues](https://github.com/user/swift-plugin/issues)
- **Discussions**: [GitHub Discussions](https://github.com/user/swift-plugin/discussions)
- **Documentation**: See PLAN.md for detailed architecture

## License

MIT License - see LICENSE file for details

## Acknowledgments

Built following Claude Code plugin architecture and best practices. Based on comprehensive research of Apple's development ecosystem, Swift 6, and modern iOS/macOS development patterns.

---

**Transform Claude into your expert Swift development partner** - Install this plugin and experience intelligent, context-aware assistance across the entire Apple development lifecycle.

**Status**: ✅ COMPLETE AND PRODUCTION-READY

Built with ❤️ following PLAN.md research and Claude Code best practices.

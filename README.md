# Swift/Xcode Multi-Platform Plugin for Claude Code

Transform Claude into an expert Swift and Xcode development assistant. Get intelligent, context-aware help across the entire Apple development lifecycle - from Swift 6 fundamentals to App Store deployment.

## What This Plugin Does

This plugin gives Claude deep expertise in Swift and Apple platform development through **23 specialized skills** that activate automatically based on your code and questions. Whether you're debugging a memory leak, implementing SwiftUI views, or preparing for App Store submission, Claude provides relevant guidance exactly when you need it.

### Key Benefits

- **Automatic expertise**: Skills activate based on context - no need to search documentation
- **All platforms covered**: iOS, iPadOS, macOS, watchOS, tvOS, and visionOS
- **Modern Swift**: Swift 6 concurrency, data race safety, and latest APIs
- **Production-ready patterns**: Copy-paste code examples that follow best practices
- **Quick automation**: 6 commands for common tasks like adding tests or reviewing memory

## Installation

### Install from GitHub

```shell
# In Claude Code, add the marketplace
/plugin marketplace add nicky-parsons/swift-plugin

# Install the plugin
/plugin install swift-plugin
```

Restart Claude Code after installation.

## How to Use

### Automatic Skills

Just ask Claude about your Swift code and the relevant skills activate automatically:

**Example: Swift 6 Concurrency**
```
You: "Help me make this class thread-safe for Swift 6"
Claude: [Activates swift-6-essentials skill]
        "I'll help you implement actor isolation..."
```

**Example: Cross-Platform UI**
```
You: "Make this SwiftUI view work on iOS and macOS"
Claude: [Activates cross-platform-patterns skill]
        "Here's how to create an adaptive layout..."
```

**Example: Memory Issues**
```
You: "I think I have a retain cycle in my view controller"
Claude: [Activates memory-management skill]
        "Let's identify and fix that retain cycle..."
```

**Example: App Store Submission**
```
You: "I'm ready to submit to the App Store"
Claude: [Activates deployment-essentials skill]
        "Here's your pre-submission checklist..."
```

### Quick Commands

Use these commands for common tasks:

- `/new-swiftui-view` - Scaffold a SwiftUI view with proper state management
- `/review-memory` - Analyze code for memory leaks and retain cycles
- `/optimize-performance` - Get performance analysis and recommendations
- `/add-tests` - Generate comprehensive test coverage
- `/fix-accessibility` - Audit and improve accessibility
- `/setup-storekit` - Set up in-app purchase infrastructure

### Project Detection

When you open a Swift project, the plugin automatically welcomes you:

```
🎯 Swift/Xcode project detected!

Available commands:
  /new-swiftui-view - Scaffold a new SwiftUI view
  /review-memory - Analyze for memory leaks
  /optimize-performance - Performance analysis
  ...

📦 Xcode project: MyApp
⚡ Swift version 6.0
```

## What's Included

### Core Skills (10)

**Fundamentals**
- **swift-6-essentials** - Swift 6 features, concurrency, data race safety, actor isolation
- **cross-platform-patterns** - Multi-platform development for all Apple devices
- **memory-management** - ARC, retain cycles, leak prevention
- **app-lifecycle** - App states, background tasks, state preservation

**Frameworks**
- **swiftui-essentials** - Declarative UI, state management, navigation
- **networking-patterns** - URLSession, async/await, REST APIs, JSON

**Testing & Debugging**
- **testing-fundamentals** - Swift Testing, XCTest, TDD, mocking
- **debugging-basics** - Xcode debugging, breakpoints, LLDB, crash analysis

**Deployment**
- **data-persistence** - SwiftData, Core Data, Keychain, CloudKit
- **deployment-essentials** - App Store submission, code signing, TestFlight

### Advanced Skills (13)

**Advanced Frameworks**
- **combine-reactive** - Reactive programming with Combine
- **mapkit-location** - Maps and location services
- **storekit-monetization** - In-app purchases and subscriptions
- **uikit-appkit-advanced** - Advanced UIKit/AppKit patterns
- **realitykit-spatial** - Spatial computing for visionOS and AR

**Performance & Security**
- **instruments-profiling** - Performance profiling with Instruments
- **performance-optimization** - App speed, memory, battery optimization
- **security-patterns** - CryptoKit, Keychain, certificate pinning
- **privacy-compliance** - Privacy Manifests, App Tracking Transparency

**Platform-Specific**
- **ios-ui-patterns** - iOS-specific interface patterns
- **macos-ui-patterns** - macOS menus, toolbars, windows
- **watchos-complications** - watchOS complications and widgets

**Accessibility**
- **accessibility-implementation** - VoiceOver, Dynamic Type, assistive tech

## Platform Support

| Platform | Version | Coverage |
|----------|---------|----------|
| iOS | 14.0+ | Complete |
| iPadOS | 14.0+ | Complete |
| macOS | 11.0+ | Complete |
| watchOS | 7.0+ | Complete |
| tvOS | 14.0+ | Complete |
| visionOS | 1.0+ | Complete |

## Requirements

- **Claude Code**: Latest version
- **Xcode**: 14.0+ (15.0+ recommended for Swift Testing)
- **Swift**: 5.9+ (6.0+ for Swift 6 features)
- **macOS**: 12.0+

## Contributing

Contributions welcome! To add a skill or improve existing ones:

1. Create skill directory: `skills/<category>/<skill-name>/`
2. Add `SKILL.md` following the template in PLAN.md
3. Test skill activation with relevant queries
4. Submit a pull request

## Support

- **Issues**: [GitHub Issues](https://github.com/nicky-parsons/swift-plugin/issues)
- **Discussions**: [GitHub Discussions](https://github.com/nicky-parsons/swift-plugin/discussions)

## License

MIT License - see LICENSE file for details

---

**Ready to get started?** Install the plugin and ask Claude anything about your Swift project.

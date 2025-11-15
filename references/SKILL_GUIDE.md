# Skill Selection Guide

When to use each of the 23 plugin skills.

## Fundamentals (4 skills)

### swift-6-essentials
**Use when:**
- Migrating to Swift 6
- Fixing data race warnings
- Implementing actors or async/await
- Understanding Sendable protocol
- Using typed throws

**Keywords:** actor, @MainActor, Sendable, data race, concurrency, typed throws

### cross-platform-patterns
**Use when:**
- Building for multiple platforms (iOS + macOS, etc.)
- Using conditional compilation (`#if os(iOS)`)
- Creating platform abstractions
- Handling platform-specific UI or behavior

**Keywords:** cross-platform, multi-platform, iOS, macOS, watchOS, tvOS, visionOS, conditional compilation

### memory-management
**Use when:**
- Debugging memory leaks
- Understanding ARC
- Fixing retain cycles
- Using weak/unowned references
- Implementing delegates with proper memory semantics

**Keywords:** retain cycle, memory leak, weak, unowned, ARC, deinit

### app-lifecycle
**Use when:**
- Handling app state transitions
- Implementing background tasks
- Saving state when app backgrounds
- Understanding scene phases
- Managing app lifecycle events

**Keywords:** lifecycle, background, foreground, scene phase, state preservation

## Frameworks (7 skills)

### swiftui-essentials
**Use when:**
- Building SwiftUI views
- Managing state (@State, @Binding, @Observable)
- Creating navigation
- Using SwiftUI modifiers and view composition

**Keywords:** SwiftUI, @State, @Binding, @Observable, navigation, List, Form

### networking-patterns
**Use when:**
- Making HTTP requests
- Consuming REST APIs
- Handling JSON encoding/decoding
- Implementing authentication
- Managing network errors

**Keywords:** URLSession, HTTP, REST API, JSON, networking, async/await

### combine-reactive
**Use when:**
- Implementing reactive patterns
- Using publishers and subscribers
- Chaining asynchronous operations
- Integrating with @Published in SwiftUI

**Keywords:** Combine, publisher, subscriber, reactive, @Published, operators

### mapkit-location
**Use when:**
- Adding maps to your app
- Tracking user location
- Geocoding addresses
- Implementing geofencing
- Showing routes/directions

**Keywords:** MapKit, CoreLocation, map, location, GPS, geocoding, routing

### storekit-monetization
**Use when:**
- Implementing in-app purchases
- Adding subscriptions
- Handling transactions
- Validating purchases
- Managing subscription status

**Keywords:** StoreKit, in-app purchase, IAP, subscription, monetization

### uikit-appkit-advanced
**Use when:**
- Building complex UIKit/AppKit UIs
- Using custom view controllers
- Implementing coordinator pattern
- Creating custom collection view layouts

**Keywords:** UIKit, AppKit, UIViewController, NSViewController, coordinator

### realitykit-spatial
**Use when:**
- Building visionOS apps
- Creating AR experiences
- Working with 3D models
- Implementing spatial audio

**Keywords:** RealityKit, visionOS, AR, 3D, spatial computing, Reality Composer

## Testing & Debugging (2 skills)

### testing-fundamentals
**Use when:**
- Writing unit tests
- Implementing TDD
- Creating mocks and test doubles
- Testing async code
- Using Swift Testing or XCTest

**Keywords:** testing, XCTest, Swift Testing, TDD, mock, @Test

### debugging-basics
**Use when:**
- Investigating crashes
- Using breakpoints
- Running LLDB commands
- Using View Debugger
- Analyzing crash logs

**Keywords:** debugging, breakpoint, LLDB, crash, View Debugger

## Performance (2 skills)

### instruments-profiling
**Use when:**
- Profiling performance
- Finding memory leaks with Instruments
- Analyzing CPU usage
- Monitoring network performance
- Checking battery impact

**Keywords:** Instruments, profiling, Time Profiler, Allocations, Leaks

### performance-optimization
**Use when:**
- Optimizing app speed
- Reducing memory usage
- Improving launch time
- Fixing UI lag
- Optimizing battery consumption

**Keywords:** performance, optimization, speed, memory, battery, launch time

## Security & Privacy (2 skills)

### security-patterns
**Use when:**
- Implementing encryption
- Securing sensitive data
- Using CryptoKit
- Storing credentials in Keychain
- Certificate pinning

**Keywords:** security, encryption, CryptoKit, Keychain, certificate pinning

### privacy-compliance
**Use when:**
- Creating Privacy Manifest
- Implementing App Tracking Transparency
- Requesting permissions
- Preparing for App Store submission
- GDPR compliance

**Keywords:** privacy, Privacy Manifest, ATT, permissions, GDPR

## Deployment (2 skills)

### data-persistence
**Use when:**
- Saving data locally
- Using SwiftData or Core Data
- Storing preferences
- Implementing CloudKit sync
- Securing stored data

**Keywords:** persistence, SwiftData, Core Data, UserDefaults, Keychain, CloudKit

### deployment-essentials
**Use when:**
- Preparing for App Store submission
- Setting up code signing
- Using TestFlight
- Understanding review guidelines
- Handling rejections

**Keywords:** App Store, submission, code signing, TestFlight, review, provisioning

## Platform-Specific UI (3 skills)

### ios-ui-patterns
**Use when:**
- Building iOS-specific interfaces
- Using navigation bars, tab bars
- Implementing modals and sheets
- Following iOS HIG

**Keywords:** iOS, navigation bar, tab bar, modal, sheet, swipe actions

### macos-ui-patterns
**Use when:**
- Building macOS applications
- Creating menu bars
- Implementing toolbars
- Managing multiple windows
- Following macOS HIG

**Keywords:** macOS, menu bar, toolbar, preferences, keyboard shortcuts

### watchos-complications
**Use when:**
- Creating watchOS complications
- Implementing timeline providers
- Designing for watch faces
- Using WidgetKit for watchOS

**Keywords:** watchOS, complications, WidgetKit, watch face

## Accessibility (1 skill)

### accessibility-implementation
**Use when:**
- Adding VoiceOver support
- Supporting Dynamic Type
- Implementing accessibility labels
- Testing with assistive technologies
- Following WCAG guidelines

**Keywords:** accessibility, VoiceOver, Dynamic Type, a11y, assistive

## Skill Combinations

Common skill combinations for complex tasks:

### Building a Feature
1. `swiftui-essentials` - Create UI
2. `networking-patterns` - Fetch data
3. `data-persistence` - Cache locally
4. `testing-fundamentals` - Add tests

### Performance Optimization
1. `instruments-profiling` - Identify issues
2. `performance-optimization` - Apply fixes
3. `memory-management` - Fix leaks
4. `testing-fundamentals` - Verify improvements

### App Store Submission
1. `deployment-essentials` - Prepare submission
2. `privacy-compliance` - Privacy requirements
3. `accessibility-implementation` - A11y review
4. `testing-fundamentals` - Final testing

### Cross-Platform App
1. `cross-platform-patterns` - Platform abstraction
2. `swiftui-essentials` - Adaptive UI
3. `ios-ui-patterns` - iOS specifics
4. `macos-ui-patterns` - macOS specifics

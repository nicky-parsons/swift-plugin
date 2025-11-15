---
name: ios-ui-patterns
description: iOS-specific UI patterns including navigation bars, tab bars, modals, sheets, action sheets, context menus, pull-to-refresh, swipe actions, and iOS design patterns following Human Interface Guidelines. Use when building iOS-specific interfaces or following iOS conventions.
version: 1.0.0
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# iOS UI Patterns

## What This Skill Does

iOS-specific user interface patterns and conventions following Apple's Human Interface Guidelines for iPhone and iPad.

## When to Activate

- Building iOS-specific UI
- Implementing navigation patterns
- Adding iOS-standard controls
- Following HIG guidelines
- Creating modals and sheets
- Implementing gestures

## iOS-Specific Patterns

### Navigation

```swift
// Navigation Stack (iOS 16+)
NavigationStack {
    List(items) { item in
        NavigationLink(value: item) {
            ItemRow(item: item)
        }
    }
    .navigationDestination(for: Item.self) { item in
        DetailView(item: item)
    }
    .navigationTitle("Items")
    .navigationBarTitleDisplayMode(.large)
}
```

### Tab Bar

```swift
TabView {
    HomeView()
        .tabItem {
            Label("Home", systemImage: "house")
        }

    SearchView()
        .tabItem {
            Label("Search", systemImage: "magnifyingglass")
        }

    ProfileView()
        .tabItem {
            Label("Profile", systemImage: "person")
        }
}
```

### Modals and Sheets

```swift
struct ContentView: View {
    @State private var showSheet = false
    @State private var showFullScreen = false

    var body: some View {
        Button("Show Sheet") {
            showSheet = true
        }
        .sheet(isPresented: $showSheet) {
            SheetView()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }

        Button("Show Full Screen") {
            showFullScreen = true
        }
        .fullScreenCover(isPresented: $showFullScreen) {
            FullScreenView()
        }
    }
}
```

### Context Menus

```swift
Text("Long press me")
    .contextMenu {
        Button("Copy", action: copy)
        Button("Share", action: share)
        Button("Delete", role: .destructive, action: delete)
    }
```

### Swipe Actions

```swift
List {
    ForEach(items) { item in
        Text(item.name)
            .swipeActions(edge: .trailing) {
                Button("Delete", role: .destructive) {
                    delete(item)
                }
                Button("Archive") {
                    archive(item)
                }
            }
            .swipeActions(edge: .leading) {
                Button("Pin") {
                    pin(item)
                }
            }
    }
}
```

## Best Practices

1. **Follow HIG** - Apple's Human Interface Guidelines
2. **Use system icons** - SF Symbols for consistency
3. **Support Dynamic Type** - Scalable text
4. **Test orientations** - Portrait and landscape
5. **Safe areas** - Respect notch and home indicator
6. **Haptic feedback** - Enhance interactions
7. **Accessibility** - VoiceOver, labels, hints
8. **Dark mode** - Support both appearances
9. **iPad multitasking** - Split View, Slide Over
10. **Keyboard shortcuts** - iPad with keyboard

## Related Skills

- `swiftui-essentials` - Core SwiftUI
- `cross-platform-patterns` - iOS vs other platforms
- `accessibility-implementation` - Accessibility
- `uikit-appkit-advanced` - UIKit patterns

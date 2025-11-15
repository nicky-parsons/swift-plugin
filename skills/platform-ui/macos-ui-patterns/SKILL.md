---
name: macos-ui-patterns
description: macOS-specific UI patterns including menu bars, toolbars, popovers, preferences windows, multiple windows, keyboard shortcuts, and AppKit integration. Use when building macOS applications or implementing macOS-specific interfaces following macOS Human Interface Guidelines.
version: 1.0.0
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# macOS UI Patterns

## What This Skill Does

macOS-specific interface patterns including menus, toolbars, preferences, and window management following macOS Human Interface Guidelines.

## When to Activate

- Building macOS applications
- Implementing menu bars
- Creating toolbars
- Multiple window management
- Preferences/Settings windows
- Keyboard shortcuts

## macOS-Specific Patterns

### Menu Bar Commands

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Document") {
                    createDocument()
                }
                .keyboardShortcut("N", modifiers: .command)
            }

            CommandMenu("Edit") {
                Button("Find") {
                    find()
                }
                .keyboardShortcut("F", modifiers: .command)
            }
        }
    }
}
```

### Toolbar

```swift
struct ContentView: View {
    var body: some View {
        NavigationSplitView {
            SidebarView()
        } detail: {
            DetailView()
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar) {
                    Image(systemName: "sidebar.left")
                }
            }

            ToolbarItem {
                Button(action: newItem) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}
```

### Settings Window

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        Settings {
            SettingsView()
        }
    }
}

struct SettingsView: View {
    var body: some View {
        TabView {
            GeneralSettings()
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }

            AdvancedSettings()
                .tabItem {
                    Label("Advanced", systemImage: "slider.horizontal.3")
                }
        }
        .frame(width: 450, height: 300)
    }
}
```

## Best Practices

1. **Menu bar** - Standard File, Edit, View, Window, Help
2. **Keyboard shortcuts** - Follow conventions (⌘N, ⌘S, etc.)
3. **Window management** - Support multiple windows
4. **Toolbar customization** - Allow user customization
5. **Touch Bar** - Optional support
6. **Popovers** - Contextual UI
7. **Preferences** - Settings menu item
8. **About window** - Application → About
9. **Help menu** - Searchable help
10. **Full keyboard access** - Tab navigation

## Related Skills

- `swiftui-essentials` - Core SwiftUI
- `cross-platform-patterns` - macOS vs iOS
- `uikit-appkit-advanced` - AppKit patterns
- `accessibility-implementation` - macOS accessibility

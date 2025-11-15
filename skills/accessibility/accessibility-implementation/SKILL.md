---
name: accessibility-implementation
description: Implement accessibility features including VoiceOver support, Dynamic Type, accessibility labels, hints, traits, custom actions, and UIAccessibility API. Use when making apps accessible to users with disabilities, ensuring VoiceOver compatibility, or supporting assistive technologies.
version: 1.0.0
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# Accessibility Implementation

## What This Skill Does

Comprehensive guide to implementing accessibility features for users with disabilities, including VoiceOver, Dynamic Type, and assistive technology support.

## When to Activate

- Implementing VoiceOver support
- Supporting Dynamic Type
- Adding accessibility labels
- Testing with assistive technologies
- Ensuring WCAG compliance
- Making custom controls accessible

## Core Accessibility Features

### VoiceOver

Screen reader for blind and low-vision users
- Reads interface aloud
- Gesture-based navigation
- Requires proper labels and hints

### Dynamic Type

User-controlled text sizing
- Supports text size preferences
- Range from xSmall to AX5
- Must use scalable fonts

### Other Features

- Reduce Motion
- Increase Contrast
- Differentiate Without Color
- Button Shapes
- On/Off Labels

## Implementation Patterns

### Accessibility Labels (SwiftUI)

```swift
// Good label
Image(systemName: "trash")
    .accessibilityLabel("Delete")

// Button with clear label
Button(action: save) {
    Image(systemName: "square.and.arrow.down")
}
.accessibilityLabel("Save document")

// Custom view
struct ProfileImage: View {
    let user: User

    var body: some View {
        AsyncImage(url: user.avatarURL)
            .accessibilityLabel("Profile picture for \(user.name)")
    }
}
```

### Accessibility Hints

```swift
// Provide context for action
Button("Submit") {
    submitForm()
}
.accessibilityLabel("Submit form")
.accessibilityHint("Sends your information to the server")

// For complex gestures
Image(artwork)
    .accessibilityLabel("Artwork by Vincent van Gogh")
    .accessibilityHint("Double tap to view full size")
```

### Dynamic Type Support

```swift
// ✅ Scalable text
Text("Hello, World!")
    .font(.body)  // Scales with user preference

Text("Important")
    .font(.title)  // Scales appropriately

// Custom font with scaling
Text("Custom")
    .font(.custom("MyFont", size: 17, relativeTo: .body))

// ❌ Fixed size (accessibility issue)
Text("Fixed")
    .font(.system(size: 17))  // Doesn't scale!

// Check current size category
@Environment(\.sizeCategory) var sizeCategory

if sizeCategory >= .accessibilityMedium {
    // Adjust layout for large text
    VStack {
        content
    }
} else {
    HStack {
        content
    }
}
```

### Custom Actions

```swift
// Multiple actions on single element
struct EmailRow: View {
    let email: Email

    var body: some View {
        Text(email.subject)
            .accessibilityLabel("Email from \(email.sender)")
            .accessibilityActions {
                Button("Reply") {
                    reply(email)
                }

                Button("Mark as Read") {
                    markRead(email)
                }

                Button("Delete", role: .destructive) {
                    delete(email)
                }
            }
    }
}
```

### Grouping Elements

```swift
// Group related elements
HStack {
    Image(systemName: "star.fill")
    Text("4.5")
    Text("(120 reviews)")
}
.accessibilityElement(children: .combine)
.accessibilityLabel("Rating: 4.5 stars from 120 reviews")
```

### UIKit Accessibility

```swift
class CustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAccessibility()
    }

    private func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityLabel = "Submit form"
        accessibilityHint = "Submits your information"
        accessibilityTraits = .button
    }
}

// Custom control
class RatingControl: UIControl {
    var rating: Int = 0 {
        didSet {
            updateAccessibility()
        }
    }

    private func updateAccessibility() {
        accessibilityValue = "\(rating) out of 5 stars"
    }
}
```

### Testing Accessibility

```swift
// Enable Accessibility Inspector in Xcode
// Simulator → Accessibility Inspector

// Programmatic check
if UIAccessibility.isVoiceOverRunning {
    // Adjust behavior for VoiceOver
}

if UIAccessibility.isBoldTextEnabled {
    // Use bold text
}

if UIAccessibility.isReduceMotionEnabled {
    // Reduce or eliminate animations
}

// Listen for changes
NotificationCenter.default.addObserver(
    forName: UIAccessibility.voiceOverStatusDidChangeNotification,
    object: nil,
    queue: .main
) { _ in
    // VoiceOver status changed
}
```

## Best Practices

1. **Label all interactive elements** - Buttons, images, controls
2. **Provide meaningful labels** - Describe purpose, not appearance
3. **Use hints sparingly** - Only when action isn't obvious
4. **Support Dynamic Type** - Use scalable fonts
5. **Test with VoiceOver** - Actually use it
6. **Group related elements** - Reduce clutter
7. **Provide text alternatives** - For images and icons
8. **Support reduce motion** - Respect user preference
9. **Ensure sufficient contrast** - 4.5:1 minimum for text
10. **Keyboard navigation** - iPad and macOS

## Common Pitfalls

1. **Missing labels**
   - ❌ Icon button without label
   - ✅ `.accessibilityLabel("Menu")`

2. **Poor label quality**
   - ❌ "Button" or "Image"
   - ✅ "Submit form" or "Profile picture"

3. **Fixed font sizes**
   - ❌ `.font(.system(size: 14))`
   - ✅ `.font(.body)`

4. **Not testing**
   - ❌ Never enabling VoiceOver
   - ✅ Regular testing with assistive technologies

5. **Inaccessible custom controls**
   - ❌ Custom slider without accessibility
   - ✅ Proper traits, values, and actions

6. **Image-only information**
   - ❌ Critical info in image
   - ✅ Text alternative provided

7. **Low contrast**
   - ❌ Light gray on white
   - ✅ Sufficient contrast ratios

8. **Motion for critical info**
   - ❌ Only showing info via animation
   - ✅ Static alternative available

## Related Skills

- `swiftui-essentials` - Accessibility modifiers
- `uikit-appkit-advanced` - UIAccessibility API
- `ios-ui-patterns` - Accessible iOS patterns
- `testing-fundamentals` - Accessibility testing

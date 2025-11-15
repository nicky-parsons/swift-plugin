---
description: Audit and improve accessibility for VoiceOver, Dynamic Type, and assistive technologies
---

You are performing an accessibility audit and improvements. Please:

1. **Audit the code for accessibility issues:**
   - Missing accessibility labels on interactive elements
   - Images without descriptive labels
   - Buttons with unclear purposes
   - Custom controls without proper traits
   - Fixed font sizes (not using Dynamic Type)
   - Poor color contrast
   - Missing hints for complex interactions
   - Unlabeled form fields

2. **Check SwiftUI views for:**
   - `.accessibilityLabel()` on images and icons
   - `.accessibilityHint()` where actions aren't obvious
   - `.accessibilityValue()` for dynamic content
   - Proper use of `.font()` with scalable text styles
   - `.accessibilityElement(children: .combine)` for grouping
   - `.accessibilityActions()` for custom actions

3. **Check UIKit/AppKit for:**
   - `isAccessibilityElement` set correctly
   - `accessibilityLabel` on all interactive elements
   - `accessibilityHint` for non-obvious actions
   - `accessibilityTraits` properly set
   - `accessibilityValue` for dynamic content
   - Dynamic Type support with `.preferredFont`

4. **Provide fixes for:**
   - All identified issues with code examples
   - Priority ranking (Critical/Important/Nice-to-have)
   - VoiceOver experience description
   - Dynamic Type testing recommendations

5. **Suggest:**
   - Testing with VoiceOver (⌘F5 to toggle)
   - Testing with different text sizes
   - Accessibility Inspector usage
   - Color contrast checking

6. **Deliver:**
   - List of accessibility issues with line numbers
   - Fixed code for each issue
   - VoiceOver user experience explanation
   - Testing checklist

Activate the `accessibility-implementation` skill for comprehensive accessibility improvements.

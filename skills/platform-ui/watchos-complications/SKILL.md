---
name: watchos-complications
description: Create Apple Watch complications using WidgetKit for watch faces including circular, rectangular, corner, and inline families. Implement timeline providers, update strategies, and complication design. Use when building watchOS apps with complications or providing glanceable information on watch faces.
version: 1.0.0
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# watchOS Complications

## What This Skill Does

Guide to creating Apple Watch complications using WidgetKit, providing glanceable information on watch faces across multiple complication families.

## When to Activate

- Creating watchOS complications
- Implementing timeline providers
- Designing for watch faces
- Providing glanceable data
- Updating complication data

## Complication Families

- **Circular**: Small, Medium
- **Rectangular**: Standard
- **Corner**: Short, Circular
- **Inline**: Extra Large (watchOS 9+)
- **Graphic**: Corner, Circular, Rectangular, Extra Large

## Implementation Patterns

### Basic Complication

```swift
import WidgetKit
import SwiftUI

struct StepsWidget: Widget {
    let kind = "StepsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StepsProvider()) { entry in
            StepsEntryView(entry: entry)
        }
        .configurationDisplayName("Steps")
        .description("View your daily step count")
        .supportedFamilies([
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryInline
        ])
    }
}

struct StepsEntry: TimelineEntry {
    let date: Date
    let steps: Int
}

struct StepsProvider: TimelineProvider {
    func placeholder(in context: Context) -> StepsEntry {
        StepsEntry(date: Date(), steps: 5000)
    }

    func getSnapshot(in context: Context, completion: @escaping (StepsEntry) -> Void) {
        let entry = StepsEntry(date: Date(), steps: 7500)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<StepsEntry>) -> Void) {
        Task {
            let steps = await fetchSteps()
            let entry = StepsEntry(date: Date(), steps: steps)

            let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))

            completion(timeline)
        }
    }

    func fetchSteps() async -> Int {
        // Fetch from HealthKit
        return 8234
    }
}
```

### Multi-Family Views

```swift
struct StepsEntryView: View {
    @Environment(\.widgetFamily) var family
    let entry: StepsEntry

    var body: some View {
        switch family {
        case .accessoryCircular:
            CircularView(steps: entry.steps)

        case .accessoryRectangular:
            RectangularView(steps: entry.steps)

        case .accessoryInline:
            InlineView(steps: entry.steps)

        default:
            Text("\(entry.steps)")
        }
    }
}

struct CircularView: View {
    let steps: Int

    var body: some View {
        Gauge(value: Double(steps), in: 0...10000) {
            Image(systemName: "figure.walk")
        } currentValueLabel: {
            Text("\(steps)")
        }
        .gaugeStyle(.accessoryCircular)
    }
}

struct RectangularView: View {
    let steps: Int

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Steps")
                    .font(.caption2)
                Text("\(steps)")
                    .font(.title3)
            }
            Spacer()
            Image(systemName: "figure.walk")
                .font(.title2)
        }
    }
}

struct InlineView: View {
    let steps: Int

    var body: some View {
        Text("\(steps) steps")
    }
}
```

### Deep Links

```swift
struct StepsWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StepsProvider()) { entry in
            StepsEntryView(entry: entry)
        }
        .supportedFamilies([.accessoryCircular])
        .widgetURL(URL(string: "myapp://steps")!)  // Tap opens app
    }
}
```

## Best Practices

1. **Design for small spaces** - Complications are tiny
2. **Update appropriately** - Balance freshness vs battery
3. **Support multiple families** - More watch face compatibility
4. **Use SF Symbols** - Consistent iconography
5. **Respect timeline budget** - Limited updates per day
6. **Test on device** - Simulator limited
7. **Provide placeholders** - For configuration UI
8. **Handle errors gracefully** - Show fallback data
9. **Consider complications first** - Primary watch face interaction
10. **Follow design guidelines** - watchOS HIG for complications

## Related Skills

- `swiftui-essentials` - Building views
- `app-lifecycle` - Background updates
- `cross-platform-patterns` - watchOS constraints
- `data-persistence` - Caching complication data

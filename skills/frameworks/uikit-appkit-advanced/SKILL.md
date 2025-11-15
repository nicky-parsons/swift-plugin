---
name: uikit-appkit-advanced
description: Advanced UIKit and AppKit patterns including custom view controllers, collection views, delegate patterns, responder chain, view controller containment, coordinators, custom transitions, and deep platform integration. Use when building complex iOS/macOS UIs, custom controls, or advanced navigation patterns.
version: 1.0.0
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# Advanced UIKit and AppKit Patterns

## What This Skill Does

Advanced patterns for UIKit (iOS) and AppKit (macOS) including custom view controllers, collection view layouts, coordinators, custom transitions, and platform-specific UI patterns.

## When to Activate

- Building complex view hierarchies
- Implementing custom view controllers
- Creating coordinator patterns
- Custom collection view layouts
- Advanced navigation flows
- Custom transitions and animations
- Platform-specific UI implementations

## Core Concepts

### View Controller Lifecycle (UIKit)

```swift
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // One-time setup
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh data, start animations
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Begin intensive tasks
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Save state, pause
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Stop intensive tasks
    }
}
```

### Coordinator Pattern

```swift
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = HomeViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }

    func showDetail(_ item: Item) {
        let vc = DetailViewController(item: item)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
```

### Custom Collection View Layout

```swift
class WaterfallLayout: UICollectionViewLayout {
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }

        cache.removeAll()
        contentHeight = 0

        let columnCount = 2
        let cellPadding: CGFloat = 6
        let cellWidth = (collectionView.bounds.width - CGFloat(columnCount + 1) * cellPadding) / CGFloat(columnCount)

        var columnHeights = [CGFloat](repeating: 0, count: columnCount)

        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let column = columnHeights.firstIndex(of: columnHeights.min()!)!

            let height = calculateHeight(for: indexPath)
            let frame = CGRect(
                x: cellPadding + CGFloat(column) * (cellWidth + cellPadding),
                y: columnHeights[column],
                width: cellWidth,
                height: height
            )

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cache.append(attributes)

            columnHeights[column] += height + cellPadding
            contentHeight = max(contentHeight, columnHeights[column])
        }
    }

    override var collectionViewContentSize: CGSize {
        CGSize(width: collectionView?.bounds.width ?? 0, height: contentHeight)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        cache.filter { $0.frame.intersects(rect) }
    }

    private func calculateHeight(for indexPath: IndexPath) -> CGFloat {
        // Calculate based on content
        return 150
    }
}
```

## Best Practices

1. **Use coordinators for navigation** - Decouples view controllers
2. **Implement proper lifecycle** - Setup in viewDidLoad, updates in viewWillAppear
3. **Avoid massive view controllers** - Extract to child VCs or separate classes
4. **Use Auto Layout** - Avoid hardcoded frames
5. **Implement dark mode** - Support both light and dark appearances
6. **Test on multiple devices** - Different screen sizes and orientations
7. **Use diffable data sources** - Modern, performant table/collection views
8. **Respect safe areas** - Especially on notched devices
9. **Handle memory warnings** - Release resources when needed
10. **Use child view controllers** - For complex containment

## Related Skills

- `swiftui-essentials` - Modern UI alternative
- `cross-platform-patterns` - iOS vs macOS differences
- `debugging-basics` - Debug UI issues
- `memory-management` - Retain cycles in delegates

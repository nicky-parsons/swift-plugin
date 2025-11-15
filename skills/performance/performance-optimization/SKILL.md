---
name: performance-optimization
description: Optimize app performance including launch time, runtime speed, memory usage, battery efficiency, and smooth scrolling. Covers lazy loading, async processing, caching strategies, image optimization, and Core Data performance. Use when app is slow, uses too much memory, or drains battery.
version: 1.0.0
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# Performance Optimization

## What This Skill Does

Techniques for optimizing app performance across launch time, runtime speed, memory usage, battery life, and user interface smoothness.

## When to Activate

- Slow app launch
- Laggy scrolling
- High memory usage
- Battery drain
- Slow data loading
- Frame rate drops

## Optimization Areas

### Launch Time Optimization

```swift
// ❌ Slow launch
func application(_ application: UIApplication, didFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Synchronous setup
    setupDatabase()  // Blocks
    loadConfiguration()  // Blocks
    fetchRemoteConfig()  // Blocks - NEVER do this!

    return true
}

// ✅ Fast launch
func application(_ application: UIApplication, didFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Minimal synchronous setup
    setupCrashReporting()

    // Defer heavy work
    Task {
        await setupDatabase()
        await loadConfiguration()
    }

    // Fetch remote config after launch
    Task {
        await fetchRemoteConfig()
    }

    return true
}
```

### Memory Optimization

```swift
// ❌ High memory usage
class ImageCache {
    var cache: [String: UIImage] = [:]  // Unlimited growth!

    func store(_ image: UIImage, forKey key: String) {
        cache[key] = image
    }
}

// ✅ Controlled memory usage
class ImageCache {
    private let cache = NSCache<NSString, UIImage>()

    init() {
        cache.countLimit = 100  // Max 100 images
        cache.totalCostLimit = 50 * 1024 * 1024  // 50 MB

        // Clear cache on memory warning
        NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.cache.removeAllObjects()
        }
    }

    func store(_ image: UIImage, forKey key: String) {
        let cost = image.jpegData(compressionQuality: 1.0)?.count ?? 0
        cache.setObject(image, forKey: key as NSString, cost: cost)
    }
}
```

### Scrolling Performance

```swift
// ❌ Laggy scrolling
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!

    // Heavy work on main thread!
    let image = UIImage(named: "large")?.resize(to: CGSize(width: 50, height: 50))
    cell.imageView?.image = image

    // Synchronous network request!
    let data = try? Data(contentsOf: imageURL)
    cell.imageView?.image = UIImage(data: data!)

    return cell
}

// ✅ Smooth scrolling
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ImageCell

    // Set placeholder immediately
    cell.imageView?.image = UIImage(named: "placeholder")

    // Load image asynchronously
    Task {
        if let image = await imageCache.load(url: item.imageURL) {
            await MainActor.run {
                cell.imageView?.image = image
            }
        }
    }

    return cell
}
```

### Battery Optimization

```swift
// ❌ Battery drain
class LocationTracker {
    let manager = CLLocationManager()

    func start() {
        manager.desiredAccuracy = kCLLocationAccuracyBest  // Most power!
        manager.startUpdatingLocation()  // Continuous updates!
    }
}

// ✅ Battery efficient
class LocationTracker {
    let manager = CLLocationManager()

    func start() {
        // Use appropriate accuracy
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters

        // Set distance filter
        manager.distanceFilter = 100  // Update every 100m

        // Use significant location changes if appropriate
        manager.startMonitoringSignificantLocationChanges()
    }

    func stop() {
        manager.stopUpdatingLocation()
    }
}
```

### Core Data Optimization

```swift
// ❌ Slow fetch
let request: NSFetchRequest<Item> = Item.fetchRequest()
let allItems = try context.fetch(request)  // Loads everything!

// ✅ Optimized fetch
let request: NSFetchRequest<Item> = Item.fetchRequest()
request.fetchLimit = 20
request.fetchBatchSize = 20
request.predicate = NSPredicate(format: "isActive == YES")
request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

// Only fetch needed properties
request.propertiesToFetch = ["name", "createdAt"]

let items = try context.fetch(request)
```

## Best Practices

1. **Defer heavy work** - Don't block app launch
2. **Use lazy loading** - Load data when needed
3. **Implement caching** - Avoid redundant work
4. **Optimize images** - Downscale, compress, cache
5. **Batch operations** - Group updates together
6. **Use background threads** - Keep main thread responsive
7. **Limit network calls** - Batch, cache, debounce
8. **Monitor performance** - Use Instruments regularly
9. **Test on old devices** - Minimum supported hardware
10. **Profile before optimizing** - Measure, don't guess

## Related Skills

- `instruments-profiling` - Finding bottlenecks
- `swift-6-essentials` - Async/await optimization
- `memory-management` - Reducing memory usage
- `networking-patterns` - Network optimization

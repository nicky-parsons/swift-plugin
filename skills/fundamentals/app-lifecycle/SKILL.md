---
name: app-lifecycle
description: Manage application lifecycle on Apple platforms including app states (active, inactive, background, suspended), scene phases, state transitions, background tasks, and platform-specific lifecycle patterns for iOS, macOS, watchOS, tvOS, and visionOS applications.
version: 1.0.0
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# App Lifecycle Management

## What This Skill Does

Provides comprehensive guidance on managing application lifecycle across Apple platforms. Covers app states, scene phases in SwiftUI, background execution, state preservation, and platform-specific lifecycle behaviors for iOS, iPadOS, macOS, watchOS, tvOS, and visionOS.

## When to Activate

- Handling app state transitions (foreground/background)
- Saving data when app terminates or backgrounds
- Implementing background tasks and updates
- Managing resources based on app state
- Responding to scene lifecycle events
- Understanding platform-specific lifecycle differences
- Implementing proper cleanup in app termination

## Core Concepts

### App States (iOS/iPadOS)

**Not Running**: App is not launched
**Inactive**: App is running but not receiving events (transitional state)
**Active**: App is running and receiving events (foreground)
**Background**: App is executing code but not visible
**Suspended**: App is in memory but not executing code

### Scene Phase (SwiftUI, iOS 14+)

**Active**: Scene is in the foreground and interactive
**Inactive**: Scene is visible but not interactive (e.g., during transitions)
**Background**: Scene is not visible, may be running background code

### Lifecycle Methods (UIKit)

- `application(_:willFinishLaunchingWithOptions:)` - Very early setup
- `application(_:didFinishLaunchingWithOptions:)` - App launched, do setup
- `applicationWillEnterForeground(_:)` - About to become active
- `applicationDidBecomeActive(_:)` - Now active and receiving events
- `applicationWillResignActive(_:)` - About to lose focus
- `applicationDidEnterBackground(_:)` - Now in background
- `applicationWillTerminate(_:)` - About to terminate (not always called)

## Implementation Patterns

### SwiftUI App Lifecycle

```swift
@main
struct MyApp: App {
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            switch newPhase {
            case .active:
                print("App is active")
                refreshData()

            case .inactive:
                print("App is inactive")

            case .background:
                print("App is in background")
                saveData()
                cleanupResources()

            @unknown default:
                break
            }
        }
    }

    func refreshData() {
        // Refresh data when app becomes active
    }

    func saveData() {
        // Save any pending changes
    }

    func cleanupResources() {
        // Release resources not needed in background
    }
}
```

### UIKit App Delegate Lifecycle

```swift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        print("✅ App launched")

        // Initialize services
        setupDatabase()
        configureAppearance()
        registerForNotifications()

        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("🔵 Will enter foreground")

        // Prepare for becoming active
        reconnectNetworkServices()
        refreshDataIfNeeded()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("🟢 Did become active")

        // App is now active
        startLocationUpdates()
        resumeAnimations()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print("🟡 Will resign active")

        // Transitioning to inactive
        pauseOngoingTasks()
        saveGameState()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("🔴 Did enter background")

        // App is now in background
        let taskID = application.beginBackgroundTask {
            // Cleanup if time expires
            application.endBackgroundTask(taskID)
        }

        // Save data
        saveAllData()

        // Release resources
        releaseMemory()

        application.endBackgroundTask(taskID)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("❌ Will terminate")

        // Save data (may not always be called)
        saveAllData()
    }
}
```

### Scene Delegate (iOS 13+)

```swift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        print("Scene will connect")

        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("Scene became active")
        // Resume tasks
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("Scene will resign active")
        // Pause tasks
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("Scene will enter foreground")
        // Refresh UI
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("Scene entered background")
        // Save data
        saveSceneState()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        print("Scene disconnected")
        // Cleanup resources
    }
}
```

### Background Tasks (iOS 13+)

```swift
import BackgroundTasks

// 1. Register background tasks in AppDelegate
func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {

    // Register app refresh task
    BGTaskScheduler.shared.register(
        forTaskWithIdentifier: "com.app.refresh",
        using: nil
    ) { task in
        self.handleAppRefresh(task: task as! BGAppRefreshTask)
    }

    // Register processing task
    BGTaskScheduler.shared.register(
        forTaskWithIdentifier: "com.app.process",
        using: nil
    ) { task in
        self.handleProcessing(task: task as! BGProcessingTask)
    }

    return true
}

// 2. Schedule background tasks
func scheduleAppRefresh() {
    let request = BGAppRefreshTaskRequest(identifier: "com.app.refresh")
    request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // 15 minutes

    do {
        try BGTaskScheduler.shared.submit(request)
        print("App refresh scheduled")
    } catch {
        print("Could not schedule app refresh: \(error)")
    }
}

func scheduleProcessing() {
    let request = BGProcessingTaskRequest(identifier: "com.app.process")
    request.requiresNetworkConnectivity = true
    request.requiresExternalPower = false
    request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 60) // 1 hour

    do {
        try BGTaskScheduler.shared.submit(request)
        print("Processing task scheduled")
    } catch {
        print("Could not schedule processing: \(error)")
    }
}

// 3. Handle background tasks
func handleAppRefresh(task: BGAppRefreshTask) {
    // Schedule next refresh
    scheduleAppRefresh()

    // Create task to perform refresh
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1

    let operation = RefreshOperation()

    task.expirationHandler = {
        // Clean up if task expires
        queue.cancelAllOperations()
    }

    operation.completionBlock = {
        task.setTaskCompleted(success: !operation.isCancelled)
    }

    queue.addOperation(operation)
}

func handleProcessing(task: BGProcessingTask) {
    scheduleProcessing()

    Task {
        do {
            try await performHeavyProcessing()
            task.setTaskCompleted(success: true)
        } catch {
            task.setTaskCompleted(success: false)
        }
    }
}

// 4. Don't forget Info.plist entries
// <key>BGTaskSchedulerPermittedIdentifiers</key>
// <array>
//     <string>com.app.refresh</string>
//     <string>com.app.process</string>
// </array>
```

### State Restoration

```swift
// Enable state restoration
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return scene.userActivity
    }

    func scene(_ scene: UIScene, restoreInteractionStateWith stateRestorationActivity: NSUserActivity) {
        // Restore state from activity
        if let tabIndex = stateRestorationActivity.userInfo?["selectedTab"] as? Int {
            // Restore selected tab
        }
    }
}

// Save state in view controller
class ViewController: UIViewController {
    override func updateUserActivityState(_ activity: NSUserActivity) {
        super.updateUserActivityState(activity)

        // Save state
        activity.addUserInfoEntries(from: [
            "selectedTab": tabBarController?.selectedIndex ?? 0,
            "scrollPosition": tableView.contentOffset.y
        ])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Create user activity for state restoration
        let activity = NSUserActivity(activityType: "com.app.viewController")
        activity.addUserInfoEntries(from: [
            "selectedTab": tabBarController?.selectedIndex ?? 0
        ])
        view.window?.windowScene?.userActivity = activity
    }
}
```

### Finite-Length Background Tasks

```swift
class DataSyncService {
    func syncData() {
        // Start background task
        var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid

        backgroundTaskID = UIApplication.shared.beginBackgroundTask {
            // Time expired, clean up
            print("Background task expired")
            UIApplication.shared.endBackgroundTask(backgroundTaskID)
            backgroundTaskID = .invalid
        }

        Task {
            do {
                // Perform sync (you have ~30 seconds)
                try await performDataSync()

                print("Sync completed")
            } catch {
                print("Sync failed: \(error)")
            }

            // End background task
            UIApplication.shared.endBackgroundTask(backgroundTaskID)
            backgroundTaskID = .invalid
        }
    }

    private func performDataSync() async throws {
        // Upload pending changes
        // Download new data
        // Save to local database
    }
}
```

### macOS App Lifecycle

```swift
@main
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("macOS app launched")
        // App is ready
    }

    func applicationWillTerminate(_ notification: Notification) {
        print("macOS app will terminate")
        // Save data
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        print("Should terminate?")

        if hasUnsavedChanges() {
            // Show save dialog
            return .terminateCancel
        }

        return .terminateNow
    }

    func applicationWillResignActive(_ notification: Notification) {
        print("App losing focus")
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        print("App gained focus")
    }

    func applicationDidHide(_ notification: Notification) {
        print("App hidden")
    }

    func applicationDidUnhide(_ notification: Notification) {
        print("App unhidden")
    }

    private func hasUnsavedChanges() -> Bool {
        // Check for unsaved changes
        return false
    }
}
```

### watchOS Lifecycle

```swift
import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    func applicationDidFinishLaunching() {
        print("Watch app launched")
        // Very limited time for setup
    }

    func applicationDidBecomeActive() {
        print("Watch app active")
        // Refresh UI
    }

    func applicationWillResignActive() {
        print("Watch app will resign")
        // Save state immediately
    }

    func applicationDidEnterBackground() {
        print("Watch app backgrounded")
        // Very limited background time
    }

    // Background refresh (limited)
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        for task in backgroundTasks {
            switch task {
            case let refreshTask as WKApplicationRefreshBackgroundTask:
                // Refresh data
                scheduleNextBackgroundRefresh()
                refreshTask.setTaskCompletedWithSnapshot(false)

            default:
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }

    func scheduleNextBackgroundRefresh() {
        let fireDate = Date(timeIntervalSinceNow: 60 * 60) // 1 hour
        WKExtension.shared().scheduleBackgroundRefresh(
            withPreferredDate: fireDate,
            userInfo: nil
        ) { error in
            if let error = error {
                print("Failed to schedule refresh: \(error)")
            }
        }
    }
}
```

## Best Practices

1. **Save data in background transition** - Don't wait for termination (may not be called)

2. **Release resources when backgrounded** - Free memory for system

3. **Refresh data when foregrounded** - Keep content current

4. **Use background tasks appropriately** - Don't abuse background time

5. **Handle state restoration** - Improve user experience

6. **Test all lifecycle transitions** - Ensure app handles them correctly

7. **Use scene phase in SwiftUI** - Modern, declarative lifecycle management

8. **Schedule background tasks properly** - Follow system guidelines

9. **Monitor background task time** - Finish within allotted time

10. **Clean up in willTerminate** - May be only chance to save

## Platform-Specific Considerations

### iOS/iPadOS
- Apps can be terminated at any time in background
- Background execution strictly limited
- Scene-based lifecycle for multiple windows on iPad
- Must complete background tasks within ~30 seconds

### macOS
- Apps typically run until explicitly quit
- No automatic suspension
- Window closing doesn't terminate app (by default)
- More relaxed lifecycle constraints

### watchOS
- Extremely aggressive backgrounding
- Very limited background execution (seconds)
- No guaranteed background time
- Must save immediately when backgrounded
- Complications have separate update mechanism

### tvOS
- Foreground-focused platform
- Limited background execution
- No widgets or complications
- Apps often suspended when not visible

### visionOS
- Similar to iOS but with spatial considerations
- Multiple spaces can affect lifecycle
- Windows can exist in different spaces
- Scene management more complex

## Common Pitfalls

1. **Not saving in didEnterBackground**
   - ❌ Only saving in willTerminate
   - ✅ Save in didEnterBackground (always called)

2. **Assuming willTerminate is called**
   - ❌ Only cleanup in willTerminate
   - ✅ Cleanup in didEnterBackground

3. **Blocking main thread in lifecycle methods**
   - ❌ Synchronous heavy work in didBecomeActive
   - ✅ Dispatch heavy work to background

4. **Not ending background tasks**
   - ❌ beginBackgroundTask without endBackgroundTask
   - ✅ Always pair begin with end

5. **Ignoring scene phase changes**
   - ❌ Not responding to background transition
   - ✅ Monitor scenePhase and act appropriately

6. **Excessive background refresh**
   - ❌ Scheduling too-frequent background tasks
   - ✅ Follow Apple's guidelines for intervals

7. **Not testing lifecycle transitions**
   - ❌ Only testing while debugging
   - ✅ Test backgrounding, foregrounding, termination

8. **Retaining unnecessary resources**
   - ❌ Keeping large objects in background
   - ✅ Release memory when backgrounded

## Related Skills

- `data-persistence` - Saving data during lifecycle events
- `swift-6-essentials` - Async lifecycle handling
- `swiftui-essentials` - Scene phase management
- `debugging-basics` - Debugging lifecycle issues

## Example Scenarios

### Scenario 1: SwiftUI Data Saving

```swift
@main
struct TodoApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var dataStore = TodoDataStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataStore)
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .background {
                dataStore.save()
            } else if newPhase == .active {
                dataStore.refresh()
            }
        }
    }
}

@Observable
class TodoDataStore {
    var todos: [Todo] = []

    func save() {
        print("💾 Saving todos...")
        // Save to disk or database
    }

    func refresh() {
        print("🔄 Refreshing todos...")
        // Reload from disk if needed
    }
}
```

### Scenario 2: Background Data Sync

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        registerBackgroundTasks()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        scheduleBackgroundRefresh()
    }

    private func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "com.app.datasync",
            using: nil
        ) { task in
            self.handleDataSync(task: task as! BGAppRefreshTask)
        }
    }

    private func scheduleBackgroundRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.app.datasync")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 30 * 60)

        try? BGTaskScheduler.shared.submit(request)
    }

    private func handleDataSync(task: BGAppRefreshTask) {
        scheduleBackgroundRefresh()

        let syncTask = Task {
            try await DataSyncService.shared.sync()
        }

        task.expirationHandler = {
            syncTask.cancel()
        }

        Task {
            do {
                try await syncTask.value
                task.setTaskCompleted(success: true)
            } catch {
                task.setTaskCompleted(success: false)
            }
        }
    }
}
```

### Scenario 3: State Preservation

```swift
class DocumentViewController: UIViewController {
    var document: Document?
    var scrollPosition: CGFloat = 0

    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)

        coder.encode(document?.identifier, forKey: "documentID")
        coder.encode(scrollPosition, forKey: "scrollPosition")
    }

    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)

        if let documentID = coder.decodeObject(forKey: "documentID") as? String {
            document = DocumentStore.shared.loadDocument(id: documentID)
        }

        scrollPosition = CGFloat(coder.decodeFloat(forKey: "scrollPosition"))
    }

    override func applicationFinishedRestoringState() {
        // Restore UI to saved state
        scrollView.setContentOffset(CGPoint(x: 0, y: scrollPosition), animated: false)
    }
}
```

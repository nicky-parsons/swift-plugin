---
name: swiftui-essentials
description: Build SwiftUI applications with proper state management using @State, @Binding, @StateObject, @ObservedObject, @Observable, and @Environment. Use when creating SwiftUI views, handling user input, managing application state, or building declarative UIs for Apple platforms.
version: 1.0.0
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# SwiftUI Essentials

## What This Skill Does

Provides comprehensive guidance on SwiftUI, Apple's declarative UI framework for building user interfaces across all Apple platforms. Covers state management, view composition, lifecycle, performance optimization, and integration with UIKit/AppKit.

## When to Activate

- Creating new SwiftUI views and components
- Implementing state management in SwiftUI applications
- Handling user input and form validation
- Building navigation flows and view hierarchies
- Optimizing SwiftUI performance
- Integrating SwiftUI with UIKit or AppKit
- Using @Observable macro and modern state patterns

## Core Concepts

### Declarative UI Philosophy

SwiftUI is **declarative**: you describe what the UI should look like for any given state, and SwiftUI handles the updates when state changes. This contrasts with imperative UIKit where you manually update views.

```swift
// Declarative SwiftUI
struct CounterView: View {
    @State private var count = 0

    var body: some View {
        VStack {
            Text("Count: \(count)")
            Button("Increment") {
                count += 1  // SwiftUI updates UI automatically
            }
        }
    }
}
```

### View Protocol

Every SwiftUI view conforms to the `View` protocol with a single requirement:

```swift
protocol View {
    associatedtype Body: View
    var body: Self.Body { get }
}
```

Views are lightweight value types (structs). Creating views is cheap, so extract subviews liberally.

### State Management Hierarchy

SwiftUI provides multiple property wrappers for different state scenarios:

- **@State**: Private, value-type state owned by the view
- **@Binding**: Two-way reference to another view's state
- **@StateObject**: Create and own an ObservableObject reference type
- **@ObservedObject**: Reference to externally-owned ObservableObject
- **@EnvironmentObject**: Shared object through view hierarchy
- **@Environment**: Access system-provided or custom environment values
- **@Observable**: Modern macro for observable types (iOS 17+)

## Implementation Patterns

### State Management with @State

Use `@State` for simple value types owned by the view:

```swift
struct ToggleView: View {
    @State private var isOn = false
    @State private var username = ""
    @State private var selectedColor = Color.blue

    var body: some View {
        VStack {
            Toggle("Enable Feature", isOn: $isOn)
            TextField("Username", text: $username)
            ColorPicker("Choose Color", selection: $selectedColor)

            if isOn {
                Text("Feature enabled for \(username)")
                    .foregroundColor(selectedColor)
            }
        }
        .padding()
    }
}
```

**Key points:**
- Mark as `private` - internal implementation detail
- Use `$` prefix to pass binding to child views
- SwiftUI manages storage and updates

### Bindings with @Binding

Use `@Binding` for two-way communication with parent views:

```swift
struct VolumeSlider: View {
    @Binding var volume: Double

    var body: some View {
        VStack {
            Slider(value: $volume, in: 0...100)
            Text("Volume: \(Int(volume))")
        }
    }
}

struct ParentView: View {
    @State private var currentVolume = 50.0

    var body: some View {
        VStack {
            VolumeSlider(volume: $currentVolume)  // Pass binding with $
            Text("Current: \(Int(currentVolume))")
        }
    }
}
```

**When to use:**
- Child view needs to read AND write parent's state
- Create custom controls that modify external state
- Break down complex views while maintaining shared state

### Observable Objects (ObservableObject)

For reference types and complex state, use `ObservableObject`:

```swift
class ViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadData() async {
        isLoading = true
        defer { isLoading = false }

        do {
            items = try await fetchItems()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        List(viewModel.items) { item in
            Text(item.name)
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .task {
            await viewModel.loadData()
        }
    }
}
```

**@StateObject vs @ObservedObject:**
- `@StateObject`: View owns and creates the object (survives view updates)
- `@ObservedObject`: Object created and owned elsewhere (reference only)

### Modern @Observable Macro (iOS 17+)

The `@Observable` macro simplifies observable types:

```swift
import Observation

@Observable
class AppModel {
    var username: String = ""
    var isLoggedIn: Bool = false
    var items: [Item] = []

    // No @Published needed - all properties are automatically tracked
}

struct ModernView: View {
    @State private var model = AppModel()
    // Or: @Environment(AppModel.self) var model

    var body: some View {
        VStack {
            Text("User: \(model.username)")
            Toggle("Logged In", isOn: $model.isLoggedIn)
        }
    }
}
```

**Benefits:**
- No `@Published` annotations needed
- Better performance - tracks specific property access
- Cleaner syntax
- Works with Swift concurrency

### Environment Objects

Share objects through view hierarchy without passing explicitly:

```swift
class AppSettings: ObservableObject {
    @Published var theme: Theme = .light
    @Published var fontSize: Double = 16
}

@main
struct MyApp: App {
    @StateObject private var settings = AppSettings()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var settings: AppSettings

    var body: some View {
        Text("Hello")
            .font(.system(size: settings.fontSize))
    }
}

struct DeepNestedView: View {
    @EnvironmentObject var settings: AppSettings
    // Available here too, without passing through intermediate views
}
```

### Environment Values

Access system or custom environment values:

```swift
struct MyView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button("Close") {
            dismiss()
        }
        .foregroundColor(colorScheme == .dark ? .white : .black)
    }
}

// Custom environment values
struct UserIDKey: EnvironmentKey {
    static let defaultValue: String = ""
}

extension EnvironmentValues {
    var userID: String {
        get { self[UserIDKey.self] }
        set { self[UserIDKey.self] = newValue }
    }
}

// Usage
ContentView()
    .environment(\.userID, "user123")
```

### View Composition

Break views into small, focused components:

```swift
struct ProfileView: View {
    let user: User

    var body: some View {
        VStack(spacing: 20) {
            ProfileHeader(user: user)
            ProfileStats(user: user)
            ProfileActions(user: user)
        }
    }
}

struct ProfileHeader: View {
    let user: User

    var body: some View {
        VStack {
            AsyncImage(url: user.avatarURL) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())

            Text(user.name)
                .font(.title)
        }
    }
}
```

**Best practices:**
- Extract views when they exceed ~10 lines
- Create reusable components
- No performance penalty for small views
- Use computed properties for simple extractions

### Navigation Patterns

Modern navigation with NavigationStack (iOS 16+):

```swift
struct ContentView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            List(items) { item in
                NavigationLink(value: item) {
                    ItemRow(item: item)
                }
            }
            .navigationDestination(for: Item.self) { item in
                ItemDetailView(item: item)
            }
            .navigationTitle("Items")
        }
    }
}

// Programmatic navigation
Button("Go to Detail") {
    path.append(selectedItem)
}

Button("Go Back") {
    path.removeLast()
}

Button("Go to Root") {
    path.removeLast(path.count)
}
```

### Lists and Performance

Use lazy containers for large collections:

```swift
struct ItemListView: View {
    let items: [Item]

    var body: some View {
        List {
            ForEach(items) { item in
                ItemRow(item: item)
            }
            .onDelete(perform: deleteItems)
        }
    }

    func deleteItems(at offsets: IndexSet) {
        // Handle deletion
    }
}

// Lazy vertical scrolling
ScrollView {
    LazyVStack(spacing: 10) {
        ForEach(1...1000, id: \.self) { number in
            HeavyView(number: number)
                .id(number)  // Explicit identity for animations
        }
    }
}
```

**Performance tips:**
- Use `LazyVStack`/`LazyHStack` for large lists
- Implement `Identifiable` for stable identity
- Add explicit `.id()` when needed
- Use `List` for automatic optimizations

### Forms and Input

Build forms with validation:

```swift
struct RegistrationForm: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var agreedToTerms = false

    var isValid: Bool {
        !username.isEmpty &&
        email.contains("@") &&
        password.count >= 8 &&
        agreedToTerms
    }

    var body: some View {
        Form {
            Section("Account") {
                TextField("Username", text: $username)
                    .textContentType(.username)
                    .textInputAutocapitalization(.never)

                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)

                SecureField("Password", text: $password)
                    .textContentType(.newPassword)
            }

            Section {
                Toggle("I agree to terms", isOn: $agreedToTerms)
            }

            Section {
                Button("Register") {
                    register()
                }
                .disabled(!isValid)
            }
        }
    }

    func register() {
        // Handle registration
    }
}
```

### Animations

SwiftUI provides powerful declarative animations:

```swift
struct AnimatedView: View {
    @State private var isExpanded = false

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: isExpanded ? 50 : 10)
                .fill(isExpanded ? Color.blue : Color.red)
                .frame(width: isExpanded ? 200 : 100,
                       height: isExpanded ? 200 : 100)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isExpanded)

            Button("Toggle") {
                isExpanded.toggle()
            }
        }
    }
}

// Explicit animations
Button("Animate") {
    withAnimation(.easeInOut(duration: 0.3)) {
        isExpanded.toggle()
    }
}

// Custom transitions
struct ContentView: View {
    @State private var showDetails = false

    var body: some View {
        VStack {
            if showDetails {
                DetailView()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}
```

### UIKit/AppKit Integration

Wrap UIKit views in SwiftUI:

```swift
import UIKit
import SwiftUI

struct MapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            parent.region = mapView.region
        }
    }
}
```

Use SwiftUI in UIKit:

```swift
import UIKit
import SwiftUI

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let swiftUIView = ContentView()
        let hostingController = UIHostingController(rootView: swiftUIView)

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.didMove(toParent: self)
    }
}
```

## Best Practices

1. **Keep views small** - Extract subviews when body exceeds ~10 lines

2. **Use appropriate state management** - @State for local, @StateObject for owned objects, @EnvironmentObject for shared

3. **Prefer value types** - Use structs for views and models when possible

4. **Mark state as private** - @State and @StateObject should be private

5. **Use @Observable for new code** - Modern alternative to ObservableObject (iOS 17+)

6. **Leverage property wrappers** - Let SwiftUI manage state updates automatically

7. **Implement Identifiable** - Provide stable identity for list items

8. **Use task modifier for async work** - `.task { }` automatically cancels on view disappearance

9. **Preview with realistic data** - Create preview helpers for different states

10. **Avoid force unwrapping** - Use optional binding and default values

## Platform-Specific Considerations

### iOS/iPadOS
- Use `.navigationBarTitleDisplayMode(.inline)` for compact navigation
- Implement pull-to-refresh with `.refreshable`
- Support both portrait and landscape orientations
- Use `.sheet`, `.fullScreenCover` for modals

### macOS
- Use `.frame(minWidth:, maxWidth:)` for resizable windows
- Implement toolbar with `.toolbar`
- Support keyboard shortcuts with `.keyboardShortcut`
- Use `.formStyle(.grouped)` for native appearance

### watchOS
- Keep interfaces simple and focused
- Use Digital Crown with `.digitalCrownRotation`
- Implement complications for watch face
- Use full-screen layouts

### tvOS
- Design for focus-based navigation
- Use large, readable text (10-foot viewing distance)
- Implement parallax effects
- No direct touch input

### visionOS
- Design for spatial computing
- Use depth and 3D transforms
- Support eye tracking and gestures
- Implement ornaments for persistent UI

## Common Pitfalls

1. **Creating @StateObject in subviews**
   - ❌ View creates object that parent should own
   - ✅ Use @StateObject only where object is created, @ObservedObject elsewhere

2. **Mutating state outside main thread**
   - ❌ Updating @Published properties from background thread
   - ✅ Use @MainActor or dispatch to main queue

3. **Force unwrapping in body**
   - ❌ `user!.name` crashes if nil
   - ✅ Use optional binding: `if let user { Text(user.name) }`

4. **Not using lazy stacks**
   - ❌ `VStack` with thousands of views
   - ✅ `LazyVStack` for large collections

5. **Overusing @EnvironmentObject**
   - ❌ Making everything a global environment object
   - ✅ Pass data explicitly when possible, use for truly shared state

6. **Forgetting animation value parameter**
   - ❌ `.animation(.default)` (deprecated, animates everything)
   - ✅ `.animation(.default, value: isExpanded)` (explicit dependency)

7. **Creating reference cycles**
   - ❌ Strong captures in closures
   - ✅ Use `[weak self]` when needed (rare in SwiftUI)

8. **Not canceling async tasks**
   - ❌ Manual Task that continues after view disappears
   - ✅ Use `.task { }` modifier for automatic cancellation

## Related Skills

- `swift-6-essentials` - Using @Observable and Swift 6 features
- `swiftui-advanced` - Animations, custom views, GeometryReader
- `swiftdata-persistence` - Integrating SwiftData with SwiftUI
- `testing-fundamentals` - Testing SwiftUI views and view models
- `platform-ui-patterns` - Platform-specific navigation and patterns

## Example Scenarios

### Scenario 1: Simple Counter with State

```swift
struct CounterView: View {
    @State private var count = 0

    var body: some View {
        VStack(spacing: 20) {
            Text("Count: \(count)")
                .font(.largeTitle)

            HStack {
                Button("Decrement") {
                    count -= 1
                }
                Button("Reset") {
                    count = 0
                }
                Button("Increment") {
                    count += 1
                }
            }
        }
        .padding()
    }
}
```

### Scenario 2: Form with Validation

```swift
struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showError = false
    @State private var errorMessage = ""

    var isValid: Bool {
        email.contains("@") && password.count >= 6
    }

    var body: some View {
        Form {
            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)

            SecureField("Password", text: $password)
                .textContentType(.password)

            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Button("Login") {
                login()
            }
            .disabled(!isValid)
        }
    }

    func login() {
        // Handle login
    }
}
```

### Scenario 3: List with Navigation

```swift
struct TodoListView: View {
    @State private var todos: [Todo] = []
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(todos) { todo in
                    NavigationLink(value: todo) {
                        HStack {
                            Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                            Text(todo.title)
                        }
                    }
                }
                .onDelete(perform: deleteTodos)
            }
            .navigationTitle("Todos")
            .navigationDestination(for: Todo.self) { todo in
                TodoDetailView(todo: todo)
            }
            .toolbar {
                Button("Add") {
                    addTodo()
                }
            }
        }
    }

    func deleteTodos(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
    }

    func addTodo() {
        let newTodo = Todo(title: "New Task")
        todos.append(newTodo)
    }
}
```

### Scenario 4: Observable ViewModel Pattern

```swift
@Observable
class SearchViewModel {
    var searchText = ""
    var results: [SearchResult] = []
    var isLoading = false

    @MainActor
    func search() async {
        guard !searchText.isEmpty else {
            results = []
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            results = try await performSearch(query: searchText)
        } catch {
            results = []
        }
    }

    private func performSearch(query: String) async throws -> [SearchResult] {
        // Implementation
        return []
    }
}

struct SearchView: View {
    @State private var viewModel = SearchViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.results) { result in
                Text(result.title)
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .searchable(text: $viewModel.searchText)
            .onChange(of: viewModel.searchText) { oldValue, newValue in
                Task {
                    await viewModel.search()
                }
            }
            .navigationTitle("Search")
        }
    }
}
```

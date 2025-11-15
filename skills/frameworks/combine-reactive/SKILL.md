---
name: combine-reactive
description: Build reactive applications using Combine framework with publishers, subscribers, operators, subjects, and schedulers. Handle asynchronous events, data streams, and state management. Use when implementing reactive patterns, observing changes, chaining asynchronous operations, or integrating with SwiftUI @Published properties.
version: 1.0.0
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# Combine Reactive Programming

## What This Skill Does

Provides comprehensive guidance on using Apple's Combine framework for reactive programming. Covers publishers, subscribers, operators, subjects, schedulers, cancellation, error handling, and integration with Swift concurrency and SwiftUI.

## When to Activate

- Implementing reactive data streams
- Observing and responding to value changes
- Chaining asynchronous operations
- Integrating with SwiftUI via @Published
- Handling complex event sequences
- Migrating from NotificationCenter or KVO
- Managing cancellation of async operations

## Core Concepts

### Publisher-Subscriber Pattern

**Publisher**: Emits values over time
**Subscriber**: Receives values from publisher
**Operator**: Transforms publisher output
**Subscription**: Connection between publisher and subscriber

```swift
// Publisher emits values
let publisher = [1, 2, 3, 4, 5].publisher

// Subscriber receives values
let cancellable = publisher
    .sink { value in
        print(value)
    }
```

### Three Key Types

**Publisher** - Declares value and error types it can produce
**Subscriber** - Receives input from publisher
**AnyCancellable** - Token that cancels subscription when deallocated

## Implementation Patterns

### Basic Publisher and Subscriber

```swift
import Combine

// Just publisher - emits single value then completes
let justPublisher = Just("Hello, Combine!")
    .sink { value in
        print(value)  // "Hello, Combine!"
    }

// Sequence publisher
let numbers = [1, 2, 3, 4, 5].publisher
let cancellable = numbers
    .sink(
        receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("Finished")
            case .failure(let error):
                print("Error: \(error)")
            }
        },
        receiveValue: { value in
            print("Value: \(value)")
        }
    )
```

### Operators - Map, Filter, FlatMap

```swift
// Map - transform values
[1, 2, 3, 4, 5].publisher
    .map { $0 * 2 }
    .sink { print($0) }  // 2, 4, 6, 8, 10

// Filter - only certain values
[1, 2, 3, 4, 5].publisher
    .filter { $0 % 2 == 0 }
    .sink { print($0) }  // 2, 4

// FlatMap - transform to publisher
struct User {
    let id: Int
    let name: String
}

func fetchUser(id: Int) -> AnyPublisher<User, Error> {
    // Returns publisher
    Just(User(id: id, name: "User \(id)"))
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
}

[1, 2, 3].publisher
    .flatMap { id in
        fetchUser(id: id)
    }
    .sink(
        receiveCompletion: { _ in },
        receiveValue: { user in
            print(user.name)
        }
    )
```

### Subjects - PassthroughSubject and CurrentValueSubject

```swift
// PassthroughSubject - broadcast values to subscribers
class EventBus {
    let eventPublisher = PassthroughSubject<String, Never>()

    func post(event: String) {
        eventPublisher.send(event)
    }
}

let bus = EventBus()
let cancellable = bus.eventPublisher
    .sink { event in
        print("Received: \(event)")
    }

bus.post(event: "User logged in")
bus.post(event: "Data updated")

// CurrentValueSubject - holds current value
class Counter {
    let count = CurrentValueSubject<Int, Never>(0)

    func increment() {
        count.value += 1
    }
}

let counter = Counter()
let subscription = counter.count
    .sink { value in
        print("Count: \(value)")  // Prints current value immediately
    }

counter.increment()  // Triggers update
```

### SwiftUI Integration with @Published

```swift
import Combine
import SwiftUI

class ViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var results: [SearchResult] = []
    @Published var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        // Reactive search with debounce
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.performSearch(text)
            }
            .store(in: &cancellables)
    }

    func performSearch(_ text: String) {
        guard !text.isEmpty else {
            results = []
            return
        }

        isLoading = true

        // Perform search
        searchAPI(query: text)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] _ in
                    self?.isLoading = false
                },
                receiveValue: { [weak self] results in
                    self?.results = results
                }
            )
            .store(in: &cancellables)
    }

    func searchAPI(query: String) -> AnyPublisher<[SearchResult], Never> {
        // Mock implementation
        Just([]).eraseToAnyPublisher()
    }
}

struct SearchView: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        List {
            ForEach(viewModel.results) { result in
                Text(result.title)
            }
        }
        .searchable(text: $viewModel.searchText)
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
    }
}
```

### Combining Publishers

```swift
// Zip - combine values from multiple publishers
let numbers = [1, 2, 3].publisher
let letters = ["A", "B", "C"].publisher

numbers.zip(letters)
    .sink { number, letter in
        print("\(number): \(letter)")
    }
// Output: 1: A, 2: B, 3: C

// CombineLatest - emit when any publisher emits
let temperature = PassthroughSubject<Int, Never>()
let humidity = PassthroughSubject<Int, Never>()

temperature.combineLatest(humidity)
    .sink { temp, humid in
        print("Temp: \(temp)°, Humidity: \(humid)%")
    }
    .store(in: &cancellables)

temperature.send(72)
humidity.send(45)  // Prints "Temp: 72°, Humidity: 45%"
temperature.send(75)  // Prints "Temp: 75°, Humidity: 45%"

// Merge - combine streams of same type
let stream1 = PassthroughSubject<String, Never>()
let stream2 = PassthroughSubject<String, Never>()

stream1.merge(with: stream2)
    .sink { value in
        print(value)
    }

stream1.send("From stream 1")
stream2.send("From stream 2")
```

### Error Handling

```swift
enum APIError: Error {
    case networkError
    case decodingError
    case notFound
}

func fetchData() -> AnyPublisher<Data, APIError> {
    URLSession.shared.dataTaskPublisher(for: url)
        .mapError { _ in APIError.networkError }
        .map(\.data)
        .eraseToAnyPublisher()
}

// Catch errors and provide default
fetchData()
    .catch { error -> AnyPublisher<Data, Never> in
        print("Error: \(error)")
        return Just(Data()).eraseToAnyPublisher()
    }
    .sink { data in
        print("Received data")
    }

// Retry on failure
fetchData()
    .retry(3)
    .sink(
        receiveCompletion: { completion in
            if case .failure(let error) = completion {
                print("Failed after retries: \(error)")
            }
        },
        receiveValue: { data in
            print("Success")
        }
    )

// ReplaceError with default value
fetchData()
    .replaceError(with: Data())
    .sink { data in
        print("Got data (or default)")
    }
```

### Schedulers

```swift
// Receive on main thread (for UI updates)
apiPublisher
    .receive(on: DispatchQueue.main)
    .sink { value in
        // Safe to update UI
        label.text = value
    }

// Subscribe on background thread
heavyComputationPublisher
    .subscribe(on: DispatchQueue.global(qos: .background))
    .receive(on: DispatchQueue.main)
    .sink { result in
        // Computation on background, result on main
    }

// Debounce - wait for pause in events
searchField.textPublisher
    .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
    .sink { searchText in
        performSearch(searchText)
    }

// Throttle - limit rate of events
locationPublisher
    .throttle(for: .seconds(1), scheduler: RunLoop.main, latest: true)
    .sink { location in
        updateMap(location)
    }
```

### Memory Management

```swift
class ViewController: UIViewController {
    // Store cancellables to keep subscriptions alive
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Subscription stored in set
        dataPublisher
            .sink { [weak self] data in
                self?.updateUI(data)
            }
            .store(in: &cancellables)

        // Multiple subscriptions
        publisher1.sink { _ in }.store(in: &cancellables)
        publisher2.sink { _ in }.store(in: &cancellables)
        publisher3.sink { _ in }.store(in: &cancellables)
    }

    // Cancellables automatically cancelled when ViewController deallocates
    deinit {
        print("Subscriptions cancelled")
    }
}

// Manual cancellation
var cancellable: AnyCancellable?

cancellable = publisher.sink { value in
    print(value)
}

// Later...
cancellable?.cancel()
cancellable = nil
```

### Networking with Combine

```swift
struct User: Codable {
    let id: Int
    let name: String
}

func fetchUser(id: Int) -> AnyPublisher<User, Error> {
    let url = URL(string: "https://api.example.com/users/\(id)")!

    return URLSession.shared.dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: User.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
}

// Usage
fetchUser(id: 123)
    .receive(on: DispatchQueue.main)
    .sink(
        receiveCompletion: { completion in
            if case .failure(let error) = completion {
                print("Error: \(error)")
            }
        },
        receiveValue: { user in
            print("User: \(user.name)")
        }
    )
    .store(in: &cancellables)

// Chaining requests
func fetchUserPosts(userId: Int) -> AnyPublisher<[Post], Error> {
    fetchUser(id: userId)
        .flatMap { user in
            fetchPosts(userId: user.id)
        }
        .eraseToAnyPublisher()
}
```

### Migrating to Async/Await

```swift
// Combine approach
func fetchDataCombine() -> AnyPublisher<Data, Error> {
    URLSession.shared.dataTaskPublisher(for: url)
        .map(\.data)
        .eraseToAnyPublisher()
}

// Async/await approach (preferred for new code)
func fetchDataAsync() async throws -> Data {
    let (data, _) = try await URLSession.shared.data(from: url)
    return data
}

// Bridge Combine to async/await
extension Publisher {
    func async() async throws -> Output where Failure == Error {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?

            cancellable = first()
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { value in
                        continuation.resume(returning: value)
                        cancellable?.cancel()
                    }
                )
        }
    }
}

// Usage
Task {
    let data = try await fetchDataCombine().async()
}
```

## Best Practices

1. **Store cancellables** - Use `Set<AnyCancellable>` to keep subscriptions alive

2. **Use [weak self] in closures** - Prevent retain cycles

3. **Receive on main for UI** - Always use `.receive(on: DispatchQueue.main)` before UI updates

4. **Prefer @Published for SwiftUI** - Automatic UI updates with minimal code

5. **Type-erase with eraseToAnyPublisher()** - Hide implementation details

6. **Handle errors explicitly** - Don't ignore `receiveCompletion`

7. **Use operators wisely** - Debounce search, throttle location, etc.

8. **Consider async/await for new code** - Simpler for linear flows

9. **Clean up subscriptions** - Let cancellables deallocate or call `.cancel()`

10. **Test publishers** - Use test schedulers for deterministic testing

## Common Pitfalls

1. **Not storing cancellables**
   - ❌ `publisher.sink { }` - subscription immediately cancelled
   - ✅ `publisher.sink { }.store(in: &cancellables)`

2. **Updating UI from background thread**
   - ❌ Direct UI update in sink
   - ✅ `.receive(on: DispatchQueue.main).sink { update UI }`

3. **Retain cycles with self**
   - ❌ `.sink { self.property = value }`
   - ✅ `.sink { [weak self] in self?.property = value }`

4. **Ignoring errors**
   - ❌ Only handling `receiveValue`
   - ✅ Handle both `receiveCompletion` and `receiveValue`

5. **Over-using Combine**
   - ❌ Using Combine for simple async operations
   - ✅ Use async/await for linear flows, Combine for reactive streams

6. **Not type-erasing**
   - ❌ Exposing complex publisher types
   - ✅ Return `AnyPublisher<Output, Failure>`

7. **Memory leaks**
   - ❌ Forgetting to use weak self
   - ✅ Always `[weak self]` when referencing self

8. **Not cleaning up**
   - ❌ Subscriptions living forever
   - ✅ Store in `Set<AnyCancellable>` that deallocates

## Related Skills

- `swiftui-essentials` - @Published integration
- `networking-patterns` - Combine with URLSession
- `swift-6-essentials` - Async/await migration
- `testing-fundamentals` - Testing publishers
- `memory-management` - Avoiding retain cycles

## Example Scenarios

### Scenario 1: Form Validation

```swift
class RegistrationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isValid: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        Publishers.CombineLatest3($email, $password, $confirmPassword)
            .map { email, password, confirm in
                email.contains("@") &&
                password.count >= 8 &&
                password == confirm
            }
            .assign(to: &$isValid)
    }
}
```

### Scenario 2: Debounced Search

```swift
class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var results: [Result] = []
    @Published var isSearching: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map { text -> AnyPublisher<[Result], Never> in
                guard !text.isEmpty else {
                    return Just([]).eraseToAnyPublisher()
                }

                return self.search(text)
                    .catch { _ in Just([]) }
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .assign(to: &$results)
    }

    func search(_ query: String) -> AnyPublisher<[Result], Error> {
        // API call
        Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
```

### Scenario 3: Multiple Network Requests

```swift
func loadDashboard() -> AnyPublisher<Dashboard, Error> {
    let userPublisher = fetchUser()
    let postsPublisher = fetchPosts()
    let notificationsPublisher = fetchNotifications()

    return Publishers.Zip3(userPublisher, postsPublisher, notificationsPublisher)
        .map { user, posts, notifications in
            Dashboard(user: user, posts: posts, notifications: notifications)
        }
        .eraseToAnyPublisher()
}

loadDashboard()
    .receive(on: DispatchQueue.main)
    .sink(
        receiveCompletion: { completion in
            if case .failure(let error) = completion {
                showError(error)
            }
        },
        receiveValue: { dashboard in
            updateUI(dashboard)
        }
    )
    .store(in: &cancellables)
```

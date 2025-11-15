---
name: testing-fundamentals
description: Write effective unit tests, UI tests, and integration tests using Swift Testing framework and XCTest. Covers test-driven development (TDD), mocking, assertions, parameterized tests, async testing, and XCUITest for UI automation. Use when writing tests, implementing TDD, or improving test coverage.
version: 1.0.0
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# Testing Fundamentals

## What This Skill Does

Provides comprehensive guidance on testing Swift applications using both the modern Swift Testing framework (Xcode 16+) and the established XCTest framework. Covers unit testing, UI testing, test-driven development, and best practices for writing maintainable, reliable tests.

## When to Activate

- Writing unit tests for business logic and models
- Implementing UI tests for user workflows
- Practicing test-driven development (TDD)
- Testing async/await code and actors
- Creating parameterized tests with multiple inputs
- Setting up mocks and test doubles
- Improving test coverage and quality
- Migrating from XCTest to Swift Testing

## Core Concepts

### Swift Testing Framework (Xcode 16+)

**Swift Testing** is Apple's modern testing framework introduced at WWDC 2024, designed from the ground up for Swift with:

- **Macro-based**: Uses `@Test` instead of class methods starting with "test"
- **Expressive assertions**: Single `#expect` macro captures values and source
- **Parallel by default**: Tests run concurrently for better performance
- **Rich metadata**: Traits for categorization, tags, and bug tracking
- **Swift 6 native**: Full support for async/await and actors

### XCTest Framework

**XCTest** is the established testing framework that remains essential for:

- UI testing with XCUITest
- Performance testing with `measure` blocks
- Existing codebases
- Testing on iOS versions before the Swift Testing framework

Both frameworks can coexist in the same test target.

### Test-Driven Development (TDD)

TDD follows the Red-Green-Refactor cycle:

1. **Red**: Write a failing test first
2. **Green**: Implement minimal code to make it pass
3. **Refactor**: Improve code while keeping tests passing

Benefits: Better design, higher coverage, living documentation

## Implementation Patterns

### Swift Testing Basics

```swift
import Testing

@Test
func additionWorks() {
    let result = 2 + 2
    #expect(result == 4)
}

@Test
func divisionByZeroThrows() throws {
    #expect(throws: DivisionError.divideByZero) {
        try divide(10, by: 0)
    }
}

@Test
func arrayContainsElement() {
    let numbers = [1, 2, 3, 4, 5]
    #expect(numbers.contains(3))
}
```

**Key features:**
- `@Test` attribute marks test functions
- `#expect` for assertions (more expressive than XCTAssert)
- Captures actual values on failure
- Works with top-level functions, no class required

### Parameterized Tests

Test multiple inputs efficiently:

```swift
@Test(arguments: [1, 2, 3, 4, 5])
func isPositive(_ number: Int) {
    #expect(number > 0)
}

@Test(arguments: [
    ("hello", 5),
    ("world", 5),
    ("test", 4)
])
func stringLength(_ input: String, expectedLength: Int) {
    #expect(input.count == expectedLength)
}

// Custom types
struct TestCase {
    let input: String
    let expected: Int
}

@Test(arguments: [
    TestCase(input: "swift", expected: 5),
    TestCase(input: "testing", expected: 7)
])
func customParameterTest(_ testCase: TestCase) {
    #expect(testCase.input.count == testCase.expected)
}
```

### Test Traits and Organization

Use traits for metadata and organization:

```swift
@Test(.tags(.critical, .networking))
func fetchUserData() async throws {
    let user = try await api.fetchUser(id: "123")
    #expect(user.name != "")
}

@Test(.bug("FB12345678", "Crash when logging out"))
func logoutDoesNotCrash() {
    #expect(throws: Never.self) {
        try authService.logout()
    }
}

@Test(.disabled("Feature not implemented yet"))
func futureFeature() {
    // Test for upcoming feature
}

// Custom tags
extension Tag {
    @Tag static var critical: Self
    @Tag static var networking: Self
    @Tag static var database: Self
}
```

### Async Testing

Test async/await code naturally:

```swift
@Test
func asyncDataFetch() async throws {
    let data = try await networkService.fetchData()
    #expect(data.count > 0)
}

@Test
func multipleAsyncOperations() async throws {
    async let users = api.fetchUsers()
    async let posts = api.fetchPosts()

    let (userList, postList) = try await (users, posts)

    #expect(userList.count > 0)
    #expect(postList.count > 0)
}

@Test
func actorIsolation() async {
    let counter = Counter()
    await counter.increment()
    let value = await counter.value
    #expect(value == 1)
}
```

### XCTest Basics

```swift
import XCTest

class CalculatorTests: XCTestCase {
    var calculator: Calculator!

    override func setUp() {
        super.setUp()
        calculator = Calculator()
    }

    override func tearDown() {
        calculator = nil
        super.tearDown()
    }

    func testAddition() {
        let result = calculator.add(2, 3)
        XCTAssertEqual(result, 5)
    }

    func testDivisionByZero() {
        XCTAssertThrowsError(try calculator.divide(10, by: 0)) { error in
            XCTAssertEqual(error as? CalculatorError, .divideByZero)
        }
    }

    func testAsyncOperation() async throws {
        let result = try await calculator.asyncOperation()
        XCTAssertNotNil(result)
    }
}
```

**Common XCTest assertions:**
- `XCTAssertEqual(a, b)` - Values are equal
- `XCTAssertTrue(condition)` - Condition is true
- `XCTAssertNil(value)` - Value is nil
- `XCTAssertThrowsError(expression)` - Expression throws
- `XCTAssertNoThrow(expression)` - Expression doesn't throw

### Mocking and Test Doubles

Create test doubles for dependencies:

```swift
// Protocol for dependency
protocol DataService {
    func fetchData() async throws -> [Item]
}

// Mock implementation
class MockDataService: DataService {
    var shouldThrowError = false
    var mockItems: [Item] = []
    var fetchDataCallCount = 0

    func fetchData() async throws -> [Item] {
        fetchDataCallCount += 1

        if shouldThrowError {
            throw NetworkError.connectionFailed
        }

        return mockItems
    }
}

// Test using mock
@Test
func viewModelLoadingState() async {
    let mockService = MockDataService()
    mockService.mockItems = [Item(id: 1, name: "Test")]

    let viewModel = ViewModel(dataService: mockService)
    await viewModel.loadData()

    #expect(viewModel.items.count == 1)
    #expect(mockService.fetchDataCallCount == 1)
}

@Test
func viewModelErrorHandling() async {
    let mockService = MockDataService()
    mockService.shouldThrowError = true

    let viewModel = ViewModel(dataService: mockService)
    await viewModel.loadData()

    #expect(viewModel.errorMessage != nil)
}
```

### UI Testing with XCUITest

```swift
import XCTest

class AppUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testLoginFlow() {
        // Find elements using accessibility identifiers
        let emailField = app.textFields["emailTextField"]
        let passwordField = app.secureTextFields["passwordTextField"]
        let loginButton = app.buttons["loginButton"]

        // Interact with UI
        emailField.tap()
        emailField.typeText("user@example.com")

        passwordField.tap()
        passwordField.typeText("password123")

        loginButton.tap()

        // Verify result
        let welcomeText = app.staticTexts["welcomeLabel"]
        XCTAssertTrue(welcomeText.waitForExistence(timeout: 5))
        XCTAssertEqual(welcomeText.label, "Welcome!")
    }

    func testNavigationFlow() {
        let settingsButton = app.buttons["settingsButton"]
        settingsButton.tap()

        let settingsTitle = app.navigationBars["Settings"]
        XCTAssertTrue(settingsTitle.exists)

        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        backButton.tap()

        XCTAssertFalse(settingsTitle.exists)
    }

    func testListScrolling() {
        let list = app.tables.element
        let firstCell = list.cells.element(boundBy: 0)

        XCTAssertTrue(firstCell.exists)

        // Scroll to bottom
        let lastCell = list.cells.element(boundBy: 99)
        while !lastCell.exists {
            list.swipeUp()
        }

        XCTAssertTrue(lastCell.exists)
    }
}
```

**UI Testing best practices:**
- Always use accessibility identifiers
- Wait for elements with `waitForExistence(timeout:)`
- Use Page Object Model for complex flows
- Keep tests focused on user workflows
- Avoid testing implementation details

### Test-Driven Development Pattern

```swift
// 1. RED: Write failing test first
@Test
func userNameValidation() {
    let validator = UserValidator()
    let result = validator.validateName("John")
    #expect(result == .valid)
}

// Test fails - UserValidator doesn't exist yet

// 2. GREEN: Minimal implementation
struct UserValidator {
    enum ValidationResult {
        case valid
        case invalid(reason: String)
    }

    func validateName(_ name: String) -> ValidationResult {
        return .valid  // Simplest implementation
    }
}

// Test passes

// 3. REFACTOR: Add more tests and improve
@Test(arguments: [
    ("John", true),
    ("", false),
    ("AB", false),  // Too short
    ("A" + String(repeating: "a", count: 100), false)  // Too long
])
func nameValidationRules(_ name: String, shouldBeValid: Bool) {
    let validator = UserValidator()
    let result = validator.validateName(name)

    if shouldBeValid {
        #expect(result == .valid)
    } else {
        if case .invalid = result {
            // Expected
        } else {
            Issue.record("Expected invalid result")
        }
    }
}

// Now improve implementation
struct UserValidator {
    enum ValidationResult: Equatable {
        case valid
        case invalid(reason: String)
    }

    func validateName(_ name: String) -> ValidationResult {
        guard !name.isEmpty else {
            return .invalid(reason: "Name cannot be empty")
        }

        guard name.count >= 2 else {
            return .invalid(reason: "Name too short")
        }

        guard name.count <= 50 else {
            return .invalid(reason: "Name too long")
        }

        return .valid
    }
}
```

### Performance Testing

```swift
// XCTest performance measurement
func testPerformance() {
    let data = generateLargeDataSet()

    measure {
        _ = processData(data)
    }
}

func testPerformanceWithMetrics() {
    let options = XCTMeasureOptions()
    options.iterationCount = 10

    measure(metrics: [XCTClockMetric(), XCTMemoryMetric()], options: options) {
        _ = expensiveOperation()
    }
}
```

### Test Organization

```swift
// Group related tests
@Suite("User Authentication")
struct AuthenticationTests {
    @Test("Valid credentials")
    func successfulLogin() async throws {
        let auth = AuthService()
        let result = try await auth.login(email: "user@test.com", password: "pass123")
        #expect(result.isAuthenticated)
    }

    @Test("Invalid credentials")
    func failedLogin() async throws {
        let auth = AuthService()
        await #expect(throws: AuthError.invalidCredentials) {
            try await auth.login(email: "wrong@test.com", password: "wrong")
        }
    }
}

@Suite("Data Persistence")
struct PersistenceTests {
    // Related persistence tests
}
```

## Best Practices

1. **Write tests first (TDD)** - Design from the consumer's perspective, catch bugs early

2. **One assertion concept per test** - Test one thing at a time for clear failures

3. **Use descriptive test names** - Name should describe what is being tested and expected outcome

4. **Follow AAA pattern** - Arrange (setup), Act (execute), Assert (verify)

5. **Make tests independent** - Each test should work in isolation, any order

6. **Use mocks for dependencies** - Isolate unit under test from external dependencies

7. **Test edge cases** - Empty collections, nil values, boundaries, errors

8. **Keep tests fast** - Slow tests discourage running them frequently

9. **Don't test implementation** - Test behavior and contracts, not internal details

10. **Use accessibility identifiers for UI tests** - More stable than text or position

11. **Prefer Swift Testing for new code** - Better Swift integration and features

12. **Test asynchronous code properly** - Use async test methods or expectations

## Platform-Specific Considerations

### iOS/iPadOS
- UI tests must handle different screen sizes and orientations
- Test multitasking scenarios (Split View, Slide Over)
- Consider both iPhone and iPad layouts
- Test accessibility features (VoiceOver, Dynamic Type)

### macOS
- Test keyboard shortcuts and menu items
- Verify window management
- Test both mouse and trackpad interactions
- Consider multi-window scenarios

### watchOS
- Keep tests minimal due to resource constraints
- Focus on core functionality
- Test complications separately
- Verify Digital Crown interactions

### tvOS
- Test focus-based navigation thoroughly
- Verify Siri Remote interactions
- Test 10-foot UI readability
- No local storage testing needed

## Common Pitfalls

1. **Testing implementation instead of behavior**
   - ❌ Verifying internal state or method calls
   - ✅ Testing observable behavior and outcomes

2. **Fragile UI tests**
   - ❌ Using UI element text or positions
   - ✅ Using accessibility identifiers

3. **Not handling async properly**
   - ❌ Missing `async` or `await` keywords
   - ✅ Properly marking test functions as async

4. **Tests depending on each other**
   - ❌ Test B requires Test A to run first
   - ✅ Each test is completely independent

5. **Over-mocking**
   - ❌ Mocking everything, testing nothing real
   - ✅ Mock external dependencies, test real logic

6. **Ignoring test failures**
   - ❌ Disabling or skipping failing tests
   - ✅ Fix or remove failing tests immediately

7. **Not testing error cases**
   - ❌ Only testing happy path
   - ✅ Test error handling and edge cases

8. **Slow test suites**
   - ❌ Every test hits real network/database
   - ✅ Use mocks and fast in-memory alternatives

## Related Skills

- `swift-6-essentials` - Testing async/await and actor-isolated code
- `swiftui-essentials` - Testing SwiftUI views and view models
- `debugging-basics` - Debugging test failures
- `memory-management` - Testing for memory leaks

## Example Scenarios

### Scenario 1: TDD for Validation Logic

```swift
// Step 1: Write failing test
@Test
func emailValidation() {
    let validator = EmailValidator()
    #expect(validator.isValid("user@example.com"))
}

// Step 2: Minimal implementation
struct EmailValidator {
    func isValid(_ email: String) -> Bool {
        return true  // Simplest code to pass
    }
}

// Step 3: Add more tests
@Test(arguments: [
    ("user@example.com", true),
    ("invalid.email", false),
    ("", false),
    ("@example.com", false),
    ("user@", false)
])
func emailValidationRules(_ email: String, shouldBeValid: Bool) {
    let validator = EmailValidator()
    #expect(validator.isValid(email) == shouldBeValid)
}

// Step 4: Improve implementation
struct EmailValidator {
    func isValid(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email)
    }
}
```

### Scenario 2: Testing Async Network Service

```swift
@Test
func fetchUserSuccess() async throws {
    let mockService = MockNetworkService()
    mockService.mockResponse = User(id: "123", name: "John")

    let repository = UserRepository(networkService: mockService)
    let user = try await repository.fetchUser(id: "123")

    #expect(user.name == "John")
    #expect(mockService.fetchCallCount == 1)
}

@Test
func fetchUserNetworkError() async {
    let mockService = MockNetworkService()
    mockService.shouldFail = true

    let repository = UserRepository(networkService: mockService)

    await #expect(throws: NetworkError.self) {
        try await repository.fetchUser(id: "123")
    }
}
```

### Scenario 3: UI Test with Page Object Model

```swift
// Page Object
class LoginPage {
    let app: XCUIApplication

    var emailField: XCUIElement {
        app.textFields["emailTextField"]
    }

    var passwordField: XCUIElement {
        app.secureTextFields["passwordTextField"]
    }

    var loginButton: XCUIElement {
        app.buttons["loginButton"]
    }

    var errorLabel: XCUIElement {
        app.staticTexts["errorLabel"]
    }

    init(app: XCUIApplication) {
        self.app = app
    }

    func login(email: String, password: String) {
        emailField.tap()
        emailField.typeText(email)

        passwordField.tap()
        passwordField.typeText(password)

        loginButton.tap()
    }

    func waitForError(timeout: TimeInterval = 3) -> Bool {
        errorLabel.waitForExistence(timeout: timeout)
    }
}

// Test using Page Object
func testInvalidLogin() {
    let loginPage = LoginPage(app: app)
    loginPage.login(email: "wrong@test.com", password: "wrongpass")

    XCTAssertTrue(loginPage.waitForError())
    XCTAssertEqual(loginPage.errorLabel.label, "Invalid credentials")
}
```

### Scenario 4: Testing SwiftUI View Model

```swift
@Observable
class TodoViewModel {
    var todos: [Todo] = []
    var isLoading = false
    var errorMessage: String?

    func loadTodos() async {
        isLoading = true
        defer { isLoading = false }

        do {
            todos = try await fetchTodos()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func addTodo(_ title: String) {
        let todo = Todo(title: title, isCompleted: false)
        todos.append(todo)
    }
}

// Tests
@Test
func addTodoIncreaseCount() {
    let viewModel = TodoViewModel()
    viewModel.addTodo("Buy milk")

    #expect(viewModel.todos.count == 1)
    #expect(viewModel.todos[0].title == "Buy milk")
}

@Test
func loadTodosSetsLoadingState() async {
    let viewModel = TodoViewModel()

    let loadTask = Task {
        await viewModel.loadTodos()
    }

    // Check loading state
    try? await Task.sleep(nanoseconds: 100_000)
    #expect(viewModel.isLoading == true)

    await loadTask.value
    #expect(viewModel.isLoading == false)
}
```

### Scenario 5: Testing with Expectations (XCTest)

```swift
func testNotificationPosted() {
    let expectation = expectation(forNotification: .userDidLogin, object: nil)

    authService.login(email: "user@test.com", password: "pass123")

    wait(for: [expectation], timeout: 5)
}

func testAsyncCompletion() {
    let expectation = expectation(description: "Data fetched")
    var fetchedData: Data?

    dataService.fetchData { data in
        fetchedData = data
        expectation.fulfill()
    }

    wait(for: [expectation], timeout: 5)
    XCTAssertNotNil(fetchedData)
}
```

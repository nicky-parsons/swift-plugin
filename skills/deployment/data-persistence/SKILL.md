---
name: data-persistence
description: Persist data in Apple applications using SwiftData, Core Data, UserDefaults, Keychain, file storage, and CloudKit. Use when saving user data, caching, secure credential storage, or implementing offline-first applications. Covers models, queries, migrations, and iCloud sync.
version: 1.0.0
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# Data Persistence

## What This Skill Does

Provides comprehensive guidance on data persistence strategies in Apple platforms, including SwiftData (iOS 17+), Core Data, UserDefaults, Keychain Services, file-based storage, and CloudKit. Covers choosing the right persistence technology, implementing data models, queries, and migrations.

## When to Activate

- Saving and loading user data
- Implementing offline-first applications
- Caching network responses
- Storing user preferences and settings
- Securing sensitive data (passwords, tokens)
- Syncing data across devices with iCloud
- Migrating between persistence technologies
- Managing large datasets efficiently

## Core Concepts

### Persistence Technology Decision Matrix

**SwiftData** (iOS 17+):
- ✅ New applications
- ✅ Swift-native models with @Model macro
- ✅ Simple CRUD operations
- ✅ Automatic SwiftUI integration
- ❌ Need iOS 16 or earlier support

**Core Data**:
- ✅ Complex data models with relationships
- ✅ Large datasets (thousands+ of objects)
- ✅ Advanced querying and sorting
- ✅ Migration support
- ✅ iOS 3+ support
- ❌ Steep learning curve

**UserDefaults**:
- ✅ Small amounts of data (< 1MB)
- ✅ User preferences and settings
- ✅ Simple key-value storage
- ❌ NOT for sensitive data
- ❌ NOT for large datasets

**Keychain**:
- ✅ Passwords and authentication tokens
- ✅ Encryption keys
- ✅ Secure sensitive data
- ❌ NOT for large amounts of data

**File System**:
- ✅ Documents, images, videos
- ✅ Large files
- ✅ Custom formats
- ❌ Requires manual management

**CloudKit**:
- ✅ Cross-device sync
- ✅ Shared data between users
- ✅ Server-side logic
- ❌ Requires iCloud account

## Implementation Patterns

### SwiftData Basics

```swift
import SwiftData

// 1. Define models with @Model macro
@Model
class Todo {
    var title: String
    var isCompleted: Bool
    var dueDate: Date?
    @Relationship(.cascade) var subtasks: [Subtask]?

    init(title: String, isCompleted: Bool = false, dueDate: Date? = nil) {
        self.title = title
        self.isCompleted = isCompleted
        self.dueDate = dueDate
    }
}

@Model
class Subtask {
    var title: String
    var isCompleted: Bool

    init(title: String, isCompleted: Bool = false) {
        self.title = title
        self.isCompleted = isCompleted
    }
}

// 2. Configure model container in App
@main
struct TodoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Todo.self, Subtask.self])
    }
}

// 3. Use @Query in SwiftUI views
struct TodoListView: View {
    @Query(sort: \Todo.dueDate) var todos: [Todo]
    @Environment(\.modelContext) var modelContext

    var body: some View {
        List {
            ForEach(todos) { todo in
                TodoRow(todo: todo)
            }
            .onDelete(perform: deleteTodos)
        }
        .toolbar {
            Button("Add") {
                addTodo()
            }
        }
    }

    func addTodo() {
        let newTodo = Todo(title: "New Task")
        modelContext.insert(newTodo)
        // Auto-saves on scene phase change
    }

    func deleteTodos(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(todos[index])
        }
    }
}

// 4. Advanced queries
struct CompletedTodosView: View {
    @Query(
        filter: #Predicate<Todo> { $0.isCompleted == true },
        sort: \Todo.dueDate,
        order: .reverse
    ) var completedTodos: [Todo]

    var body: some View {
        List(completedTodos) { todo in
            Text(todo.title)
        }
    }
}
```

### SwiftData Relationships

```swift
@Model
class Author {
    var name: String
    @Relationship(.cascade, inverse: \Book.author) var books: [Book]?

    init(name: String) {
        self.name = name
    }
}

@Model
class Book {
    var title: String
    var author: Author?

    init(title: String, author: Author? = nil) {
        self.title = title
        self.author = author
    }
}

// Delete rules:
// .cascade - Delete related objects
// .nullify - Set relationship to nil
// .deny - Prevent deletion if relationships exist
```

### Core Data Stack

```swift
import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MyApp")

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error.localizedDescription)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
}
```

### Core Data CRUD Operations

```swift
import CoreData

// Create
func createTask(title: String) {
    let context = PersistenceController.shared.container.viewContext

    let task = Task(context: context)
    task.id = UUID()
    task.title = title
    task.createdAt = Date()
    task.isCompleted = false

    PersistenceController.shared.save()
}

// Read
func fetchTasks() -> [Task] {
    let context = PersistenceController.shared.container.viewContext

    let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

    do {
        return try context.fetch(fetchRequest)
    } catch {
        print("Failed to fetch tasks: \(error)")
        return []
    }
}

// Read with predicate
func fetchIncompleteTasks() -> [Task] {
    let context = PersistenceController.shared.container.viewContext

    let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "isCompleted == %@", NSNumber(value: false))
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]

    do {
        return try context.fetch(fetchRequest)
    } catch {
        print("Failed to fetch incomplete tasks: \(error)")
        return []
    }
}

// Update
func completeTask(_ task: Task) {
    task.isCompleted = true
    task.completedAt = Date()
    PersistenceController.shared.save()
}

// Delete
func deleteTask(_ task: Task) {
    let context = PersistenceController.shared.container.viewContext
    context.delete(task)
    PersistenceController.shared.save()
}
```

### UserDefaults

```swift
// Simple values
UserDefaults.standard.set("Dark", forKey: "theme")
UserDefaults.standard.set(true, forKey: "notificationsEnabled")
UserDefaults.standard.set(14.0, forKey: "fontSize")

// Retrieve
let theme = UserDefaults.standard.string(forKey: "theme") ?? "Light"
let notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
let fontSize = UserDefaults.standard.double(forKey: "fontSize")

// Codable objects
struct UserPreferences: Codable {
    var theme: String
    var fontSize: Double
    var notificationsEnabled: Bool
}

// Save Codable
let prefs = UserPreferences(theme: "Dark", fontSize: 14.0, notificationsEnabled: true)
if let encoded = try? JSONEncoder().encode(prefs) {
    UserDefaults.standard.set(encoded, forKey: "preferences")
}

// Load Codable
if let data = UserDefaults.standard.data(forKey: "preferences"),
   let prefs = try? JSONDecoder().decode(UserPreferences.self, from: data) {
    print("Theme: \(prefs.theme)")
}

// Remove value
UserDefaults.standard.removeObject(forKey: "theme")

// Property wrapper approach
@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

// Usage
struct Settings {
    @UserDefault(key: "theme", defaultValue: "Light")
    static var theme: String

    @UserDefault(key: "fontSize", defaultValue: 14.0)
    static var fontSize: Double
}

print(Settings.theme)
Settings.theme = "Dark"
```

### Keychain Services

```swift
import Security

class KeychainService {
    enum KeychainError: Error {
        case duplicateItem
        case unknown(OSStatus)
    }

    // Save password
    static func save(password: String, for account: String) throws {
        let data = password.data(using: .utf8)!

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateItem
        }

        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }

    // Retrieve password
    static func retrievePassword(for account: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                return nil
            }
            throw KeychainError.unknown(status)
        }

        guard let data = result as? Data,
              let password = String(data: data, encoding: .utf8) else {
            return nil
        }

        return password
    }

    // Update password
    static func update(password: String, for account: String) throws {
        let data = password.data(using: .utf8)!

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account
        ]

        let attributes: [String: Any] = [
            kSecValueData as String: data
        ]

        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)

        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }

    // Delete password
    static func delete(account: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account
        ]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unknown(status)
        }
    }
}

// Accessibility options:
// kSecAttrAccessibleWhenUnlocked - Most secure, only when device unlocked
// kSecAttrAccessibleAfterFirstUnlock - Balanced, available after first unlock
// kSecAttrAccessibleAlways - Least secure, always available (deprecated)
// kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly - Requires passcode set
```

### File Storage

```swift
class FileStorageService {
    static let shared = FileStorageService()

    // Get documents directory
    var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    // Save data
    func save(_ data: Data, filename: String) throws {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
    }

    // Load data
    func load(filename: String) throws -> Data {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        return try Data(contentsOf: fileURL)
    }

    // Delete file
    func delete(filename: String) throws {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        try FileManager.default.removeItem(at: fileURL)
    }

    // Check if file exists
    func exists(filename: String) -> Bool {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        return FileManager.default.fileExists(atPath: fileURL.path)
    }

    // List files
    func listFiles() throws -> [String] {
        let contents = try FileManager.default.contentsOfDirectory(
            at: documentsDirectory,
            includingPropertiesForKeys: nil
        )
        return contents.map { $0.lastPathComponent }
    }
}

// Codable file storage
extension FileStorageService {
    func save<T: Codable>(_ object: T, filename: String) throws {
        let data = try JSONEncoder().encode(object)
        try save(data, filename: filename)
    }

    func load<T: Codable>(filename: String, as type: T.Type) throws -> T {
        let data = try load(filename: filename)
        return try JSONDecoder().decode(type, from: data)
    }
}

// Usage
struct User: Codable {
    let id: UUID
    var name: String
    var email: String
}

let user = User(id: UUID(), name: "Alice", email: "alice@example.com")
try FileStorageService.shared.save(user, filename: "current-user.json")

let loadedUser = try FileStorageService.shared.load(filename: "current-user.json", as: User.self)
```

### CloudKit Basics

```swift
import CloudKit

class CloudKitService {
    let container = CKContainer.default()
    var privateDatabase: CKDatabase {
        container.privateCloudDatabase
    }

    // Save record
    func saveNote(title: String, content: String) async throws {
        let record = CKRecord(recordType: "Note")
        record["title"] = title as CKRecordValue
        record["content"] = content as CKRecordValue
        record["createdAt"] = Date() as CKRecordValue

        _ = try await privateDatabase.save(record)
    }

    // Fetch records
    func fetchNotes() async throws -> [CKRecord] {
        let query = CKQuery(recordType: "Note", predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

        let (results, _) = try await privateDatabase.records(matching: query)

        return results.compactMap { try? $0.1.get() }
    }

    // Update record
    func updateNote(_ record: CKRecord, title: String, content: String) async throws {
        record["title"] = title as CKRecordValue
        record["content"] = content as CKRecordValue
        record["modifiedAt"] = Date() as CKRecordValue

        _ = try await privateDatabase.save(record)
    }

    // Delete record
    func deleteNote(_ recordID: CKRecord.ID) async throws {
        _ = try await privateDatabase.deleteRecord(withID: recordID)
    }

    // Check iCloud status
    func checkiCloudStatus() async throws -> CKAccountStatus {
        try await container.accountStatus()
    }
}

// Usage
let cloudKit = CloudKitService()

Task {
    // Check if user is signed into iCloud
    let status = try await cloudKit.checkiCloudStatus()

    guard status == .available else {
        print("iCloud not available")
        return
    }

    // Save note
    try await cloudKit.saveNote(title: "My Note", content: "Hello CloudKit")

    // Fetch notes
    let notes = try await cloudKit.fetchNotes()
    print("Fetched \(notes.count) notes")
}
```

## Best Practices

1. **Choose the right persistence technology** - Match technology to data type and requirements

2. **Never store sensitive data in UserDefaults** - Use Keychain for passwords and tokens

3. **Save Core Data context on app backgrounding** - Prevent data loss

4. **Use lightweight migration when possible** - Automatic schema updates

5. **Implement offline-first** - Save locally, sync to cloud asynchronously

6. **Handle iCloud unavailability** - Always check account status

7. **Use file protection** - `.completeFileProtection` for sensitive files

8. **Batch operations for performance** - Don't save after every change

9. **Test data migration** - Critical for app updates

10. **Clean up old data** - Prevent unbounded growth

## Platform-Specific Considerations

### iOS/iPadOS
- File system sandboxed
- App Groups for sharing between apps
- Background save on app suspension
- iCloud ubiquitous containers

### macOS
- Less strict sandboxing
- User can access ~/Library
- Multiple windows = multiple contexts
- Larger storage capacity

### watchOS
- Extremely limited storage
- Prefer iCloud sync from iPhone
- Use minimal Core Data if necessary
- Aggressive data cleanup

### tvOS
- NO local storage (except caches)
- MUST use CloudKit for persistence
- Temporary cache directory only
- Focus on streaming/fetching data

## Common Pitfalls

1. **Not saving Core Data context**
   - ❌ Create objects but never save
   - ✅ Call `context.save()` after changes

2. **Storing sensitive data in UserDefaults**
   - ❌ Passwords in UserDefaults
   - ✅ Use Keychain for sensitive data

3. **Ignoring migration**
   - ❌ Change Core Data model without migration
   - ✅ Create model versions and mapping

4. **Not handling iCloud errors**
   - ❌ Assume iCloud always works
   - ✅ Check status, handle errors gracefully

5. **Blocking main thread with saves**
   - ❌ Synchronous saves on main thread
   - ✅ Use background contexts or async

6. **Not cleaning up temp files**
   - ❌ Unlimited file growth
   - ✅ Delete when no longer needed

7. **Forgetting file protection**
   - ❌ Saving files without protection
   - ✅ Use appropriate protection level

8. **Over-fetching in Core Data**
   - ❌ Fetch all objects when only need few
   - ✅ Use predicates and fetch limits

## Related Skills

- `swiftui-essentials` - Integrating persistence with SwiftUI
- `swift-6-essentials` - Async/await with persistence
- `debugging-basics` - Debugging persistence issues
- `app-lifecycle` - Saving data at appropriate times

## Example Scenarios

### Scenario 1: SwiftData Todo App

```swift
@Model
class TodoItem {
    var title: String
    var isCompleted: Bool
    var createdAt: Date

    init(title: String) {
        self.title = title
        self.isCompleted = false
        self.createdAt = Date()
    }
}

@main
struct TodoApp: App {
    var body: some Scene {
        WindowGroup {
            TodoListView()
        }
        .modelContainer(for: TodoItem.self)
    }
}

struct TodoListView: View {
    @Query(sort: \TodoItem.createdAt, order: .reverse) var todos: [TodoItem]
    @Environment(\.modelContext) var modelContext

    var body: some View {
        NavigationStack {
            List {
                ForEach(todos) { todo in
                    HStack {
                        Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                            .onTapGesture {
                                todo.isCompleted.toggle()
                            }
                        Text(todo.title)
                    }
                }
                .onDelete { offsets in
                    for index in offsets {
                        modelContext.delete(todos[index])
                    }
                }
            }
            .navigationTitle("Todos")
            .toolbar {
                Button("Add") {
                    let todo = TodoItem(title: "New Task")
                    modelContext.insert(todo)
                }
            }
        }
    }
}
```

### Scenario 2: Secure Credential Storage

```swift
class AuthService {
    func login(email: String, password: String) async throws -> String {
        // Authenticate with server
        let token = try await authenticateWithServer(email: email, password: password)

        // Store securely in Keychain
        try KeychainService.save(password: token, for: "authToken")

        return token
    }

    func getAuthToken() throws -> String? {
        try KeychainService.retrievePassword(for: "authToken")
    }

    func logout() throws {
        try KeychainService.delete(account: "authToken")
    }
}
```

### Scenario 3: Image Caching

```swift
class ImageCache {
    static let shared = ImageCache()

    private let fileManager = FileManager.default
    private let cacheDirectory: URL

    init() {
        let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        cacheDirectory = caches.appendingPathComponent("Images")

        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }

    func cache(_ image: UIImage, forKey key: String) {
        let filename = key.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? key
        let fileURL = cacheDirectory.appendingPathComponent(filename)

        guard let data = image.jpegData(compressionQuality: 0.8) else { return }

        try? data.write(to: fileURL)
    }

    func retrieveImage(forKey key: String) -> UIImage? {
        let filename = key.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? key
        let fileURL = cacheDirectory.appendingPathComponent(filename)

        guard let data = try? Data(contentsOf: fileURL) else { return nil }

        return UIImage(data: data)
    }

    func clearCache() {
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
}
```

### Scenario 4: Core Data Migration

```swift
// Model version 1
// Person: name (String)

// Model version 2 (add email)
// Person: name (String), email (String)

class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "MyApp")

        // Enable automatic lightweight migration
        let description = container.persistentStoreDescriptions.first
        description?.shouldMigrateStoreAutomatically = true
        description?.shouldInferMappingModelAutomatically = true

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data failed: \(error)")
            }
        }
    }
}
```

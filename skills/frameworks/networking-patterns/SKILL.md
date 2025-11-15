---
name: networking-patterns
description: Implement networking in Swift using URLSession with async/await, handle REST APIs, JSON decoding, error handling, authentication, request building, and response parsing. Use when making HTTP requests, consuming APIs, downloading files, or implementing network layers.
version: 1.0.0
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# Networking Patterns

## What This Skill Does

Provides comprehensive guidance on implementing networking in Swift applications using URLSession with async/await, REST API integration, JSON encoding/decoding, error handling, authentication, and modern networking architecture patterns.

## When to Activate

- Making HTTP/HTTPS requests to APIs
- Downloading or uploading files
- Parsing JSON responses
- Handling network errors and retries
- Implementing authentication (Bearer tokens, OAuth)
- Building REST API clients
- Monitoring network reachability
- Caching network responses

## Core Concepts

### URLSession

**URLSession** is Apple's modern API for networking:

- **Shared session**: `URLSession.shared` for simple requests
- **Custom session**: Configure timeouts, caching, cookies
- **Background session**: Downloads/uploads continue when app backgrounded
- **Async/await**: Native Swift concurrency support (iOS 15+)

### HTTP Methods

**GET**: Retrieve data
**POST**: Create new resource
**PUT**: Update entire resource
**PATCH**: Update partial resource
**DELETE**: Remove resource

### Status Codes

**2xx** - Success (200 OK, 201 Created, 204 No Content)
**3xx** - Redirection (301 Moved Permanently, 304 Not Modified)
**4xx** - Client Error (400 Bad Request, 401 Unauthorized, 404 Not Found)
**5xx** - Server Error (500 Internal Server Error, 503 Service Unavailable)

## Implementation Patterns

### Basic GET Request with Async/Await

```swift
struct User: Codable {
    let id: Int
    let name: String
    let email: String
}

func fetchUser(id: Int) async throws -> User {
    let url = URL(string: "https://api.example.com/users/\(id)")!

    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
        throw NetworkError.invalidResponse
    }

    let user = try JSONDecoder().decode(User.self, from: data)
    return user
}

// Usage
Task {
    do {
        let user = try await fetchUser(id: 123)
        print("User: \(user.name)")
    } catch {
        print("Error: \(error)")
    }
}
```

### POST Request with JSON Body

```swift
struct CreateUserRequest: Codable {
    let name: String
    let email: String
}

struct CreateUserResponse: Codable {
    let id: Int
    let name: String
    let email: String
}

func createUser(name: String, email: String) async throws -> CreateUserResponse {
    let url = URL(string: "https://api.example.com/users")!

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body = CreateUserRequest(name: name, email: email)
    request.httpBody = try JSONEncoder().encode(body)

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
        throw NetworkError.invalidResponse
    }

    let createdUser = try JSONDecoder().decode(CreateUserResponse.self, from: data)
    return createdUser
}
```

### Network Error Handling

```swift
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case unauthorized
    case notFound
    case serverError(statusCode: Int)
    case decodingError(Error)
    case networkFailure(Error)
    case noData
}

func fetchData<T: Decodable>(from url: URL) async throws -> T {
    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse else {
        throw NetworkError.invalidResponse
    }

    switch httpResponse.statusCode {
    case 200...299:
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw NetworkError.decodingError(error)
        }

    case 401:
        throw NetworkError.unauthorized

    case 404:
        throw NetworkError.notFound

    case 500...599:
        throw NetworkError.serverError(statusCode: httpResponse.statusCode)

    default:
        throw NetworkError.invalidResponse
    }
}

// Usage with error handling
Task {
    do {
        let users: [User] = try await fetchData(from: usersURL)
        print("Fetched \(users.count) users")
    } catch NetworkError.unauthorized {
        print("Please log in")
    } catch NetworkError.notFound {
        print("Resource not found")
    } catch NetworkError.decodingError(let error) {
        print("Failed to parse response: \(error)")
    } catch {
        print("Network error: \(error)")
    }
}
```

### API Client Architecture

```swift
protocol APIClient {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let headers: [String: String]?
    let body: Data?

    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }
}

class NetworkAPIClient: APIClient {
    private let baseURL: URL
    private let session: URLSession

    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        guard let url = URL(string: endpoint.path, relativeTo: baseURL) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        // Set headers
        endpoint.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}

// Usage
let apiClient = NetworkAPIClient(baseURL: URL(string: "https://api.example.com")!)

let endpoint = Endpoint(
    path: "/users",
    method: .get,
    headers: ["Authorization": "Bearer token"],
    body: nil
)

let users: [User] = try await apiClient.request(endpoint)
```

### Authentication with Bearer Token

```swift
class AuthenticatedAPIClient {
    private let baseURL: URL
    private var accessToken: String?

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func setAccessToken(_ token: String) {
        self.accessToken = token
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        var request = try buildRequest(for: endpoint)

        // Add authorization header
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        // Handle token refresh if needed
        if httpResponse.statusCode == 401 {
            try await refreshToken()
            // Retry request with new token
            return try await self.request(endpoint)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

    private func buildRequest(for endpoint: Endpoint) throws -> URLRequest {
        guard let url = URL(string: endpoint.path, relativeTo: baseURL) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        endpoint.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }

    private func refreshToken() async throws {
        // Implement token refresh logic
        // Update self.accessToken with new token
    }
}
```

### Download Files

```swift
func downloadFile(from url: URL, to destinationURL: URL) async throws {
    let (tempURL, response) = try await URLSession.shared.download(from: url)

    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
        throw NetworkError.invalidResponse
    }

    // Move from temp location to destination
    try FileManager.default.moveItem(at: tempURL, to: destinationURL)
}

// With progress tracking
func downloadFileWithProgress(from url: URL) async throws -> URL {
    let delegate = DownloadDelegate()

    let session = URLSession(
        configuration: .default,
        delegate: delegate,
        delegateQueue: nil
    )

    let (localURL, response) = try await session.download(from: url)

    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
        throw NetworkError.invalidResponse
    }

    return localURL
}

class DownloadDelegate: NSObject, URLSessionDownloadDelegate {
    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        // Handle completion
    }

    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64
    ) {
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        print("Download progress: \(progress * 100)%")
    }
}
```

### Upload Files

```swift
func uploadImage(_ image: UIImage) async throws -> UploadResponse {
    let url = URL(string: "https://api.example.com/upload")!

    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
        throw NetworkError.invalidData
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    // Create multipart form data
    let boundary = UUID().uuidString
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

    var body = Data()

    // Add image data
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
    body.append(imageData)
    body.append("\r\n".data(using: .utf8)!)
    body.append("--\(boundary)--\r\n".data(using: .utf8)!)

    request.httpBody = body

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
        throw NetworkError.invalidResponse
    }

    return try JSONDecoder().decode(UploadResponse.self, from: data)
}
```

### Background Downloads

```swift
class BackgroundDownloadService: NSObject {
    private var session: URLSession!
    private var completionHandlers: [String: () -> Void] = [:]

    override init() {
        super.init()

        let config = URLSessionConfiguration.background(withIdentifier: "com.app.background")
        config.isDiscretionary = true  // System chooses optimal time
        config.sessionSendsLaunchEvents = true

        session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }

    func startDownload(url: URL) {
        let task = session.downloadTask(with: url)
        task.resume()
    }
}

extension BackgroundDownloadService: URLSessionDownloadDelegate {
    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        // Move file from temp location
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(location.lastPathComponent)

        try? FileManager.default.moveItem(at: location, to: destinationURL)
    }

    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                  let backgroundCompletionHandler = appDelegate.backgroundCompletionHandler else {
                return
            }

            backgroundCompletionHandler()
        }
    }
}
```

### Request Retry Logic

```swift
actor RetryableAPIClient {
    private let maxRetries = 3
    private let retryDelay: TimeInterval = 2.0

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        var lastError: Error?

        for attempt in 0..<maxRetries {
            do {
                return try await performRequest(endpoint)
            } catch {
                lastError = error

                // Don't retry on client errors (4xx)
                if let networkError = error as? NetworkError,
                   case .unauthorized = networkError {
                    throw error
                }

                // Wait before retrying
                if attempt < maxRetries - 1 {
                    try await Task.sleep(nanoseconds: UInt64(retryDelay * Double(attempt + 1) * 1_000_000_000))
                }
            }
        }

        throw lastError ?? NetworkError.networkFailure
    }

    private func performRequest<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        // Actual request implementation
        fatalError("Implement request logic")
    }
}
```

### Caching Responses

```swift
class CachedAPIClient {
    private let cache = URLCache.shared
    private let session: URLSession

    init() {
        let config = URLSessionConfiguration.default
        config.urlCache = cache
        config.requestCachePolicy = .returnCacheDataElseLoad

        session = URLSession(configuration: config)
    }

    func fetchWithCache<T: Decodable>(from url: URL, maxAge: TimeInterval = 3600) async throws -> T {
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad

        // Add cache control header
        request.setValue("max-age=\(Int(maxAge))", forHTTPHeaderField: "Cache-Control")

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

    func clearCache() {
        cache.removeAllCachedResponses()
    }
}
```

## Best Practices

1. **Use async/await for networking** - Modern, readable asynchronous code

2. **Always validate HTTP status codes** - Don't assume 200 OK

3. **Decode JSON safely** - Handle decoding errors separately

4. **Implement proper error handling** - Distinguish between error types

5. **Use appropriate HTTP methods** - Follow REST conventions

6. **Set timeouts** - Prevent hanging requests

7. **Handle network reachability** - Check before making requests

8. **Implement retry logic** - For transient failures

9. **Use HTTPS** - Never send sensitive data over HTTP

10. **Cache responses appropriately** - Reduce network usage

## Platform-Specific Considerations

### iOS/iPadOS
- Background URL sessions for downloads/uploads
- App Transport Security (ATS) enforces HTTPS
- Network reachability important for cellular data
- Handle app backgrounding during requests

### macOS
- More lenient ATS requirements (can use HTTP in development)
- Network requests don't pause when app in background
- Can make network requests from command-line tools

### watchOS
- Extremely limited network capabilities
- Prefer fetching data from paired iPhone
- Very strict timeouts (30 seconds typical)
- Background transfers not supported

### tvOS
- Standard URLSession support
- No cellular network considerations
- Focus on streaming and large downloads

## Common Pitfalls

1. **Not checking status codes**
   - ❌ Assuming all responses are successful
   - ✅ Check `httpResponse.statusCode`

2. **Blocking main thread**
   - ❌ Synchronous networking on main thread
   - ✅ Use async/await or background queue

3. **Ignoring errors**
   - ❌ Empty catch blocks
   - ✅ Handle errors appropriately

4. **Not setting Content-Type**
   - ❌ Sending JSON without header
   - ✅ `request.setValue("application/json", forHTTPHeaderField: "Content-Type")`

5. **Force unwrapping URLs**
   - ❌ `URL(string: "...")!`
   - ✅ Guard let or throw error

6. **Not handling token expiration**
   - ❌ Retry same request with expired token
   - ✅ Refresh token and retry

7. **Ignoring network reachability**
   - ❌ Making requests when offline
   - ✅ Check reachability first

8. **Not using background sessions**
   - ❌ Large downloads that fail when app backgrounded
   - ✅ Use background URLSession configuration

## Related Skills

- `swift-6-essentials` - Async/await patterns
- `data-persistence` - Caching network responses
- `testing-fundamentals` - Mocking network requests
- `debugging-basics` - Debugging network issues

## Example Scenarios

### Scenario 1: Complete REST API Client

```swift
class UserAPIClient {
    private let baseURL = URL(string: "https://api.example.com")!
    private var authToken: String?

    func login(email: String, password: String) async throws -> String {
        struct LoginRequest: Codable {
            let email: String
            let password: String
        }

        struct LoginResponse: Codable {
            let token: String
        }

        let endpoint = Endpoint(
            path: "/auth/login",
            method: .post,
            headers: ["Content-Type": "application/json"],
            body: try? JSONEncoder().encode(LoginRequest(email: email, password: password))
        )

        let response: LoginResponse = try await request(endpoint)
        authToken = response.token
        return response.token
    }

    func fetchUsers() async throws -> [User] {
        let endpoint = Endpoint(
            path: "/users",
            method: .get,
            headers: authHeaders(),
            body: nil
        )

        return try await request(endpoint)
    }

    func createUser(name: String, email: String) async throws -> User {
        struct CreateRequest: Codable {
            let name: String
            let email: String
        }

        let endpoint = Endpoint(
            path: "/users",
            method: .post,
            headers: authHeaders().merging(["Content-Type": "application/json"]) { $1 },
            body: try? JSONEncoder().encode(CreateRequest(name: name, email: email))
        )

        return try await request(endpoint)
    }

    private func authHeaders() -> [String: String] {
        guard let token = authToken else { return [:] }
        return ["Authorization": "Bearer \(token)"]
    }

    private func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        guard let url = URL(string: endpoint.path, relativeTo: baseURL) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        endpoint.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
```

---
name: security-patterns
description: Implement security in Swift apps using CryptoKit for encryption, Keychain for credentials, certificate pinning, secure data handling, and authentication patterns. Use when securing user data, implementing authentication, encrypting sensitive information, or protecting against security threats.
version: 1.0.0
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# Security Patterns

## What This Skill Does

Comprehensive security implementation using CryptoKit, Keychain Services, certificate pinning, and secure coding practices for Apple platforms.

## When to Activate

- Storing sensitive data
- Implementing encryption
- Securing network communications
- Protecting user credentials
- Implementing authentication
- Securing app from tampering

## Core Concepts

### CryptoKit

Modern cryptography framework
- Symmetric encryption (AES-GCM)
- Asymmetric encryption (P256, P384, P521)
- Hashing (SHA256, SHA384, SHA512)
- Key derivation (HKDF)

### Keychain Services

Secure storage for credentials
- Passwords and tokens
- Encryption keys
- Certificates
- Protected by device passcode/biometrics

## Implementation Patterns

### Encryption with CryptoKit

```swift
import CryptoKit

class EncryptionService {
    // Generate symmetric key
    static func generateKey() -> SymmetricKey {
        SymmetricKey(size: .bits256)
    }

    // Encrypt data
    static func encrypt(data: Data, using key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.seal(data, using: key)
        return sealedBox.combined!
    }

    // Decrypt data
    static func decrypt(data: Data, using key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        return try AES.GCM.open(sealedBox, using: key)
    }
}

// Usage
let key = EncryptionService.generateKey()
let plaintext = "Sensitive data".data(using: .utf8)!

let encrypted = try EncryptionService.encrypt(data: plaintext, using: key)
let decrypted = try EncryptionService.decrypt(data: encrypted, using: key)
```

### Secure Key Storage

```swift
class SecureKeyStore {
    static func storeKey(_ key: SymmetricKey, identifier: String) throws {
        let keyData = key.withUnsafeBytes { Data($0) }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: identifier,
            kSecValueData as String: keyData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            throw KeychainError.unableToStore
        }
    }

    static func retrieveKey(identifier: String) throws -> SymmetricKey {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: identifier,
            kSecReturnData as String: true
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let keyData = result as? Data else {
            throw KeychainError.notFound
        }

        return SymmetricKey(data: keyData)
    }
}
```

### Certificate Pinning

```swift
class PinnedSessionDelegate: NSObject, URLSessionDelegate {
    let pinnedCertificates: [Data]

    init(certificates: [Data]) {
        self.pinnedCertificates = certificates
    }

    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        // Validate certificate
        if validateCertificate(serverTrust) {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }

    private func validateCertificate(_ trust: SecTrust) -> Bool {
        guard let serverCertificate = SecTrustGetCertificateAtIndex(trust, 0) else {
            return false
        }

        let serverCertData = SecCertificateCopyData(serverCertificate) as Data

        return pinnedCertificates.contains(serverCertData)
    }
}
```

### Biometric Authentication

```swift
import LocalAuthentication

class BiometricAuth {
    func authenticate() async throws -> Bool {
        let context = LAContext()

        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            throw AuthError.biometricsNotAvailable
        }

        return try await context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Authenticate to access your account"
        )
    }
}
```

## Best Practices

1. **Never hardcode secrets** - Use Keychain or environment
2. **Use HTTPS only** - Enforce with App Transport Security
3. **Validate certificates** - Implement certificate pinning
4. **Encrypt sensitive data** - Use CryptoKit, not custom crypto
5. **Use secure random** - SystemRandomNumberGenerator
6. **Clear sensitive data** - Overwrite before deallocation
7. **Implement biometrics** - Additional authentication layer
8. **Validate input** - Prevent injection attacks
9. **Use App Groups carefully** - Limit data sharing
10. **Regular security audits** - Test for vulnerabilities

## Related Skills

- `privacy-compliance` - Privacy requirements
- `deployment-essentials` - App Store security requirements
- `networking-patterns` - Secure networking
- `data-persistence` - Secure storage

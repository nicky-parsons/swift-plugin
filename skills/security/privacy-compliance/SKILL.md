---
name: privacy-compliance
description: Implement privacy compliance including Privacy Manifests, App Tracking Transparency, permission requests, data collection disclosure, and privacy nutrition labels. Use when preparing for App Store submission, handling user data, requesting permissions, or ensuring GDPR/privacy compliance.
version: 1.0.0
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# Privacy Compliance

## What This Skill Does

Guide to implementing privacy requirements including Privacy Manifests (iOS 17+), App Tracking Transparency, permission handling, and App Store privacy nutrition labels.

## When to Activate

- Creating Privacy Manifest
- Implementing App Tracking Transparency
- Requesting user permissions
- Preparing App Store submission
- Handling user data collection
- Ensuring GDPR compliance

## Privacy Manifest (iOS 17+)

### PrivacyInfo.xcprivacy

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- Tracking -->
    <key>NSPrivacyTracking</key>
    <false/>

    <!-- Tracking Domains -->
    <key>NSPrivacyTrackingDomains</key>
    <array>
        <string>example.com</string>
    </array>

    <!-- Collected Data Types -->
    <key>NSPrivacyCollectedDataTypes</key>
    <array>
        <dict>
            <key>NSPrivacyCollectedDataType</key>
            <string>NSPrivacyCollectedDataTypeEmailAddress</string>

            <key>NSPrivacyCollectedDataTypeLinked</key>
            <true/>

            <key>NSPrivacyCollectedDataTypeTracking</key>
            <false/>

            <key>NSPrivacyCollectedDataTypePurposes</key>
            <array>
                <string>NSPrivacyCollectedDataTypePurposeAppFunctionality</string>
            </array>
        </dict>
    </array>

    <!-- Accessed API Types -->
    <key>NSPrivacyAccessedAPITypes</key>
    <array>
        <dict>
            <key>NSPrivacyAccessedAPIType</key>
            <string>NSPrivacyAccessedAPICategoryUserDefaults</string>

            <key>NSPrivacyAccessedAPITypeReasons</key>
            <array>
                <string>CA92.1</string>
            </array>
        </dict>
    </array>
</dict>
</plist>
```

### App Tracking Transparency

```swift
import AppTrackingTransparency
import AdSupport

class TrackingManager {
    func requestPermission() async -> Bool {
        guard #available(iOS 14, *) else { return false }

        let status = await ATTrackingManager.requestTrackingAuthorization()

        switch status {
        case .authorized:
            // Tracking authorized
            let idfa = ASIdentifierManager.shared().advertisingIdentifier
            return true

        case .denied, .restricted, .notDetermined:
            return false

        @unknown default:
            return false
        }
    }
}

// Info.plist key required:
// NSUserTrackingUsageDescription: "We use tracking to show relevant ads"
```

### Permission Requests

```swift
// Info.plist descriptions:
// NSLocationWhenInUseUsageDescription
// NSPhotoLibraryUsageDescription
// NSCameraUsageDescription
// NSMicrophoneUsageDescription
// NSContactsUsageDescription
// NSCalendarsUsageDescription
// NSRemindersUsageDescription
// NSMotionUsageDescription
// NSBluetoothAlwaysUsageDescription
// NSFaceIDUsageDescription

// Request with clear purpose
class PermissionManager {
    func requestPhotoLibrary() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized, .limited:
                // Access granted
                break

            case .denied, .restricted:
                // Show settings alert
                self.showSettingsAlert()

            case .notDetermined:
                break

            @unknown default:
                break
            }
        }
    }

    private func showSettingsAlert() {
        // Guide user to Settings
    }
}
```

## App Store Privacy Nutrition Labels

### Data Types

- Contact Info (name, email, phone)
- Health & Fitness
- Financial Info
- Location
- Sensitive Info
- Contacts
- User Content
- Browsing History
- Search History
- Identifiers
- Purchases
- Usage Data
- Diagnostics
- Other Data

### Usage Purposes

- App Functionality
- Analytics
- Developer Advertising
- Third-Party Advertising
- Product Personalization
- Other Purposes

## Best Practices

1. **Be transparent** - Clearly explain data collection
2. **Minimize collection** - Only collect necessary data
3. **Request at appropriate time** - Context matters
4. **Provide alternatives** - Offer functionality without permissions
5. **Respect denial** - Gracefully handle permission denial
6. **Update privacy policy** - Keep URL current
7. **Regular audits** - Review data collection practices
8. **Third-party SDKs** - Document in Privacy Manifest
9. **Test permissions** - Reset and test permission flows
10. **GDPR compliance** - Allow data deletion requests

## Related Skills

- `deployment-essentials` - App Store submission
- `security-patterns` - Data protection
- `app-lifecycle` - Permission timing
- `data-persistence` - Secure data storage

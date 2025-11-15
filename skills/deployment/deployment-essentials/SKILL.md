---
name: deployment-essentials
description: Deploy Apple applications to the App Store including code signing, provisioning profiles, certificates, TestFlight beta testing, App Store Connect configuration, review guidelines, and submission process for iOS, iPadOS, macOS, watchOS, tvOS, and visionOS apps.
version: 1.0.0
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# Deployment Essentials

## What This Skill Does

Provides comprehensive guidance on deploying applications to the Apple App Store, including code signing, provisioning profiles, certificates, TestFlight distribution, App Store Connect setup, review guidelines compliance, and the submission process across all Apple platforms.

## When to Activate

- Preparing app for App Store submission
- Setting up code signing and certificates
- Creating provisioning profiles
- Distributing beta builds via TestFlight
- Configuring App Store Connect metadata
- Understanding App Store Review Guidelines
- Troubleshooting submission rejections
- Managing app versions and builds

## Core Concepts

### Apple Developer Program

**Membership required** ($99/year) to:
- Distribute on App Store
- Use TestFlight
- Access beta software
- Submit apps for review
- Use advanced capabilities (Push Notifications, Apple Pay, etc.)

### Code Signing

**Ensures app authenticity**:
- **Development**: Testing on physical devices
- **Distribution**: App Store, Ad Hoc, Enterprise

**Components**:
- Certificate (identity)
- Provisioning Profile (combines certificate + app ID + devices + entitlements)
- App ID (unique identifier)

### App Store Review

**90% reviewed within 24 hours**

**Common rejection reasons**:
- Crashes or bugs (Guideline 2.1)
- Incomplete information (2.1)
- Inaccurate metadata (2.3)
- Privacy violations (5.1)
- Intellectual property issues (5.2)

## Implementation Patterns

### Setting Up Code Signing (Xcode)

```bash
# Automatic signing (recommended for simple projects)
# 1. Select target in Xcode
# 2. Signing & Capabilities tab
# 3. Check "Automatically manage signing"
# 4. Select team
# Xcode handles everything automatically

# Manual signing (for complex setups, CI/CD)
# 1. Uncheck "Automatically manage signing"
# 2. Select provisioning profile for each configuration
# 3. Ensure certificate is installed in Keychain
```

### Creating Certificates

```bash
# Development Certificate
# 1. Go to developer.apple.com → Certificates
# 2. Click "+" to create
# 3. Select "Apple Development"
# 4. Create CSR (Certificate Signing Request):
#    - Open Keychain Access
#    - Certificate Assistant → Request Certificate from CA
#    - Enter email, name
#    - Save to disk
# 5. Upload CSR
# 6. Download certificate
# 7. Double-click to install in Keychain

# Distribution Certificate
# Same process but select "Apple Distribution"
```

### Creating App ID

```bash
# App ID (Bundle Identifier)
# 1. developer.apple.com → Identifiers
# 2. Click "+"
# 3. Select "App IDs"
# 4. Enter description: "My Awesome App"
# 5. Enter Bundle ID: "com.company.myapp"
# 6. Select capabilities:
#    - Push Notifications
#    - In-App Purchase
#    - iCloud
#    - etc.
# 7. Register
```

### Creating Provisioning Profiles

```bash
# Development Profile
# 1. developer.apple.com → Profiles
# 2. Click "+"
# 3. Select "iOS App Development"
# 4. Select App ID
# 5. Select certificate(s)
# 6. Select devices for testing
# 7. Name: "My App Development"
# 8. Download and install (double-click)

# Distribution Profile (App Store)
# 1. Select "App Store"
# 2. Select App ID
# 3. Select distribution certificate
# 4. Name: "My App App Store"
# 5. Download and install
```

### App Store Connect Setup

```swift
// 1. Create app in App Store Connect
// - appstoreconnect.apple.com
// - My Apps → "+" → New App
// - Select platform (iOS, macOS, etc.)
// - Enter name
// - Select primary language
// - Bundle ID (must match Xcode)
// - SKU (internal identifier)

// 2. Fill required metadata:
// - App name (30 characters max)
// - Subtitle (30 characters) - iOS 11+
// - Privacy Policy URL
// - Category (primary & secondary)
// - Age Rating questionnaire
// - App description (4000 characters)
// - Keywords (100 characters, comma-separated)
// - Support URL
// - Marketing URL (optional)

// 3. Screenshots (required):
// iOS:
// - 6.7" display (iPhone 14 Pro Max)
// - 6.5" display (iPhone 11 Pro Max)
// - 5.5" display (iPhone 8 Plus)

// iPad:
// - 12.9" display (iPad Pro 12.9")
// - 12.9" display 2nd gen

// macOS:
// - At least 1280 x 800 pixels

// 4. App Preview videos (optional)
// - 30 seconds max
// - Show app in use
```

### Build and Archive

```bash
# In Xcode:
# 1. Select "Any iOS Device" or "Any Mac"
# 2. Product → Archive
# 3. Wait for build and archive
# 4. Organizer window opens automatically
# 5. Select archive
# 6. Click "Distribute App"
# 7. Select "App Store Connect"
# 8. Click "Upload"
# 9. Select signing options (automatic recommended)
# 10. Click "Upload"
```

### Using Fastlane

```ruby
# Fastfile
default_platform(:ios)

platform :ios do
  desc "Push a new beta build to TestFlight"
  lane :beta do
    # Increment build number
    increment_build_number(xcodeproj: "MyApp.xcodeproj")

    # Build the app
    build_app(
      scheme: "MyApp",
      export_method: "app-store"
    )

    # Upload to TestFlight
    upload_to_testflight(
      skip_waiting_for_build_processing: true
    )

    # Send notification
    slack(
      message: "New TestFlight build uploaded!"
    )
  end

  desc "Submit to App Store"
  lane :release do
    # Take screenshots
    snapshot

    # Build and upload
    build_app(scheme: "MyApp")
    upload_to_app_store

    # Send notification
    slack(message: "App submitted to App Store!")
  end
end

# Run with:
# fastlane beta
# fastlane release
```

### TestFlight Distribution

```swift
// 1. Upload build (via Xcode or fastlane)

// 2. In App Store Connect:
// - Go to TestFlight tab
// - Select build
// - Add "What to Test" notes
// - Export compliance: Answer questions
// - Add internal testers (automatic)
// - Add external testers:
//   - Create testing group
//   - Add testers (email addresses)
//   - Select build
//   - Submit for Beta App Review (first time only)

// 3. Testers receive invitation email
// 4. Install TestFlight app
// 5. Accept invitation
// 6. Install and test app
// 7. Provide feedback via TestFlight

// Best practices:
// - Update "What to Test" for each build
// - Use internal testing first
// - External testing requires Beta Review
// - Limit external group to 10,000 testers
// - Builds expire after 90 days
```

### App Store Submission

```swift
// 1. In App Store Connect, select version
// 2. Complete all required fields:
//    - Screenshots for all required sizes
//    - Description
//    - Keywords
//    - Support URL
//    - Privacy Policy URL
//    - Category

// 3. Select build from TestFlight

// 4. Content Rights:
//    - ✓ Yes if you own all rights
//    - Contact info for third-party content

// 5. Advertising Identifier:
//    - ✓ Yes if using IDFA for ads
//    - Select usage (attribution, advertising, etc.)

// 6. Export Compliance:
//    - Answer encryption questions
//    - Most apps: "No" (uses standard encryption)

// 7. Version Release:
//    - Automatic (after approval)
//    - Manual (you choose when)

// 8. Click "Submit for Review"

// 9. Wait for review (usually < 24 hours)

// 10. If approved:
//     - Automatic: App goes live
//     - Manual: Click "Release this version"

// 11. If rejected:
//     - Read rejection reason
//     - Fix issues
//     - Respond in Resolution Center
//     - Resubmit
```

### Privacy Manifest (iOS 17+)

```swift
// PrivacyInfo.xcprivacy
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>NSPrivacyTracking</key>
    <false/>

    <key>NSPrivacyTrackingDomains</key>
    <array/>

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

### Version and Build Numbers

```swift
// Version: User-facing (1.0.0, 1.1.0, 2.0.0)
// Build: Internal (1, 2, 3, 4...)

// In Xcode:
// Target → General
// - Version: 1.0.0
// - Build: 1

// Increment for each upload:
// - Same version, new build for TestFlight
// - New version for App Store release

// Automated with agvtool:
// agvtool next-version -all  # Increment build
// agvtool new-marketing-version 1.1.0  # Set version

// Or in build script:
#!/bin/bash
BUILD_NUMBER=$(($(git rev-list HEAD --count)))
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BUILD_NUMBER" Info.plist
```

### App Store Review Guidelines Summary

```swift
// Critical guidelines to follow:

// 1. Completeness (2.1)
// - App must be fully functional
// - No crashes or bugs
// - Include demo account if needed
// - Complete metadata and screenshots

// 2. Accurate Metadata (2.3)
// - Screenshots must show actual app
// // - Description must match functionality
// - No misleading claims

// 3. Minimum Functionality (4.2)
// - Must do more than display website
// - Sufficient content and features
// - More than just a web wrapper

// 4. Privacy (5.1)
// - Privacy Policy required if collecting data
// - Request permissions with clear purpose
// - Don't access unnecessary data
// - Privacy manifest (iOS 17+)

// 5. Intellectual Property (5.2)
// - Use only owned or licensed content
// - No trademark violations
// - No misleading similarities

// 6. Human Interface Guidelines
// - Follow platform conventions
// - Proper use of system features
// - No private APIs

// 7. Business (3)
// - Correct in-app purchase implementation
// - No circumventing payment system
// - Clear subscription terms
```

## Best Practices

1. **Use automatic signing for simple projects** - Less maintenance, fewer issues

2. **Test thoroughly before submitting** - Crashes lead to instant rejection

3. **Provide demo account credentials** - Helps reviewers test login features

4. **Write accurate app description** - Must match actual functionality

5. **Take high-quality screenshots** - Show app in use, not just splash screens

6. **Include privacy policy** - Required if collecting any user data

7. **Test on multiple devices** - Different screen sizes and iOS versions

8. **Increment build number** - Each upload must have unique build number

9. **Use TestFlight first** - Catch issues before App Store submission

10. **Respond quickly to rejections** - Address issues and resubmit promptly

## Platform-Specific Considerations

### iOS/iPadOS
- Must support latest SDK within months of release
- iPhone apps must run on iPad
- Screenshots required for multiple sizes
- Support dark mode (recommended)
- Accessibility features recommended

### macOS
- Notarization required for distribution outside App Store
- Code signing more complex (optional sandboxing)
- DMG or PKG installer
- App category important for discovery

### watchOS
- Requires companion iOS app
- Watch-only apps supported (watchOS 6+)
- Complications must provide value
- Limited time for review testing

### tvOS
- Top Shelf image required
- Focus-based navigation must work
- Test with Siri Remote and game controllers
- No local storage to test

### visionOS
- New platform with evolving guidelines
- 3D assets and spatial design
- Privacy considerations for eye tracking
- Comfort and accessibility critical

## Common Pitfalls

1. **Missing screenshots**
   - ❌ Not providing all required sizes
   - ✅ Screenshots for all device sizes

2. **Crashes during review**
   - ❌ Untested code paths
   - ✅ Thorough testing, including edge cases

3. **Inaccurate metadata**
   - ❌ Screenshots showing features not in app
   - ✅ Honest representation of functionality

4. **Missing privacy policy**
   - ❌ No URL when collecting data
   - ✅ Clear, accessible privacy policy

5. **Wrong provisioning profile**
   - ❌ Using development profile for distribution
   - ✅ App Store distribution profile

6. **Forgetting export compliance**
   - ❌ Not answering encryption questions
   - ✅ Complete export compliance section

7. **Not testing on device**
   - ❌ Only simulator testing
   - ✅ Test on actual devices

8. **Using private APIs**
   - ❌ Accessing undocumented frameworks
   - ✅ Only use public APIs

## Related Skills

- `debugging-basics` - Fixing crashes before submission
- `testing-fundamentals` - Comprehensive testing
- `app-lifecycle` - Proper state management
- `cross-platform-patterns` - Multi-platform apps

## Example Scenarios

### Scenario 1: First-Time Submission Checklist

```markdown
## Pre-Submission Checklist

### Code
- [ ] App builds without errors
- [ ] No crashes during testing
- [ ] Tested on multiple devices
- [ ] Tested on latest iOS version
- [ ] All features working
- [ ] Network error handling implemented
- [ ] No hardcoded test data
- [ ] Removed all NSLog/print debugging
- [ ] App icon included (all sizes)
- [ ] Launch screen implemented

### Code Signing
- [ ] Distribution certificate installed
- [ ] App Store provisioning profile created
- [ ] Bundle ID matches App Store Connect
- [ ] Capabilities configured correctly
- [ ] Entitlements file correct

### App Store Connect
- [ ] App created in App Store Connect
- [ ] Version number set
- [ ] Build uploaded and selected
- [ ] App name (30 characters max)
- [ ] Description written (4000 characters max)
- [ ] Keywords added (100 characters)
- [ ] Screenshots uploaded (all sizes)
- [ ] Privacy Policy URL added
- [ ] Support URL added
- [ ] Category selected
- [ ] Age rating completed
- [ ] Pricing and availability set

### Privacy
- [ ] Privacy Policy created and hosted
- [ ] Privacy manifest added (iOS 17+)
- [ ] Permission descriptions in Info.plist
- [ ] Data collection documented
- [ ] Third-party SDKs disclosed

### Review
- [ ] Demo account provided (if needed)
- [ ] Review notes added (if needed)
- [ ] Export compliance answered
- [ ] Content rights confirmed

### Final
- [ ] Submitted for review
- [ ] Team notified
```

### Scenario 2: Handling Rejection

```markdown
## Rejection Response Process

### 1. Read Rejection Carefully
- Identify specific guideline violated
- Note exact reason provided
- Check any screenshots or videos provided

### 2. Common Rejections and Fixes

**Guideline 2.1 - Crashes**
- Fix: Test thoroughly, fix all crashes
- Use Xcode debugging and Instruments
- Test on multiple devices and iOS versions

**Guideline 2.3 - Inaccurate Metadata**
- Fix: Update screenshots to show actual app
- Rewrite description to match functionality
- Remove any misleading claims

**Guideline 4.2 - Minimum Functionality**
- Fix: Add more features
- Ensure app provides value beyond website
- Add offline functionality

**Guideline 5.1 - Privacy**
- Fix: Add privacy policy
- Update permission descriptions
- Remove unnecessary data collection

### 3. Respond in Resolution Center
- Explain what was fixed
- Provide additional context if needed
- Be professional and concise

### 4. Resubmit
- Upload new build if code changed
- Update metadata if needed
- Submit for review again

### 5. Typical Response Time
- Usually reviewed again within 24 hours
- Can request expedited review (rare circumstances only)
```

### Scenario 3: CI/CD with GitHub Actions

```yaml
# .github/workflows/deploy.yml
name: Deploy to TestFlight

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: macos-latest

    steps:
    - uses: actions/checkout@v3

    - name: Install signing certificate
      env:
        BUILD_CERTIFICATE_BASE64: ${{ secrets.BUILD_CERTIFICATE_BASE64 }}
        P12_PASSWORD: ${{ secrets.P12_PASSWORD }}
        KEYCHAIN_PASSWORD: ${{ secrets.KEYCHAIN_PASSWORD }}
      run: |
        # Create temporary keychain
        security create-keychain -p "$KEYCHAIN_PASSWORD" build.keychain
        security default-keychain -s build.keychain
        security unlock-keychain -p "$KEYCHAIN_PASSWORD" build.keychain

        # Import certificate
        echo $BUILD_CERTIFICATE_BASE64 | base64 --decode > certificate.p12
        security import certificate.p12 -k build.keychain -P "$P12_PASSWORD" -T /usr/bin/codesign
        security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k "$KEYCHAIN_PASSWORD" build.keychain

    - name: Install provisioning profile
      env:
        PROVISIONING_PROFILE_BASE64: ${{ secrets.PROVISIONING_PROFILE_BASE64 }}
      run: |
        mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
        echo $PROVISIONING_PROFILE_BASE64 | base64 --decode > ~/Library/MobileDevice/Provisioning\ Profiles/profile.mobileprovision

    - name: Build and archive
      run: |
        xcodebuild -scheme MyApp \
                   -archivePath MyApp.xcarchive \
                   -configuration Release \
                   clean archive

    - name: Export IPA
      run: |
        xcodebuild -exportArchive \
                   -archivePath MyApp.xcarchive \
                   -exportPath export \
                   -exportOptionsPlist ExportOptions.plist

    - name: Upload to TestFlight
      env:
        APPLE_ID: ${{ secrets.APPLE_ID }}
        APP_PASSWORD: ${{ secrets.APP_PASSWORD }}
      run: |
        xcrun altool --upload-app \
                     --type ios \
                     --file export/MyApp.ipa \
                     --username "$APPLE_ID" \
                     --password "$APP_PASSWORD"
```

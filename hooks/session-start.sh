#!/bin/bash

# Swift/Xcode Project Detection Hook
# Runs on session start to provide helpful context

# Check for Swift project indicators
has_swift_files=$(find . -maxdepth 3 -name "*.swift" 2>/dev/null | head -1)
has_xcode_project=$(find . -maxdepth 2 -name "*.xcodeproj" 2>/dev/null | head -1)
has_package_swift=$(find . -maxdepth 2 -name "Package.swift" 2>/dev/null | head -1)
has_podfile=$(find . -maxdepth 1 -name "Podfile" 2>/dev/null | head -1)

# If this is a Swift project, provide helpful context
if [ -n "$has_swift_files" ] || [ -n "$has_xcode_project" ] || [ -n "$has_package_swift" ]; then
    echo "🎯 Swift/Xcode project detected!"
    echo ""
    echo "Available Swift plugin commands:"
    echo "  /new-swiftui-view - Scaffold a new SwiftUI view"
    echo "  /review-memory - Analyze for memory leaks"
    echo "  /optimize-performance - Performance analysis"
    echo "  /add-tests - Generate test coverage"
    echo "  /fix-accessibility - Accessibility audit"
    echo "  /setup-storekit - Setup in-app purchases"
    echo ""

    # Detect project type
    if [ -n "$has_xcode_project" ]; then
        project_name=$(basename "$has_xcode_project" .xcodeproj)
        echo "📦 Xcode project: $project_name"
    fi

    if [ -n "$has_package_swift" ]; then
        echo "📦 Swift Package Manager project detected"
    fi

    if [ -n "$has_podfile" ]; then
        echo "📦 CocoaPods detected"
    fi

    # Check Swift version
    if command -v swift &> /dev/null; then
        swift_version=$(swift --version 2>&1 | head -1)
        echo "⚡ $swift_version"
    fi

    echo ""
    echo "I have access to 23 specialized Swift/Xcode skills covering:"
    echo "  • Swift 6 & concurrency"
    echo "  • SwiftUI & UIKit/AppKit"
    echo "  • Testing & debugging"
    echo "  • Performance & security"
    echo "  • All Apple platforms (iOS, macOS, watchOS, tvOS, visionOS)"
    echo ""
    echo "Just ask me anything about your Swift project!"
fi

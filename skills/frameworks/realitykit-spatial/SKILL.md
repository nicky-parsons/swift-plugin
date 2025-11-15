---
name: realitykit-spatial
description: Build spatial computing experiences with RealityKit for visionOS and AR applications using 3D models, entities, components, systems, anchors, spatial audio, and hand tracking. Use when creating visionOS apps, AR experiences, or 3D content for Apple platforms.
version: 1.0.0
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# RealityKit and Spatial Computing

## What This Skill Does

Guide for building spatial computing experiences with RealityKit, focusing on visionOS and AR. Covers entities, components, 3D models, spatial audio, and hand tracking.

## When to Activate

- Creating visionOS applications
- Building AR experiences
- Working with 3D models
- Implementing spatial audio
- Hand tracking and gestures
- Creating immersive spaces

## Core Concepts

### Entity-Component-System (ECS)

**Entity**: Object in 3D scene
**Component**: Data attached to entity (ModelComponent, Transform, etc.)
**System**: Logic that operates on components

### Reality

Composer for designing 3D scenes
Export as .reality or .usdz files
Drag-and-drop workflow

## Implementation Patterns

### Basic RealityKit Scene (visionOS)

```swift
import SwiftUI
import RealityKit

struct ImmersiveView: View {
    var body: some View {
        RealityView { content in
            // Load 3D model
            guard let entity = try? await Entity(named: "Scene", in: realityKitContentBundle) else { return }

            content.add(entity)
        }
    }
}
```

### Creating Entities Programmatically

```swift
func createBox() -> ModelEntity {
    let mesh = MeshResource.generateBox(size: 0.1)
    let material = SimpleMaterial(color: .blue, isMetallic: true)
    let entity = ModelEntity(mesh: mesh, materials: [material])

    entity.position = [0, 1, -2]

    return entity
}
```

### Spatial Audio

```swift
let audioResource = try await AudioFileResource(named: "sound.mp3")
let audioController = entity.prepareAudio(audioResource)
audioController.play()
```

### Hand Tracking

```swift
import ARKit

let session = ARKitSession()
let handTracking = HandTrackingProvider()

try await session.run([handTracking])

for await update in handTracking.anchorUpdates {
    switch update.event {
    case .added, .updated:
        let anchor = update.anchor

        // Access hand joints
        let wrist = anchor.handSkeleton?.joint(.wrist)
        let indexTip = anchor.handSkeleton?.joint(.indexFingerTip)
    }
}
```

## Best Practices

1. **Optimize 3D models** - Keep polygon count reasonable
2. **Use occlusion** - Hide objects behind real-world surfaces
3. **Test on device** - Simulator limited for spatial computing
4. **Implement spatial audio** - Enhances immersion
5. **Handle permissions** - World sensing, hand tracking
6. **Design for comfort** - Avoid motion sickness
7. **Use Reality Composer** - Rapid prototyping
8. **Anchor properly** - Use planes, images, or world anchors
9. **Clean up resources** - Remove entities when done
10. **Follow HIG** - visionOS Human Interface Guidelines

## Related Skills

- `swift-6-essentials` - Modern Swift for RealityKit
- `swiftui-essentials` - visionOS UI
- `cross-platform-patterns` - visionOS considerations
- `debugging-basics` - Debug 3D issues

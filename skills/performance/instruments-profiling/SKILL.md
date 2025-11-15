---
name: instruments-profiling
description: Profile and optimize app performance using Xcode Instruments including Time Profiler, Allocations, Leaks, Network, Energy Log, and SwiftUI debugging. Use when diagnosing performance issues, memory leaks, slow startup, high battery usage, or network problems.
version: 1.0.0
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# Instruments Profiling

## What This Skill Does

Comprehensive guide to profiling apps with Xcode Instruments for performance optimization, memory leak detection, and resource usage analysis.

## When to Activate

- App running slowly
- High memory usage
- Memory leaks suspected
- Battery drain issues
- Network performance problems
- Launch time optimization
- Frame rate drops

## Core Instruments

### Time Profiler

**Identifies CPU bottlenecks**
- Records call stacks at intervals
- Shows time spent in each function
- Find hot paths in code

**Using Time Profiler:**
1. Product → Profile (⌘I)
2. Select Time Profiler
3. Record while using app
4. Stop and analyze call tree
5. Focus on heaviest stack traces
6. Optimize identified functions

### Allocations

**Tracks memory allocations**
- Shows all object allocations
- Identifies memory growth
- Detects abandoned memory

**Using Allocations:**
1. Profile with Allocations instrument
2. Mark Generation (Mark Heap button)
3. Perform action
4. Mark Generation again
5. Review growth between marks
6. Investigate unexpected growth

### Leaks

**Detects memory leaks**
- Automatically finds leaked objects
- Shows leak cycles
- Identifies retain cycles

**Using Leaks:**
1. Profile with Leaks instrument
2. Use app normally
3. Check for red leak indicators
4. Click leak to see stack trace
5. Fix retain cycles

### Network

**Monitors network activity**
- HTTP/HTTPS requests
- Response times
- Data transferred
- Connection errors

### Energy Log

**Measures battery impact**
- CPU usage
- Network activity
- Location usage
- Display brightness

## Best Practices

1. **Profile on device** - Simulator doesn't match real performance
2. **Use Release build** - Profile optimized code
3. **Focus on hot paths** - Optimize most-used code first
4. **Measure before/after** - Quantify improvements
5. **Profile regularly** - Catch regressions early
6. **Use multiple instruments** - Comprehensive analysis
7. **Test realistic scenarios** - Real user workflows
8. **Compare baselines** - Track performance over time
9. **Profile on older devices** - Minimum spec hardware
10. **Document findings** - Share with team

## Common Issues

### Slow Launch Time
- Heavy work in `application:didFinishLaunching`
- Synchronous network calls
- Large data loading

**Fix:** Defer non-critical work, async loading

### High Memory Usage
- Large image caches
- Unreleased collections
- Retain cycles

**Fix:** Limit caches, use weak references, fix cycles

### Frame Drops
- Heavy work on main thread
- Complex view hierarchies
- Inefficient drawing

**Fix:** Async work, simplify views, cache drawing

## Related Skills

- `performance-optimization` - Optimization techniques
- `debugging-basics` - Debug performance issues
- `memory-management` - Fix memory leaks
- `swift-6-essentials` - Async patterns

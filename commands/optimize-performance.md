---
description: Analyze and optimize app performance for speed, responsiveness, and efficiency
---

You are performing a comprehensive performance analysis. Please:

1. **Analyze the code for performance issues:**
   - Main thread blocking operations
   - Synchronous network calls
   - Heavy computations without background processing
   - Inefficient algorithms (O(n²) when O(n) possible)
   - Unnecessary repeated calculations
   - Large object allocations
   - Excessive view updates in SwiftUI

2. **Check specific areas:**
   - **App Launch:** Work in didFinishLaunching, deferred initialization
   - **UI Rendering:** Complex view hierarchies, heavy SwiftUI bodies
   - **Data Operations:** Core Data fetch requests, query optimization
   - **Lists/Collections:** Use of LazyVStack/LazyHStack, cell reuse
   - **Images:** Image sizing, caching, memory footprint
   - **Networking:** Request batching, caching, compression

3. **Provide recommendations for:**
   - Moving work to background threads/queues
   - Implementing caching strategies
   - Lazy loading and on-demand computation
   - Algorithm improvements
   - Memory optimization
   - Battery efficiency

4. **Suggest Instruments analysis:**
   - Time Profiler for CPU bottlenecks
   - Allocations for memory usage
   - Network for API performance
   - Energy Log for battery impact

5. **Deliver:**
   - Priority-ranked list of issues (High/Medium/Low)
   - Specific code locations and line numbers
   - Before/after code examples
   - Expected performance improvement
   - Testing recommendations

Activate the `performance-optimization` and `instruments-profiling` skills for detailed analysis.

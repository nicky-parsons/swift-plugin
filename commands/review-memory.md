---
description: Analyze code for memory leaks, retain cycles, and memory management issues
---

You are performing a comprehensive memory analysis. Please:

1. **Analyze the current file or selection for:**
   - Retain cycles (strong reference cycles between objects)
   - Missing weak/unowned references in closures
   - Strong delegate references (should be weak)
   - Notification observers not removed in deinit
   - Timer retain cycles
   - Closure capture issues with [self]
   - Missing deinit implementations for verification

2. **Check for common patterns:**
   - `self` captured in closures without `[weak self]` or `[unowned self]`
   - Delegates without `weak var delegate`
   - NotificationCenter observers without removal
   - Timers strongly retaining targets
   - Combine subscriptions without proper storage
   - Strong references in lazy property closures

3. **Provide:**
   - List of potential memory issues found
   - Severity rating (Critical, Warning, Suggestion)
   - Specific line numbers and code snippets
   - Fix recommendations with code examples
   - Explanation of why each is a problem

4. **Suggest:**
   - How to test with Memory Graph Debugger in Xcode
   - Adding deinit logging to verify deallocation
   - Instruments Leaks tool usage

Activate the `memory-management` skill for detailed analysis and recommendations.

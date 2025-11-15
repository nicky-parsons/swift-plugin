---
description: Generate comprehensive test coverage for existing code using Swift Testing or XCTest
---

You are creating test coverage for existing code. Please:

1. **Analyze the code to understand:**
   - What the code does (functions, methods, logic)
   - Input parameters and return types
   - Error conditions and edge cases
   - Dependencies and side effects
   - State management

2. **Generate tests using Swift Testing (iOS 17+) or XCTest:**
   - Use `@Test` for Swift Testing framework
   - Use `XCTestCase` for XCTest
   - Ask user preference if unclear

3. **Create tests for:**
   - **Happy path:** Normal, expected inputs and outputs
   - **Edge cases:** Boundary values, empty collections, nil values
   - **Error cases:** Invalid inputs, expected failures
   - **State transitions:** Before/after state verification
   - **Async operations:** Proper async/await testing
   - **Mock dependencies:** Use test doubles for external dependencies

4. **Follow TDD best practices:**
   - One assertion concept per test
   - Descriptive test names (describes what is tested)
   - AAA pattern: Arrange, Act, Assert
   - Independent tests (no shared state)
   - Fast execution

5. **For each test, include:**
   - Clear test name describing scenario
   - Setup code (arrange)
   - Execution (act)
   - Assertions (assert)
   - Cleanup if needed

6. **Generate:**
   - Complete test file with all tests
   - Mock objects/protocols if needed
   - Test data fixtures
   - Comments explaining complex test scenarios

Activate the `testing-fundamentals` skill for comprehensive test generation.

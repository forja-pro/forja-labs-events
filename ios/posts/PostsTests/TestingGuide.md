# Swift Testing Guide for VIP Architecture

## Overview

This guide explains how to write effective tests for iOS applications using Swift and SwiftUI with VIP (View-Interactor-Presenter) architecture.

## Testing Framework

We're using Swift's modern **Testing** framework (available in Xcode 16+) which provides:
- `@Test` attribute for marking test methods
- `#expect()` for assertions
- Better async/await support
- Improved performance over XCTest

### Basic Test Structure
```swift
import Testing
@testable import YourApp

struct YourTestSuite {
    @Test func testDescription() async throws {
        // Given - Setup test data and conditions
        
        // When - Execute the code under test
        
        // Then - Assert expected outcomes
        #expect(actualValue == expectedValue)
    }
}
```

## Testing Strategy for VIP Architecture

### 1. What to Test in Each Component

#### Interactor Tests ✅
- Business logic execution
- Data flow to presenter
- Error handling
- Worker integration
- Data store management

#### Presenter Tests ✅
- Data transformation logic
- UI state updates
- Loading state management
- Error presentation

#### Worker Tests ✅
- API calls (with mocks)
- Data persistence
- Network error handling
- Async operations

#### ViewModel Tests ✅
- Published property updates
- User action handling
- State synchronization

#### Router Tests ✅
- Navigation logic
- Module creation
- Dependency injection
- Data passing between scenes

#### Model Tests ✅
- Data validation
- Codable implementation
- Business rules
- Computed properties

### 2. What NOT to Test ❌

- SwiftUI view rendering (use UI tests instead)
- Third-party library internals
- Auto-generated code
- Simple property getters/setters
- iOS framework methods

## Testing Patterns

### 1. Mocking Dependencies

Always mock dependencies to isolate components:

```swift
@MainActor
class MockPresenter: ArticlePresentationLogic {
    var presentArticleCalled = false
    var lastPresentedArticle: Article?
    
    func presentArticle(response: ArticleDetail.LoadArticle.Response) {
        presentArticleCalled = true
        lastPresentedArticle = response.article
    }
}
```

### 2. Testing Async Code

Use `await` for async operations:

```swift
@Test func testAsyncOperation() async throws {
    // Given
    let interactor = ArticleDetailInteractor()
    
    // When
    await interactor.loadArticle(request: request)
    
    // Then
    #expect(interactor.article != nil)
}
```

### 3. Testing Published Properties

For `@Published` properties, allow time for updates:

```swift
@Test func testPublishedProperty() async throws {
    // When
    presenter.presentLoadingState()
    
    // Give time for async dispatch
    try await Task.sleep(nanoseconds: 100_000_000)
    
    // Then
    #expect(viewModel.isLoading == true)
}
```

### 4. Integration Testing

Test how components work together:

```swift
@Test func testFullVIPFlow() async throws {
    // Given - Wire up real components
    let interactor = ArticleDetailInteractor()
    let presenter = ArticleDetailPresenter()
    let worker = ArticleDetailWorker()
    let viewModel = MockArticleDetailViewModel()
    
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.viewModel = viewModel
    
    // When
    await interactor.loadArticle(request: request)
    
    // Then - Verify end-to-end flow
    #expect(viewModel.title == expectedTitle)
}
```

## Common Test Scenarios

### 1. Success Path Testing
```swift
@Test func testSuccessPath() async throws {
    // Test the happy path where everything works correctly
}
```

### 2. Error Handling Testing
```swift
@Test func testErrorHandling() async throws {
    // Test how components handle errors
    mockWorker.shouldThrowError = true
    
    await interactor.loadArticle(request: request)
    
    #expect(!mockPresenter.presentArticleCalled)
}
```

### 3. Edge Cases Testing
```swift
@Test func testEdgeCases() async throws {
    // Test with nil values, empty data, etc.
}
```

### 4. State Management Testing
```swift
@Test func testStateTransitions() async throws {
    // Test loading → success → error states
}
```

## Best Practices

### 1. Naming Conventions
- Test methods: `testFeatureScenario()`
- Mock classes: `MockComponentName`
- Test suites: `ComponentNameTests`

### 2. Test Structure
- Use Given-When-Then pattern
- One assertion per test (when possible)
- Clear, descriptive test names

### 3. Mock Management
- Create focused mocks for each component
- Track method calls and parameters
- Provide controllable responses

### 4. Async Testing
- Use `async throws` for async tests
- Allow appropriate delays for UI updates
- Test both success and failure cases

### 5. Memory Management
- Use weak references in mocks when appropriate
- Test retain cycle prevention
- Clean up resources in tests

## Performance Testing

### 1. Timing Tests
```swift
@Test func testPerformance() async throws {
    let startTime = CFAbsoluteTimeGetCurrent()
    
    await worker.fetchArticle(articleId: 1)
    
    let elapsedTime = CFAbsoluteTimeGetCurrent() - startTime
    #expect(elapsedTime >= 2.0) // Verify expected delay
}
```

### 2. Memory Tests
```swift
@Test func testMemoryManagement() async throws {
    weak var weakReference: ArticleDetailInteractor?
    
    do {
        let interactor = ArticleDetailInteractor()
        weakReference = interactor
        // Use interactor
    }
    
    #expect(weakReference == nil) // Should be deallocated
}
```

## Running Tests

### Command Line
```bash
xcodebuild test -scheme YourApp -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Xcode
- `Cmd + U` to run all tests
- `Ctrl + Option + Cmd + U` to run tests in current file
- Use Test Navigator to run individual tests

## Test Organization

### File Structure
```
PostsTests/
├── ArticleDetailTests.swift           # Interactor tests
├── ArticleDetailPresenterTests.swift  # Presenter tests
├── ArticleDetailViewModelTests.swift  # ViewModel tests
├── ArticleDetailRouterTests.swift     # Router tests
├── ArticleDetailWorkerTests.swift     # Worker tests (if separate)
└── ArticleModelsTests.swift           # Model tests
```

### Test Categories
- Unit Tests: Test individual components
- Integration Tests: Test component interactions
- Performance Tests: Test timing and memory
- Edge Case Tests: Test boundary conditions

## Debugging Tests

### 1. Print Debugging
```swift
@Test func testWithDebugging() async throws {
    print("Test state: \(mockObject.currentState)")
    #expect(condition)
}
```

### 2. Breakpoints
- Set breakpoints in test methods
- Inspect mock object states
- Step through async operations

### 3. Test Isolation
- Run individual tests to isolate issues
- Use focused test runs
- Check for test interdependencies

## Continuous Integration

### 1. Test Configuration
```yaml
# Example GitHub Actions configuration
- name: Run Tests
  run: xcodebuild test -scheme Posts -destination 'platform=iOS Simulator,name=iPhone 15'
```

### 2. Test Reports
- Generate test coverage reports
- Monitor test execution times
- Track test success rates

## Common Pitfalls

1. **Not testing error cases** - Always test failure paths
2. **Over-mocking** - Don't mock value types unnecessarily
3. **Testing implementation details** - Focus on behavior, not internals
4. **Ignoring async timing** - Account for async operation delays
5. **Coupling tests** - Keep tests independent

## Conclusion

Effective testing in VIP architecture requires:
- Proper component isolation through mocking
- Comprehensive coverage of business logic
- Focus on behavior over implementation
- Good async/await patterns
- Clear test organization and naming

Remember: Good tests are documentation for your code and safety nets for refactoring!

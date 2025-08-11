import Testing
import SwiftUI
import Combine
import Foundation
@testable import Posts

// MARK: - Mock Dependencies for ViewModel Tests

@MainActor
class MockArticleDetailInteractor: ArticleDetailBusinessLogic {
    var loadArticleCalled = false
    var lastRequest: ArticleDetail.LoadArticle.Request?
    
    func loadArticle(request: ArticleDetail.LoadArticle.Request) async {
        loadArticleCalled = true
        lastRequest = request
    }
}

@MainActor
class MockArticleDetailRouter: ArticleDetailRoutingLogic {
    var navigateToAuthorProfileCalled = false
    var returnedView: AnyView?
    
    func navigateToAuthorProfile() -> AnyView? {
        navigateToAuthorProfileCalled = true
        returnedView = AnyView(Text("Mock Author Profile"))
        return returnedView
    }
}

// MARK: - ArticleDetailViewModel Tests

@MainActor
struct ArticleDetailViewModelTests {
    
    @Test func testViewModelInitialization() async throws {
        // Given
        let mockInteractor = MockArticleDetailInteractor()
        let mockRouter = MockArticleDetailRouter()
        
        // When
        let viewModel = ArticleDetailViewModel(interactor: mockInteractor, router: mockRouter)
        
        // Then
        #expect(viewModel.title == "")
        #expect(viewModel.author == "")
        #expect(viewModel.isLoading == false)
    }
    
    @Test func testLoadArticleAction() async throws {
        // Given
        let mockInteractor = MockArticleDetailInteractor()
        let mockRouter = MockArticleDetailRouter()
        let viewModel = ArticleDetailViewModel(interactor: mockInteractor, router: mockRouter)
        let testArticleId = 123
        
        // When
        viewModel.loadArticle(articleId: testArticleId)
        
        // Give time for async task to complete
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        #expect(mockInteractor.loadArticleCalled)
        #expect(mockInteractor.lastRequest?.articleId == testArticleId)
    }
    
    @Test func testMultipleLoadArticleCalls() async throws {
        // Given
        let mockInteractor = MockArticleDetailInteractor()
        let mockRouter = MockArticleDetailRouter()
        let viewModel = ArticleDetailViewModel(interactor: mockInteractor, router: mockRouter)
        
        // When
        viewModel.loadArticle(articleId: 1)
        viewModel.loadArticle(articleId: 2)
        viewModel.loadArticle(articleId: 3)
        
        // Give time for async tasks to complete
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        
        // Then - Should have called interactor multiple times
        #expect(mockInteractor.loadArticleCalled)
        // The last call should be with articleId 3
        #expect(mockInteractor.lastRequest?.articleId == 3)
    }
    
    @Test func testPublishedPropertiesCanBeSet() async throws {
        // Given
        let mockInteractor = MockArticleDetailInteractor()
        let mockRouter = MockArticleDetailRouter()
        let viewModel = ArticleDetailViewModel(interactor: mockInteractor, router: mockRouter)
        
        // When
        viewModel.title = "Test Title"
        viewModel.author = "Test Author"
        viewModel.isLoading = true
        
        // Then
        #expect(viewModel.title == "Test Title")
        #expect(viewModel.author == "Test Author")
        #expect(viewModel.isLoading == true)
    }
    
    @Test func testObservableObjectProtocol() async throws {
        // Given
        let mockInteractor = MockArticleDetailInteractor()
        let mockRouter = MockArticleDetailRouter()
        let viewModel = ArticleDetailViewModel(interactor: mockInteractor, router: mockRouter)
        
        var changedCount = 0
        
        // Set up observation (simplified for testing)
        let cancellable = viewModel.objectWillChange.sink {
            changedCount += 1
        }
        
        // When
        viewModel.title = "Changed Title"
        viewModel.isLoading = true
        
        // Give time for publisher to emit
        try await Task.sleep(nanoseconds: 50_000_000) // 0.05 seconds
        
        // Then
        #expect(changedCount > 0) // Should have emitted changes
        
        cancellable.cancel()
    }
}

import Testing
import SwiftUI
@testable import Posts

// MARK: - Mock DataStore for Router Tests

@MainActor
class MockArticleDetailDataStore: @preconcurrency ArticleDetailDataStore {
    var article: Article?
    
    init(article: Article? = nil) {
        self.article = article
    }
}

// MARK: - ArticleDetailRouter Tests

@MainActor
struct ArticleDetailRouterTests {
    
    @Test func testNavigateToAuthorProfileWithArticle() async throws {
        // Given
        let router = ArticleDetailRouter()
        let testArticle = Article(id: 1, title: "Test Title", author: "John Doe")
        let mockDataStore = MockArticleDetailDataStore(article: testArticle)
        router.dataStore = mockDataStore
        
        // When
        let resultView = router.navigateToAuthorProfile()
        
        // Then
        #expect(resultView != nil)
        // Note: Since we can't easily test SwiftUI view content in unit tests,
        // we just verify that a view is returned
    }
    
    @Test func testNavigateToAuthorProfileWithoutArticle() async throws {
        // Given
        let router = ArticleDetailRouter()
        let mockDataStore = MockArticleDetailDataStore(article: nil)
        router.dataStore = mockDataStore
        
        // When
        let resultView = router.navigateToAuthorProfile()
        
        // Then
        #expect(resultView == nil) // Should return nil when no article
    }
    
    @Test func testNavigateToAuthorProfileWithoutDataStore() async throws {
        // Given
        let router = ArticleDetailRouter()
        // Note: dataStore is nil
        
        // When
        let resultView = router.navigateToAuthorProfile()
        
        // Then
        #expect(resultView == nil) // Should return nil when no dataStore
    }
    
    @Test func testDataStoreProperty() async throws {
        // Given
        let router = ArticleDetailRouter()
        let testArticle = Article(id: 1, title: "Test", author: "Author")
        let mockDataStore = MockArticleDetailDataStore(article: testArticle)
        
        // When
        router.dataStore = mockDataStore
        
        // Then
        #expect(router.dataStore?.article?.id == testArticle.id)
        #expect(router.dataStore?.article?.title == testArticle.title)
        #expect(router.dataStore?.article?.author == testArticle.author)
    }
    
    @Test func testCreateModuleFactory() async throws {
        // Given
        let testArticleId = 42
        
        // When
        let createdView = ArticleDetailRouter.createModule(articleId: testArticleId)
        
        // Then
        // We can't easily test the internal wiring in a unit test,
        // but we can verify that the method creates a view without crashing
        #expect(createdView is ArticleDetailView)
    }
    
    @Test func testViewControllerWeakReference() async throws {
        // Given
        let router = ArticleDetailRouter()
        
        // When & Then
        #expect(router.viewController == nil) // Should initialize as nil
        
        // Test weak reference behavior (router shouldn't retain the viewController)
        do {
            let viewController = UIViewController()
            router.viewController = viewController
            #expect(router.viewController != nil)
        } // viewController goes out of scope here
        
        // The weak reference should now be nil (after a brief moment)
        try await Task.sleep(nanoseconds: 10_000_000) // 0.01 seconds
        #expect(router.viewController == nil)
    }
}

// MARK: - Module Factory Integration Tests

@MainActor
struct ArticleDetailModuleFactoryTests {
    
    @Test func testModuleCreationAndWiring() async throws {
        // Given
        let testArticleId = 123
        
        // When
        let moduleView = ArticleDetailRouter.createModule(articleId: testArticleId)
        
        // Then - Test that we get a properly configured view
        #expect(moduleView is ArticleDetailView)
        
        // Additional tests could verify that the dependencies are properly wired,
        // but this would require making some properties public or using reflection
    }
    
    @Test func testMultipleModuleCreations() async throws {
        // Given & When
        let module1 = ArticleDetailRouter.createModule(articleId: 1)
        let module2 = ArticleDetailRouter.createModule(articleId: 2)
        
        // Then - Each module should be separate instances
        #expect(module1 is ArticleDetailView)
        #expect(module2 is ArticleDetailView)
        // Note: We can't easily compare SwiftUI views for inequality,
        // but the fact that both are created successfully indicates proper isolation
    }
}

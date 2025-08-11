import Testing
import Foundation
@testable import Posts

// MARK: - Mock Classes

@MainActor
class MockArticleDetailPresenter: @preconcurrency ArticlePresentationLogic {
    var presentArticleCalled = false
    var presentLoadingStateCalled = false
    var lastPresentedArticle: Article?
    
    func presentArticle(response: ArticleDetail.LoadArticle.Response) {
        presentArticleCalled = true
        lastPresentedArticle = response.article
    }
    
    func presentLoadingState() {
        presentLoadingStateCalled = true
    }
}

class MockArticleDetailWorker: ArticleDetailWorkerLogic {
    var shouldThrowError = false
    var mockArticle: Article?
    var fetchArticleCalled = false
    var lastRequestedArticleId: Int?
    
    func fetchArticle(articleId: Int) async throws -> Article {
        fetchArticleCalled = true
        lastRequestedArticleId = articleId
        
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
        }
        
        return mockArticle ?? Article(id: articleId, title: "Mock Title", author: "Mock Author")
    }
}

@MainActor
class MockArticleDetailViewModel: ObservableObject {
    @Published var title: String = "" {
        didSet {
            titleSetCount += 1
        }
    }
    
    @Published var author: String = "" {
        didSet {
            authorSetCount += 1
        }
    }
    
    @Published var isLoading: Bool = false {
        didSet {
            isLoadingSetCount += 1
        }
    }
    
    var titleSetCount = 0
    var authorSetCount = 0
    var isLoadingSetCount = 0
}

// MARK: - ArticleDetailInteractor Tests

@MainActor
struct ArticleDetailInteractorTests {
    
    @Test func testLoadArticleSuccess() async throws {
        // Given
        let mockPresenter = MockArticleDetailPresenter()
        let mockWorker = MockArticleDetailWorker()
        let expectedArticle = Article(id: 1, title: "Test Article", author: "Test Author")
        mockWorker.mockArticle = expectedArticle
        
        let interactor = ArticleDetailInteractor()
        interactor.presenter = mockPresenter
        interactor.worker = mockWorker
        
        let request = ArticleDetail.LoadArticle.Request(articleId: 1)
        
        // When
        await interactor.loadArticle(request: request)
        
        // Then
        #expect(mockPresenter.presentLoadingStateCalled)
        #expect(mockPresenter.presentArticleCalled)
        #expect(mockWorker.fetchArticleCalled)
        #expect(mockWorker.lastRequestedArticleId == 1)
        #expect(mockPresenter.lastPresentedArticle?.id == expectedArticle.id)
        #expect(mockPresenter.lastPresentedArticle?.title == expectedArticle.title)
        #expect(mockPresenter.lastPresentedArticle?.author == expectedArticle.author)
        #expect(interactor.article?.id == expectedArticle.id)
    }
    
    @Test func testLoadArticleWithoutWorker() async throws {
        // Given
        let mockPresenter = MockArticleDetailPresenter()
        let interactor = ArticleDetailInteractor()
        interactor.presenter = mockPresenter
        // Note: No worker is set
        
        let request = ArticleDetail.LoadArticle.Request(articleId: 1)
        
        // When
        await interactor.loadArticle(request: request)
        
        // Then
        #expect(mockPresenter.presentLoadingStateCalled)
        #expect(!mockPresenter.presentArticleCalled) // Should not be called without worker
    }
    
    @Test func testLoadArticleError() async throws {
        // Given
        let mockPresenter = MockArticleDetailPresenter()
        let mockWorker = MockArticleDetailWorker()
        mockWorker.shouldThrowError = true
        
        let interactor = ArticleDetailInteractor()
        interactor.presenter = mockPresenter
        interactor.worker = mockWorker
        
        let request = ArticleDetail.LoadArticle.Request(articleId: 1)
        
        // When
        await interactor.loadArticle(request: request)
        
        // Then
        #expect(mockPresenter.presentLoadingStateCalled)
        #expect(mockWorker.fetchArticleCalled)
        // Note: Currently the error handling is empty (TODO in code), 
        // so presentArticle won't be called on error
        #expect(!mockPresenter.presentArticleCalled)
        #expect(interactor.article == nil) // Article shouldn't be set on error
    }
    
    @Test func testDataStoreInitialization() async throws {
        // Given
        let interactor = ArticleDetailInteractor()
        
        // Then
        #expect(interactor.article == nil) // Should initialize as nil
    }
    
    @Test func testDataStoreArticleAssignment() async throws {
        // Given
        let interactor = ArticleDetailInteractor()
        let testArticle = Article(id: 42, title: "Test", author: "Author")
        
        // When
        interactor.article = testArticle
        
        // Then
        #expect(interactor.article?.id == testArticle.id)
        #expect(interactor.article?.title == testArticle.title)
        #expect(interactor.article?.author == testArticle.author)
    }
}

// MARK: - ArticleDetailPresenter Tests

@MainActor
struct ArticleDetailPresenterTests {
    
    @Test func testPresentArticle() async throws {
        // Given
        let mockViewModel = MockArticleDetailViewModel()
        let presenter = ArticleDetailPresenter()
        presenter.viewModel = mockViewModel
        
        let testArticle = Article(id: 1, title: "Test Title", author: "Test Author")
        let response = ArticleDetail.LoadArticle.Response(article: testArticle)
        
        // When
        presenter.presentArticle(response: response)
        
        // Then
        #expect(mockViewModel.title == "Test Title")
        #expect(mockViewModel.author == "By Test Author")
        #expect(mockViewModel.isLoading == false)
    }
    
    @Test func testPresentLoadingState() async throws {
        // Given
        let mockViewModel = MockArticleDetailViewModel()
        let presenter = ArticleDetailPresenter()
        presenter.viewModel = mockViewModel
        
        // When
        presenter.presentLoadingState()
        
        // Give time for async dispatch
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        #expect(mockViewModel.isLoading == true)
    }
    
    @Test func testPresentArticleWithoutViewModel() async throws {
        // Given
        let presenter = ArticleDetailPresenter()
        // Note: No viewModel is set
        
        let testArticle = Article(id: 1, title: "Test Title", author: "Test Author")
        let response = ArticleDetail.LoadArticle.Response(article: testArticle)
        
        // When & Then (should not crash)
        presenter.presentArticle(response: response)
        // No assertion needed, just testing it doesn't crash
    }
    
    @Test func testAuthorFormatting() async throws {
        // Given
        let mockViewModel = MockArticleDetailViewModel()
        let presenter = ArticleDetailPresenter()
        presenter.viewModel = mockViewModel
        
        let testArticle = Article(id: 1, title: "Title", author: "John Doe")
        let response = ArticleDetail.LoadArticle.Response(article: testArticle)
        
        // When
        presenter.presentArticle(response: response)
        
        // Then
        #expect(mockViewModel.author == "By John Doe") // Verify "By " prefix is added
    }
    
    @Test func testMultipleArticlePresentations() async throws {
        // Given
        let mockViewModel = MockArticleDetailViewModel()
        let presenter = ArticleDetailPresenter()
        presenter.viewModel = mockViewModel
        
        let firstArticle = Article(id: 1, title: "First", author: "Author1")
        let secondArticle = Article(id: 2, title: "Second", author: "Author2")
        
        // When
        presenter.presentArticle(response: ArticleDetail.LoadArticle.Response(article: firstArticle))
        presenter.presentArticle(response: ArticleDetail.LoadArticle.Response(article: secondArticle))
        
        // Then - Should show the latest article
        #expect(mockViewModel.title == "Second")
        #expect(mockViewModel.author == "By Author2")
    }
}

// MARK: - ArticleDetailWorker Tests

struct ArticleDetailWorkerTests {
    
    @Test func testFetchArticleSuccess() async throws {
        // Given
        let worker = ArticleDetailWorker()
        let testArticleId = 123
        
        // When
        let article = try await worker.fetchArticle(articleId: testArticleId)
        
        // Then
        #expect(article.id == testArticleId)
        #expect(article.title == "SwiftUI e Arquitetura VIP: Um Guia Completo")
        #expect(article.author == "João Silva")
    }
    
    @Test func testFetchArticleWithDifferentIds() async throws {
        // Given
        let worker = ArticleDetailWorker()
        let firstId = 1
        let secondId = 999
        
        // When
        let firstArticle = try await worker.fetchArticle(articleId: firstId)
        let secondArticle = try await worker.fetchArticle(articleId: secondId)
        
        // Then
        #expect(firstArticle.id == firstId)
        #expect(secondArticle.id == secondId)
        #expect(firstArticle.title == secondArticle.title) // Same mock title
        #expect(firstArticle.author == secondArticle.author) // Same mock author
    }
    
    @Test func testFetchArticleDelay() async throws {
        // Given
        let worker = ArticleDetailWorker()
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // When
        let _ = try await worker.fetchArticle(articleId: 1)
        
        // Then
        let endTime = CFAbsoluteTimeGetCurrent()
        let elapsedTime = endTime - startTime
        #expect(elapsedTime >= 2.0) // Should take at least 2 seconds due to sleep
    }
}

// MARK: - ArticleModels Tests

struct ArticleModelsTests {
    
    @Test func testArticleCreation() async throws {
        // Given
        let id = 42
        let title = "Test Article Title"
        let author = "Test Author Name"
        
        // When
        let article = Article(id: id, title: title, author: author)
        
        // Then
        #expect(article.id == id)
        #expect(article.title == title)
        #expect(article.author == author)
    }
    
    @Test func testArticleIdentifiable() async throws {
        // Given
        let article1 = Article(id: 1, title: "Title1", author: "Author1")
        let article2 = Article(id: 2, title: "Title2", author: "Author2")
        let article3 = Article(id: 1, title: "Different Title", author: "Different Author")
        
        // Then
        #expect(article1.id != article2.id)
        #expect(article1.id == article3.id) // Same ID should be equal
    }
    
    @Test func testArticleCodable() async throws {
        // Given
        let originalArticle = Article(id: 1, title: "Codable Test", author: "Test Author")
        
        // When - Encode
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(originalArticle)
        
        // When - Decode
        let decoder = JSONDecoder()
        let decodedArticle = try decoder.decode(Article.self, from: jsonData)
        
        // Then
        #expect(decodedArticle.id == originalArticle.id)
        #expect(decodedArticle.title == originalArticle.title)
        #expect(decodedArticle.author == originalArticle.author)
    }
    
    @Test func testLoadArticleRequest() async throws {
        // Given
        let articleId = 123
        
        // When
        let request = ArticleDetail.LoadArticle.Request(articleId: articleId)
        
        // Then
        #expect(request.articleId == articleId)
    }
    
    @Test func testLoadArticleResponse() async throws {
        // Given
        let article = Article(id: 1, title: "Test", author: "Author")
        
        // When
        let response = ArticleDetail.LoadArticle.Response(article: article)
        
        // Then
        #expect(response.article.id == article.id)
        #expect(response.article.title == article.title)
        #expect(response.article.author == article.author)
    }
}

// MARK: - Integration Tests

@MainActor
struct ArticleDetailIntegrationTests {
    
    @Test func testFullVIPFlow() async throws {
        // Given - Real components working together
        let interactor = ArticleDetailInteractor()
        let presenter = ArticleDetailPresenter()
        let worker = ArticleDetailWorker()
        let viewModel = MockArticleDetailViewModel()
        
        // Wire up dependencies
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewModel = viewModel
        
        let request = ArticleDetail.LoadArticle.Request(articleId: 42)
        
        // When
        await interactor.loadArticle(request: request)
        
        // Then - Verify the complete flow worked
        #expect(interactor.article != nil)
        #expect(interactor.article?.id == 42)
        #expect(viewModel.title == "SwiftUI e Arquitetura VIP: Um Guia Completo")
        #expect(viewModel.author == "By João Silva")
        #expect(viewModel.isLoading == false) // Should be false after loading completes
    }
    
    @Test func testLoadingStateFlow() async throws {
        // Given
        let interactor = ArticleDetailInteractor()
        let presenter = ArticleDetailPresenter()
        let worker = ArticleDetailWorker()
        let viewModel = MockArticleDetailViewModel()
        
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewModel = viewModel
        
        let request = ArticleDetail.LoadArticle.Request(articleId: 1)
        
        // When
        let loadingTask = Task {
            await interactor.loadArticle(request: request)
        }
        
        // Give a small delay to let loading state be set
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then - Loading should be true during the operation
        #expect(viewModel.isLoading == true)
        
        // Wait for completion
        await loadingTask.value
        
        // Then - Loading should be false after completion
        #expect(viewModel.isLoading == false)
    }
}

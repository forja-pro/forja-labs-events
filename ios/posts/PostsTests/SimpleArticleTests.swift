import Testing
import SwiftUI
import Foundation
@testable import Posts

// MARK: - Simple Mock Classes

class MockPresenter: ArticlePresentationLogic {
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

class MockWorker: ArticleDetailWorkerLogic {
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

// MARK: - Basic ArticleDetailInteractor Tests

@MainActor
struct SimpleArticleDetailInteractorTests {
    
    @Test func testLoadArticleSuccess() async throws {
        // Given
        let mockPresenter = MockPresenter()
        let mockWorker = MockWorker()
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
        #expect(interactor.article?.id == expectedArticle.id)
    }
    
    @Test func testLoadArticleWithoutWorker() async throws {
        // Given
        let mockPresenter = MockPresenter()
        let interactor = ArticleDetailInteractor()
        interactor.presenter = mockPresenter
        // Note: No worker is set
        
        let request = ArticleDetail.LoadArticle.Request(articleId: 1)
        
        // When
        await interactor.loadArticle(request: request)
        
        // Then
        #expect(mockPresenter.presentLoadingStateCalled)
        #expect(!mockPresenter.presentArticleCalled)
    }
    
    @Test func testDataStoreInitialization() async throws {
        // Given
        let interactor = ArticleDetailInteractor()
        
        // Then
        #expect(interactor.article == nil)
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

// MARK: - ArticleDetailWorker Tests

struct SimpleArticleDetailWorkerTests {
    
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
        #expect(firstArticle.title == secondArticle.title)
        #expect(firstArticle.author == secondArticle.author)
    }
}

// MARK: - ArticleModels Tests

struct SimpleArticleModelsTests {
    
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
        #expect(article1.id == article3.id)
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

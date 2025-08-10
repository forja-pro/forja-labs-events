import Foundation

protocol ArticleDetailWorkerLogic {
    func fetchArticle(articleId: Int) async throws -> Article
}

class ArticleDetailWorker: ArticleDetailWorkerLogic {
    
    func fetchArticle(articleId: Int) async throws -> Article {
        // Simulate API call delay
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        // Simulate API response
        return Article(
            id: articleId,
            title: "SwiftUI e Arquitetura VIP: Um Guia Completo",
            author: "João Silva"
        )
    }
}

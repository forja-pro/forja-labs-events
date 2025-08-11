import Foundation

import Foundation

protocol ArticleDetailBusinessLogic {
    func loadArticle(request: ArticleDetail.LoadArticle.Request) async
}

protocol ArticleDetailDataStore {
    var article: Article? { get set }
}

@MainActor
class ArticleDetailInteractor: ArticleDetailBusinessLogic, @preconcurrency ArticleDetailDataStore {
    var presenter: ArticlePresentationLogic?
    var worker: ArticleDetailWorkerLogic?
    
    // MARK: - Data Store
    var article: Article?
    
    // MARK: - Business Logic
    
    func loadArticle(request: ArticleDetail.LoadArticle.Request) async {
        presenter?.presentLoadingState()
        
        do {
            guard let worker = worker else {
                return
            }
            
            let article = try await worker.fetchArticle(articleId: request.articleId)
            self.article = article
            
            let response = ArticleDetail.LoadArticle.Response(article: article)
            presenter?.presentArticle(response: response)
            
        } catch {//TODO: Add some errors here...
        }
    }
}

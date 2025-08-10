import Foundation
import SwiftUI

class ArticleDetailViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var author: String = ""
    @Published var isLoading: Bool = false
    
    private let interactor: ArticleDetailBusinessLogic
    private let router: ArticleDetailRoutingLogic
    
    init(interactor: ArticleDetailBusinessLogic, router: ArticleDetailRoutingLogic) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - User Actions
    func loadArticle(articleId: Int) {
        Task {
            let request = ArticleDetail.LoadArticle.Request(articleId: articleId)
            await interactor.loadArticle(request: request)
        }
    }
}

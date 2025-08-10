import Foundation

protocol ArticlePresentationLogic {
    func presentArticle(response: ArticleDetail.LoadArticle.Response)
    func presentLoadingState()
}

class ArticleDetailPresenter: ArticlePresentationLogic {
    var viewModel: ArticleDetailViewModel?
    
    // MARK: - Presentation Logic
    
    func presentArticle(response: ArticleDetail.LoadArticle.Response) {
        self.viewModel?.isLoading = false
        self.viewModel?.title = response.article.title
        self.viewModel?.author = "By \(response.article.author)"
    }
    
    
    func presentLoadingState() {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel?.isLoading = true
        }
    }
}

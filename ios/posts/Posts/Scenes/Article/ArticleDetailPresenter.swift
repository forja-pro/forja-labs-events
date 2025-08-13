import Foundation

protocol ArticlePresentationLogic {
    func presentArticle(response: ArticleDetail.LoadArticle.Response) async
    func presentLoadingState() async
}

@MainActor
class ArticleDetailPresenter: ArticlePresentationLogic {
    var viewModel: ArticleDetailViewModel?
    
    // MARK: - Presentation Logic
    
    func presentArticle(response: ArticleDetail.LoadArticle.Response) async {
    viewModel?.isLoading = false
    viewModel?.title = response.article.title
    viewModel?.author = "By \(response.article.author)"
    }
    
    
    func presentLoadingState() async {
    viewModel?.isLoading = true
    }
}

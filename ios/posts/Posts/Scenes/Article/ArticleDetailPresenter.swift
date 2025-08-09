import Foundation

protocol ArticlePresentationLogic {
  func presentArticle(viewModel: ArticleDetail.Response)
}

class ArticlePresenter: ObservableObject, ArticlePresentationLogic {
  @Published var title: String = "Title"
  @Published var author: String = "Fulano"

  lazy var interactor: ArticleDetailBusinessLogic = {
    let interactor = ArticleDetailInteractor()
    interactor.presenter = self
    return interactor
  }()

  func presentArticle(viewModel: ArticleDetail.Response) {
    self.title = viewModel.article.title
    self.author = viewModel.article.author
  }
}

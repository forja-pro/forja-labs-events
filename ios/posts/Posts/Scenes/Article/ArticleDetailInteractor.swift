import Foundation

protocol ArticleDetailBusinessLogic {
  func loadArticle(request: ArticleDetail.LoadArticle.Request)
}

class ArticleDetailInteractor: ArticleDetailBusinessLogic {
  var presenter: ArticlePresentationLogic?
  func loadArticle(request: ArticleDetail.LoadArticle.Request) {
    ArticleDetail.Response(article: .init(id: 1, title: "Titulo", author: "Willians V"))
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      self.fetchArticleData(articleId: request.articleId)
    }
  }

  private func fetchArticleData(articleId: Int) {
    // Simula dados do artigo (aqui você faria a chamada real da API)
    let article = Article(
      id: articleId,
      title: "SwiftUI e Arquitetura VIP: Um Guia Completo",
      author: "João Silva",
    )

    let response = ArticleDetail.Response(
      article: article
    )

    presenter?.presentArticle(viewModel: response)
  }
}

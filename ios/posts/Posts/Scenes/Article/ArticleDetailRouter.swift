import SwiftUI

protocol ArticleDetailRoutingLogic {
    func navigateToAuthorProfile() -> AnyView?
}

protocol ArticleDetailDataPassing {
    var dataStore: ArticleDetailDataStore? { get }
}

class ArticleDetailRouter: ArticleDetailRoutingLogic, ArticleDetailDataPassing {
    weak var viewController: UIViewController?
    var dataStore: ArticleDetailDataStore?
    
    // MARK: - Routing Logic
    
    func navigateToAuthorProfile() -> AnyView? {
        guard let article = dataStore?.article else { return nil }
        
        //TODO:
        // Create properly configured AuthorProfileView with author data
        // let authorView = AuthorProfileRouter.createModule(authorId: article.author.id)
        // return AnyView(authorView)
        
        // For now, return a placeholder
        return AnyView(
            Text("Author Profile: \(article.author)")
                .padding()
        )
    }
    
    // MARK: - Module Factory
    
    @MainActor
    static func createModule(articleId: Int) -> ArticleDetailView {
        let worker = ArticleDetailWorker()
        let interactor = ArticleDetailInteractor()
        let presenter = ArticleDetailPresenter()
        let router = ArticleDetailRouter()
        
        let viewModel = ArticleDetailViewModel(
            interactor: interactor,
            router: router
        )
        
        interactor.worker = worker
        interactor.presenter = presenter
        presenter.viewModel = viewModel
        router.dataStore = interactor
        
        return ArticleDetailView(viewModel: viewModel, articleId: articleId)
    }
}

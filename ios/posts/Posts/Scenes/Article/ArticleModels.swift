import Foundation

enum ArticleDetail {
    enum LoadArticle {
        struct Request {
            let articleId: Int
        }
        
        struct Response {
            let article: Article
        }
    }
}

struct Article: Identifiable, Codable {
    let id: Int
    let title: String
    let author: String
}

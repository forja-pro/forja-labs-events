//
//  ArticleModels.swift
//  posts
//
//  Created by Willians Varela on 09/08/25.
//

import Foundation



enum ArticleDetail {
    enum LoadArticle {
        struct Request {
            let articleId: Int
        }
    }
    struct Response {
        let article: Article
    }
}

struct Article {
    let id: Int
    let title: String
    let author: String
}

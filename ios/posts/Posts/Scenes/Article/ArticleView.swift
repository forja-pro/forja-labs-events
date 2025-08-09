//
//  ArticleView.swift
//  posts
//
//  Created by Willians Varela on 09/08/25.
//

import SwiftUI

struct ArticleView: View {
    @StateObject private var presenter = ArticlePresenter()
    let articleId: Int
    
    init(articleId: Int = 123) {
        self.articleId = articleId
    }
    
    var body: some View {
        NavigationView{
            ScrollView{
                articleContent
            }
            .navigationTitle("Article")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear{loadArticle()}
        }
    }
    
    
    private var articleContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(presenter.title)
            Spacer()
            Text(presenter.author)
        }
        .padding()
    }
    
    
    private func loadArticle() {
        let request = ArticleDetail.LoadArticle.Request(articleId: articleId)
        presenter.interactor.loadArticle(request: request)
    }
}

#Preview {
    ArticleView()
}

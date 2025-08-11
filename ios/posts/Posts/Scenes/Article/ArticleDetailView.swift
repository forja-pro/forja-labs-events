import SwiftUI

struct ArticleDetailView: View {
    @StateObject private var viewModel: ArticleDetailViewModel
    let articleId: Int
    
    init(viewModel: ArticleDetailViewModel, articleId: Int = 123) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.articleId = articleId
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if viewModel.isLoading {
                        loadingView
                    }  else {
                        contentView
                    }
                }
                .padding()
            }
            .navigationTitle("Article")
            .navigationBarTitleDisplayMode(.inline)
            .accessibilityIdentifier("article_detail_view")
        }
        .onAppear {
            viewModel.loadArticle(articleId: articleId)
        }
    }
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(viewModel.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .accessibilityIdentifier("article_title")
                .accessibilityLabel("Article title")
            
            Text(viewModel.author)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .accessibilityIdentifier("article_author")
                .accessibilityLabel("Article author")
        }
    }
}

private var loadingView: some View {
    VStack {
        ProgressView()
            .accessibilityIdentifier("loading_progress")
            .accessibilityLabel("Loading article")
        Text("Loading article...")
            .foregroundColor(.secondary)
            .accessibilityIdentifier("loading_text")
    }
    .padding()
}

// MARK: - Factory Method for Creation

extension ArticleDetailView {
    static func create(articleId: Int) -> ArticleDetailView {
        return ArticleDetailRouter.createModule(articleId: articleId)
    }
}

#Preview {
    ArticleDetailView.create(articleId: 123)
}

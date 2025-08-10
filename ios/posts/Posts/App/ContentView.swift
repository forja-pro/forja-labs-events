import SwiftUI

struct ContentView: View {
    var body: some View {
        ArticleDetailView.create(articleId: 123)
    }
}

#Preview {
    ContentView()
}

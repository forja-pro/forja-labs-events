import SwiftUI

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            
            ArticleDetailView.create(articleId: 123)
                .tabItem{
                    Image(systemName: "moon.fill")
                    Text("Article")
                }
            
            ProfileView.create()
                .tabItem{
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }.tint(AppTheme.primaryColor)
    }

}

#Preview {
    ContentView()
}

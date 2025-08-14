import SwiftUI

@main
struct PostsApp: App {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("isSystemAppearance") private var isSystemAppearance: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(colorScheme)
        }
    }
    
    private var colorScheme: ColorScheme? {
        if isSystemAppearance {
            return nil
        } else {
            return isDarkMode ? .dark : .light
        }
    }
}

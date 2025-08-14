import SwiftUI

struct AppTheme{
    struct Colors{
        static let primaryBlue = Color("PrimaryBlue") // Will fallback to static if not found in Assets
        static let primaryBlueLight = Color("PrimaryBlueLight")
        static let primaryBlueDark = Color("PrimaryBlueDark")
        
        private static let ciotoPrimaryBlue = Color(red: 0.31, green: 0.76, blue: 0.97) // #4FC3F7 - Main blue from design
        private static let ciotoSecondaryBlue = Color(red: 0.70, green: 0.90, blue: 0.99) // #B3E5FC - Light blue from design
        private static let ciotoBackgroundBlue = Color(red: 0.91, green: 0.96, blue: 0.99) // #E8F4FD - Very light blue background
        
        
        static let textPrimary = Color(.label)
        
        static var adaptivePrimaryBlue: Color {
            return Color(UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return UIColor(Color(red: 0.40, green: 0.80, blue: 1.0)) // Brighter blue for dark mode visibility
                default:
                    return UIColor(ciotoPrimaryBlue) // #4FC3F7 - Cioto design primary
                }
            })
        }
    }
    static var primaryColor: Color {
        return Colors.adaptivePrimaryBlue
    }
}

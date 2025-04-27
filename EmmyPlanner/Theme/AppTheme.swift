import SwiftUI

// App-wide theme colors
struct AppTheme {
    // Primary colors
    static let primaryPink = Color(hex: "FF8AAA").opacity(0.85) // Softer pink with transparency
    static let primaryBlue = Color(hex: "7EB6FF").opacity(0.8) // Softer blue with transparency
    
    // Secondary/accent colors
    static let accentPink = Color(hex: "FFC1D6").opacity(0.6) // Even lighter pink
    static let accentBlue = Color(hex: "C6E1FF").opacity(0.7) // Lighter blue
    
    // Background colors
    static let backgroundPrimary = Color(hex: "FFFFFF").opacity(0.9) // Almost white background
    static let backgroundSecondary = Color(hex: "F8FBFF").opacity(0.95) // Very subtle blue background
    
    // Text colors
    static let textPrimary = Color(hex: "444444") // Slightly softer dark gray
    static let textSecondary = Color(hex: "888888") // Softer medium gray
    
    // Utility colors
    static let success = Color.green.opacity(0.8)
    static let warning = Color.orange.opacity(0.8)
    static let error = Color.red.opacity(0.8)
    
    // Button styles
    static let primaryButtonColor = primaryPink
    static let secondaryButtonColor = primaryBlue
    
    // TabView indicator
    static let tabBarColor = primaryPink
    
    // Status colors
    static let confirmed = Color.green.opacity(0.8)
    static let unconfirmed = Color.gray.opacity(0.5)
    static let purchased = Color.green.opacity(0.8)
    static let unpurchased = Color.gray.opacity(0.5)
}

// Color extension to support hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 
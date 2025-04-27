import SwiftUI

// Primary button style
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(AppTheme.primaryPink.opacity(0.85))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(), value: configuration.isPressed)
            .shadow(color: AppTheme.primaryPink.opacity(0.3), radius: 2, x: 0, y: 1)
    }
}

// Secondary button style
struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(AppTheme.primaryBlue.opacity(0.85))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(), value: configuration.isPressed)
            .shadow(color: AppTheme.primaryBlue.opacity(0.3), radius: 2, x: 0, y: 1)
    }
}

// Form section style modifier
struct FormSectionStyle: ViewModifier {
    var alternateBackground: Bool = false
    
    func body(content: Content) -> some View {
        content
            .listRowBackground(
                alternateBackground ? 
                    AppTheme.backgroundSecondary.opacity(0.7) : 
                    AppTheme.backgroundPrimary.opacity(0.7)
            )
    }
}

// Card view style
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

// Text field style
struct ModernTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white.opacity(0.7))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(AppTheme.accentPink.opacity(0.6), lineWidth: 0.5)
            )
            .shadow(color: Color.black.opacity(0.03), radius: 1, x: 0, y: 1)
    }
}

// Modern checkbox style (for confirmation buttons)
struct ModernCheckboxStyle: ButtonStyle {
    var isChecked: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundColor(isChecked ? AppTheme.confirmed : AppTheme.unconfirmed)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}

// Extensions to make styles easily applied
extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
    
    func modernTextField() -> some View {
        modifier(ModernTextFieldStyle())
    }
    
    func formSection(alternateBackground: Bool = false) -> some View {
        modifier(FormSectionStyle(alternateBackground: alternateBackground))
    }
}

extension Button {
    func primaryButton() -> some View {
        self.buttonStyle(PrimaryButtonStyle())
    }
    
    func secondaryButton() -> some View {
        self.buttonStyle(SecondaryButtonStyle())
    }
    
    func modernCheckbox(isChecked: Bool) -> some View {
        self.buttonStyle(ModernCheckboxStyle(isChecked: isChecked))
    }
} 
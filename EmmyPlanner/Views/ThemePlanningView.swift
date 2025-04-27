import SwiftUI

struct ThemePlanningView: View {
    @EnvironmentObject var viewModel: PartyViewModel
    @State private var selectedTheme = "Custom"
    @State private var showSparkles = false
    
    let themeOptions = ["Princess", "Space/Astronaut", "Unicorn", "Superheroes", "Animals", "Dinosaurs", "Mermaids", "Sports", "Custom"]
    
    // Sample decoration items based on theme
    var decorationIdeas: [String] {
        switch selectedTheme {
        case "Princess":
            return ["Crown/Tiara for birthday girl", "Castle decorations", "Pink and purple balloons", "Wands as party favors", "Princess cake topper"]
        case "Space/Astronaut":
            return ["Star decorations", "Rocket balloons", "Planet decorations", "Space themed tablecloth", "Astronaut helmet props"]
        case "Unicorn":
            return ["Unicorn headbands", "Rainbow decorations", "Magical stars", "Pastel colored balloons", "Glitter and confetti"]
        case "Superheroes":
            return ["Superhero masks", "City skyline backdrop", "Comic book decorations", "Superhero capes as favors", "POW! and BAM! signs"]
        case "Animals":
            return ["Animal balloons", "Zoo themed decorations", "Animal masks", "Jungle vines and leaves", "Animal print tablecloth"]
        case "Dinosaurs":
            return ["Dinosaur figures", "Prehistoric plants", "Dinosaur footprints", "Volcano decorations", "Dinosaur eggs"]
        case "Mermaids":
            return ["Seashell decorations", "Blue and teal balloons", "Mermaid tails", "Fishing nets with sea creatures", "Treasure chest props"]
        case "Sports":
            return ["Sports ball decorations", "Team banners", "Trophy centerpieces", "Sports equipment props", "Team color balloons"]
        default:
            return []
        }
    }
    
    // Theme icon for the selected theme
    var themeIcon: String {
        switch selectedTheme {
        case "Princess": return "crown.fill"
        case "Space/Astronaut": return "rocket.fill"
        case "Unicorn": return "sparkles"
        case "Superheroes": return "bolt.fill"
        case "Animals": return "pawprint.fill"
        case "Dinosaurs": return "leaf.fill"
        case "Mermaids": return "drop.fill"
        case "Sports": return "sportscourt.fill"
        default: return "pencil"
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.backgroundPrimary.ignoresSafeArea()
                
                if showSparkles {
                    ZStack {
                        ForEach(0..<10) { i in
                            SparkleView(color: i % 2 == 0 ? AppTheme.primaryPink : AppTheme.primaryBlue)
                                .offset(
                                    x: CGFloat.random(in: -150...150),
                                    y: CGFloat.random(in: -300...300)
                                )
                                .opacity(0.5)
                        }
                    }
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                }
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Theme selector
                        GradientCard {
                            VStack(spacing: 15) {
                                HStack {
                                    Text("Party Theme")
                                        .font(.headline)
                                        .foregroundColor(AppTheme.primaryPink)
                                        
                                    Spacer()
                                    
                                    Image(systemName: themeIcon)
                                        .foregroundColor(AppTheme.primaryPink)
                                        .font(.title2)
                                }
                                
                                Picker("Select Theme", selection: $selectedTheme) {
                                    ForEach(themeOptions, id: \.self) { theme in
                                        Text(theme)
                                            .foregroundColor(AppTheme.textPrimary)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 100)
                                .padding(.horizontal)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.7))
                                )
                                .onChange(of: selectedTheme) { _, _ in
                                    // Show sparkles when theme changes
                                    showSparkles = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        showSparkles = false
                                    }
                                }
                                
                                if selectedTheme == "Custom" {
                                    TextField("Enter custom theme", text: $viewModel.party.theme)
                                        .foregroundColor(AppTheme.textPrimary)
                                        .padding()
                                        .background(Color.white.opacity(0.7))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(AppTheme.accentPink, lineWidth: 1)
                                        )
                                } else {
                                    Button(action: {
                                        viewModel.party.theme = selectedTheme
                                        // Show sparks when theme is selected
                                        showSparkles = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            showSparkles = false
                                        }
                                    }) {
                                        Text("Use this theme")
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(AppTheme.primaryPink)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        
                        if selectedTheme != "Custom" || !viewModel.party.theme.isEmpty {
                            // Decoration ideas
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    Text("Decoration Ideas")
                                        .font(.headline)
                                        .foregroundColor(AppTheme.primaryBlue)
                                    
                                    Spacer()
                                    
                                    // Theme icon
                                    ZStack {
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [AppTheme.primaryBlue, AppTheme.accentBlue]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: 40, height: 40)
                                        
                                        Image(systemName: themeIcon)
                                            .foregroundColor(.white)
                                            .font(.system(size: 20))
                                    }
                                }
                                .padding(.horizontal)
                                
                                ForEach(decorationIdeas, id: \.self) { idea in
                                    HStack {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(AppTheme.primaryPink)
                                        Text(idea)
                                            .foregroundColor(AppTheme.textPrimary)
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.white.opacity(0.7))
                                    )
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.vertical)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(AppTheme.backgroundSecondary)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            )
                        }
                        
                        // Color scheme
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Color Scheme")
                                .font(.headline)
                                .foregroundColor(AppTheme.primaryPink)
                                .padding(.horizontal)
                            
                            VStack(spacing: 15) {
                                HStack(spacing: 15) {
                                    ColorCircle(color: AppTheme.primaryPink)
                                    ColorCircle(color: AppTheme.accentPink)
                                    ColorCircle(color: AppTheme.primaryBlue)
                                    ColorCircle(color: AppTheme.accentBlue)
                                }
                                
                                HStack(spacing: 15) {
                                    ColorCircle(color: .purple)
                                    ColorCircle(color: .pink)
                                    ColorCircle(color: .blue)
                                    ColorCircle(color: .teal)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.7))
                            )
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.9))
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        )
                        
                        // Theme notes
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Theme Notes")
                                .font(.headline)
                                .foregroundColor(AppTheme.primaryBlue)
                                .padding(.horizontal)
                            
                            ZStack(alignment: .topLeading) {
                                if viewModel.party.notes.isEmpty {
                                    Text("Add any theme-related notes here...")
                                        .foregroundColor(AppTheme.textSecondary)
                                        .padding(.top, 8)
                                        .padding(.leading, 5)
                                }
                                
                                TextEditor(text: $viewModel.party.notes)
                                    .frame(minHeight: 100)
                                    .foregroundColor(AppTheme.textPrimary)
                                    .padding(5)
                            }
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.7))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(AppTheme.accentBlue, lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(AppTheme.backgroundSecondary)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        )
                    }
                    .padding()
                }
            }
            .navigationTitle("Theme Planning")
        }
    }
}

struct ColorCircle: View {
    var color: Color
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 40, height: 40)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
    }
}

#Preview {
    ThemePlanningView()
        .environmentObject(PartyViewModel())
} 
import SwiftUI

// MARK: - Confetti View
struct ConfettiView: View {
    @State private var isAnimating = false
    let colors: [Color] = [
        AppTheme.primaryPink, 
        AppTheme.primaryBlue, 
        AppTheme.accentPink, 
        AppTheme.accentBlue,
        .purple, 
        .yellow
    ]
    
    var body: some View {
        ZStack {
            ForEach(0..<50) { i in
                ConfettiPiece(color: colors[i % colors.count], size: CGFloat.random(in: 5...12))
                    .offset(
                        x: isAnimating ? CGFloat.random(in: -UIScreen.main.bounds.width/2...UIScreen.main.bounds.width/2) : 0,
                        y: isAnimating ? UIScreen.main.bounds.height : -50
                    )
                    .animation(
                        Animation.linear(duration: Double.random(in: 2...5))
                            .repeatForever(autoreverses: false)
                            .delay(Double.random(in: 0...2)),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct ConfettiPiece: View {
    let color: Color
    let size: CGFloat
    @State private var rotation = Double.random(in: 0...360)
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: size, height: size)
            .rotationEffect(.degrees(rotation))
            .animation(
                Animation.linear(duration: Double.random(in: 2...4))
                    .repeatForever(autoreverses: false),
                value: rotation
            )
            .onAppear {
                rotation = Double.random(in: 0...360)
            }
    }
}

// MARK: - Balloon View
struct BalloonView: View {
    var color: Color
    var size: CGFloat = 100
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Balloon body
            Circle()
                .fill(color)
                .frame(width: size, height: size)
                .overlay(
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: size * 0.3, height: size * 0.3)
                        .offset(x: -size * 0.2, y: -size * 0.2)
                )
                .offset(y: isAnimating ? -5 : 5)
                .animation(
                    Animation.easeInOut(duration: 2)
                        .repeatForever(autoreverses: true),
                    value: isAnimating
                )
            
            // Balloon tie
            Triangle()
                .fill(color)
                .frame(width: size * 0.2, height: size * 0.2)
                .rotationEffect(.degrees(180))
                .offset(y: -5)
            
            // String
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addQuadCurve(
                    to: CGPoint(x: 0, y: size * 0.5),
                    control: CGPoint(x: size * 0.2, y: size * 0.25)
                )
            }
            .stroke(Color.gray, lineWidth: 1)
            .frame(width: 1, height: size * 0.5)
        }
        .frame(width: size, height: size * 1.8)
        .onAppear {
            isAnimating = true
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Party Badge
struct PartyBadge: View {
    var text: String
    var color: Color = AppTheme.primaryPink
    
    var body: some View {
        Text(text)
            .font(.caption.bold())
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color.opacity(0.85))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .shadow(color: color.opacity(0.3), radius: 1, x: 0, y: 1)
    }
}

// MARK: - Sparkle Effect
struct SparkleView: View {
    @State private var animate = false
    var color: Color = AppTheme.primaryPink
    
    var body: some View {
        ZStack {
            // Central sparkle
            Image(systemName: "sparkle")
                .foregroundColor(color)
                .font(.system(size: 25))
                .opacity(animate ? 0 : 1)
                .scaleEffect(animate ? 1.5 : 1)
            
            // Surrounding sparkles
            ForEach(0..<8) { i in
                Image(systemName: "sparkle")
                    .foregroundColor(color)
                    .font(.system(size: 15))
                    .rotationEffect(.degrees(Double(i) * 45))
                    .offset(x: animate ? 20 : 10, y: 0)
                    .rotationEffect(.degrees(Double(i) * 45))
                    .opacity(animate ? 0 : 1)
                    .scaleEffect(animate ? 1.5 : 0.5)
            }
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                animate.toggle()
            }
        }
    }
}

// MARK: - Wavy Separator
struct WavySeparator: View {
    var color: Color = AppTheme.accentPink
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                let midHeight = height / 2
                
                path.move(to: CGPoint(x: 0, y: midHeight))
                
                // Create a wavy path
                var x: CGFloat = 0
                let wavesCount = 6
                let waveWidth = width / CGFloat(wavesCount)
                let amplitude: CGFloat = height * 0.25 // Reduced amplitude for subtlety
                
                while x < width {
                    path.addQuadCurve(
                        to: CGPoint(x: x + waveWidth/2, y: midHeight + amplitude),
                        control: CGPoint(x: x + waveWidth/4, y: midHeight)
                    )
                    path.addQuadCurve(
                        to: CGPoint(x: x + waveWidth, y: midHeight),
                        control: CGPoint(x: x + waveWidth*3/4, y: midHeight - amplitude)
                    )
                    x += waveWidth
                }
            }
            .stroke(color.opacity(0.7), lineWidth: 1) // Thinner, more transparent line
        }
        .frame(height: 15) // Slightly smaller height
    }
}

// MARK: - Gradient Card
struct GradientCard<Content: View>: View {
    var content: Content
    var startColor: Color
    var endColor: Color
    
    init(startColor: Color = AppTheme.primaryPink, 
         endColor: Color = AppTheme.primaryBlue, 
         @ViewBuilder content: () -> Content) {
        self.content = content()
        self.startColor = startColor
        self.endColor = endColor
    }
    
    var body: some View {
        content
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [startColor.opacity(0.15), endColor.opacity(0.15)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .background(.ultraThinMaterial)
            )
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

// MARK: - Animated Cake
struct CakeView: View {
    @State private var candles = false
    @State private var flames = false
    
    var body: some View {
        VStack {
            // Candles and flames
            HStack(spacing: 15) {
                ForEach(0..<5) { i in
                    VStack(spacing: 0) {
                        // Flame
                        Image(systemName: "flame.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.yellow)
                            .opacity(flames ? 1 : 0)
                            .scaleEffect(flames ? 1.2 : 0.8)
                            .animation(
                                Animation.easeInOut(duration: 0.5)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(i) * 0.2),
                                value: flames
                            )
                        
                        // Candle
                        Rectangle()
                            .fill(
                                [AppTheme.primaryPink, AppTheme.primaryBlue, .purple, .green, .orange][i % 5]
                            )
                            .frame(width: 5, height: 20)
                            .opacity(candles ? 1 : 0)
                            .offset(y: candles ? 0 : 10)
                    }
                }
            }
            .offset(y: 10)
            .zIndex(1)
            
            // Cake layers
            VStack(spacing: -5) {
                // Frosting
                RoundedRectangle(cornerRadius: 5)
                    .fill(AppTheme.accentPink)
                    .frame(width: 120, height: 15)
                
                // Cake top layer
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.white.opacity(0.9))
                    .frame(width: 120, height: 20)
                
                // Cake middle stripe
                RoundedRectangle(cornerRadius: 0)
                    .fill(AppTheme.accentBlue)
                    .frame(width: 140, height: 8)
                
                // Cake bottom layer
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.white.opacity(0.9))
                    .frame(width: 150, height: 30)
            }
            
            // Cake stand
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 120, height: 10)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1)) {
                candles = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    flames = true
                }
            }
        }
    }
} 
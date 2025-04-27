import SwiftUI

struct TestView: View {
    var body: some View {
        VStack {
            Text("Hello, Emmy's Party Planner!")
                .font(.largeTitle)
                .padding()
            
            Text("This is a test view")
                .font(.title)
                .foregroundColor(.pink)
        }
    }
}

#Preview {
    TestView()
} 
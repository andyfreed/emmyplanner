import SwiftUI

struct PartyDetailsView: View {
    @EnvironmentObject var viewModel: PartyViewModel
    @State private var showConfetti = false
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.backgroundPrimary.ignoresSafeArea()
                
                if showConfetti {
                    ConfettiView()
                        .ignoresSafeArea()
                        .allowsHitTesting(false)
                }
                
                ScrollView {
                    VStack(spacing: 28) {
                        // App Title and Date Header
                        VStack(spacing: 16) {
                            Text("Emmy's Birthday")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(AppTheme.primaryPink)
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(AppTheme.primaryPink)
                                
                                Text("November 23rd, \(Calendar.current.component(.year, from: viewModel.party.date))")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundColor(AppTheme.textPrimary)
                            }
                            .padding(.vertical, 8)
                            
                            HStack(spacing: 30) {
                                Image(systemName: "gift.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(AppTheme.primaryPink)
                                    .padding(10)
                                    .background(
                                        Circle()
                                            .fill(AppTheme.accentPink.opacity(0.2))
                                    )
                                
                                Image(systemName: "balloon.2.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(AppTheme.primaryPink)
                                    .padding(10)
                                    .background(
                                        Circle()
                                            .fill(AppTheme.accentPink.opacity(0.2))
                                    )
                                
                                Image(systemName: "birthday.cake.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(AppTheme.primaryPink)
                                    .padding(10)
                                    .background(
                                        Circle()
                                            .fill(AppTheme.accentPink.opacity(0.2))
                                    )
                            }
                            .padding(.top, 8)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.ultraThinMaterial)
                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                        )
                        
                        // Guest Stats
                        VStack(spacing: 15) {
                            HStack {
                                Text("Guest Stats")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.primaryBlue)
                                
                                Spacer()
                                
                                HStack(spacing: 10) {
                                    BalloonView(color: AppTheme.primaryPink, size: 25)
                                        .frame(width: 25, height: 40)
                                    BalloonView(color: AppTheme.primaryBlue, size: 25)
                                        .frame(width: 25, height: 40)
                                }
                            }
                            
                            HStack {
                                Image(systemName: "person.3.fill")
                                    .foregroundColor(AppTheme.primaryBlue)
                                Text("Guest Count")
                                    .foregroundColor(AppTheme.textPrimary)
                                Spacer()
                                PartyBadge(text: "\(viewModel.party.guests.count) invited", color: AppTheme.primaryBlue)
                            }
                            
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(AppTheme.confirmed)
                                Text("Confirmed")
                                    .foregroundColor(AppTheme.textPrimary)
                                Spacer()
                                PartyBadge(text: "\(viewModel.party.confirmedGuestCount()) confirmed", color: AppTheme.confirmed)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.ultraThinMaterial)
                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                        )
                    }
                    .padding()
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: 
                Button(action: {
                    showConfetti.toggle()
                }) {
                    Image(systemName: "party.popper.fill")
                        .foregroundColor(AppTheme.primaryPink)
                        .font(.title2)
                }
            )
            .onAppear {
                // Show confetti briefly when view appears
                showConfetti = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    showConfetti = false
                }
            }
        }
    }
}

#Preview {
    PartyDetailsView()
        .environmentObject(PartyViewModel())
} 
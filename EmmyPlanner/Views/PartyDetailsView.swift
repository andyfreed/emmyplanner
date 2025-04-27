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
                    VStack(spacing: 18) {
                        // Modern clean header
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "gift.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(AppTheme.primaryPink)
                                    .padding(10)
                                    .background(
                                        Circle()
                                            .fill(AppTheme.accentPink.opacity(0.2))
                                    )
                                
                                Text("Emmy's Birthday")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(AppTheme.primaryPink)
                                
                                Spacer()
                                
                                Image(systemName: "birthday.cake.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(AppTheme.primaryPink)
                                    .padding(10)
                                    .background(
                                        Circle()
                                            .fill(AppTheme.accentPink.opacity(0.2))
                                    )
                            }
                            
                            Divider()
                                .background(AppTheme.accentPink.opacity(0.4))
                                .padding(.horizontal, 8)
                            
                            Text(dateFormatter.string(from: viewModel.party.date))
                                .font(.headline)
                                .foregroundColor(AppTheme.textSecondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.bottom, 4)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.ultraThinMaterial)
                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                        )
                        
                        // Party Info
                        GradientCard {
                            VStack(spacing: 14) {
                                HStack {
                                    Text("Party Information")
                                        .font(.headline)
                                        .foregroundColor(AppTheme.primaryPink)
                                    
                                    Spacer()
                                    
                                    SparkleView()
                                        .frame(width: 35, height: 35)
                                }
                                
                                TextField("Party Name", text: $viewModel.party.name)
                                    .foregroundColor(AppTheme.textPrimary)
                                    .padding()
                                    .background(Color.white.opacity(0.7))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(AppTheme.accentPink, lineWidth: 0.5)
                                    )
                                
                                HStack {
                                    Text("Date:")
                                        .foregroundColor(AppTheme.textPrimary)
                                    
                                    Spacer()
                                    
                                    Text("November 23rd, \(Calendar.current.component(.year, from: viewModel.party.date))")
                                        .foregroundColor(AppTheme.primaryPink)
                                        .fontWeight(.medium)
                                }
                                .padding()
                                .background(Color.white.opacity(0.7))
                                .cornerRadius(10)
                                
                                TextField("Location", text: $viewModel.party.location)
                                    .foregroundColor(AppTheme.textPrimary)
                                    .padding()
                                    .background(Color.white.opacity(0.7))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(AppTheme.accentPink, lineWidth: 0.5)
                                    )
                            }
                        }
                        
                        WavySeparator(color: AppTheme.accentPink)
                            .frame(height: 15)
                            .padding(.vertical, 5)
                        
                        // Notes
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Notes")
                                .font(.headline)
                                .foregroundColor(AppTheme.primaryPink)
                            
                            ZStack(alignment: .topLeading) {
                                if viewModel.party.notes.isEmpty {
                                    Text("Add any party notes here...")
                                        .foregroundColor(AppTheme.textSecondary)
                                        .padding(.top, 8)
                                        .padding(.leading, 5)
                                }
                                
                                TextEditor(text: $viewModel.party.notes)
                                    .frame(minHeight: 100)
                                    .foregroundColor(AppTheme.textPrimary)
                                    .padding(5)
                                    .background(Color.white.opacity(0.7))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(AppTheme.accentPink, lineWidth: 0.5)
                                    )
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.5))
                                .background(.ultraThinMaterial)
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
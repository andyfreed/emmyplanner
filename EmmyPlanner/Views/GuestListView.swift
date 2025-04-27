import SwiftUI

struct GuestListView: View {
    @EnvironmentObject var viewModel: PartyViewModel
    @State private var showingAddGuest = false
    @State private var newGuestName = ""
    @State private var newGuestContact = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.backgroundPrimary.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Guest List")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(AppTheme.primaryPink)
                                
                                Text("Add and track your party guests")
                                    .font(.subheadline)
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                showingAddGuest = true
                            }) {
                                HStack {
                                    Image(systemName: "plus")
                                    Text("Add Guest")
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 8)
                                .background(AppTheme.primaryPink)
                                .cornerRadius(20)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.8))
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        )
                        
                        // Guest counter
                        HStack(spacing: 30) {
                            VStack {
                                Text("\(viewModel.party.guests.count)")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundColor(AppTheme.primaryBlue)
                                Text("Invited")
                                    .font(.caption)
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white.opacity(0.7))
                                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1)
                            )
                            
                            VStack {
                                Text("\(viewModel.party.confirmedGuestCount())")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundColor(AppTheme.confirmed)
                                Text("Confirmed")
                                    .font(.caption)
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white.opacity(0.7))
                                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1)
                            )
                        }
                        
                        // Guest list
                        if viewModel.party.guests.isEmpty {
                            VStack(spacing: 15) {
                                Image(systemName: "person.3.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(AppTheme.accentBlue.opacity(0.7))
                                
                                Text("No guests yet")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.textSecondary)
                                
                                Text("Tap '+' to add party guests")
                                    .font(.subheadline)
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white.opacity(0.5))
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            )
                        } else {
                            GradientCard(startColor: AppTheme.primaryBlue, endColor: AppTheme.accentBlue) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Guest List")
                                        .font(.headline)
                                        .foregroundColor(AppTheme.primaryBlue)
                                        .padding(.bottom, 10)
                                    
                                    ForEach(viewModel.party.guests) { guest in
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(guest.name)
                                                    .font(.headline)
                                                    .foregroundColor(AppTheme.textPrimary)
                                                if !guest.contact.isEmpty {
                                                    Text(guest.contact)
                                                        .font(.subheadline)
                                                        .foregroundColor(AppTheme.textSecondary)
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                viewModel.toggleGuestConfirmation(guest: guest)
                                            }) {
                                                Image(systemName: guest.isConfirmed ? "checkmark.circle.fill" : "circle")
                                                    .foregroundColor(guest.isConfirmed ? AppTheme.confirmed : AppTheme.unconfirmed)
                                                    .font(.title2)
                                            }
                                            .buttonStyle(BorderlessButtonStyle())
                                        }
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.white.opacity(0.7))
                                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                        )
                                        .padding(.vertical, 4)
                                        .contentShape(Rectangle())
                                        .contextMenu {
                                            Button(role: .destructive, action: {
                                                if let index = viewModel.party.guests.firstIndex(where: { $0.id == guest.id }) {
                                                    viewModel.party.guests.remove(at: index)
                                                }
                                            }) {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Balloons decoration
                        if !viewModel.party.guests.isEmpty {
                            HStack(spacing: 20) {
                                ForEach(0..<3) { i in
                                    BalloonView(
                                        color: [AppTheme.primaryPink, AppTheme.primaryBlue, AppTheme.accentPink][i],
                                        size: CGFloat.random(in: 30...50)
                                    )
                                    .frame(height: 100)
                                }
                            }
                            .padding(.top, 20)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Guest List")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingAddGuest) {
                NavigationView {
                    ZStack {
                        AppTheme.backgroundSecondary.ignoresSafeArea()
                        
                        ScrollView {
                            VStack(spacing: 20) {
                                Image(systemName: "person.fill.badge.plus")
                                    .font(.system(size: 60))
                                    .foregroundColor(AppTheme.primaryPink)
                                    .padding(.top, 30)
                                
                                Text("Add New Guest")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(AppTheme.primaryPink)
                                
                                VStack(spacing: 15) {
                                    VStack(alignment: .leading) {
                                        Text("Guest Name")
                                            .font(.headline)
                                            .foregroundColor(AppTheme.textPrimary)
                                        
                                        TextField("Name", text: $newGuestName)
                                            .foregroundColor(AppTheme.textPrimary)
                                            .padding()
                                            .background(Color.white.opacity(0.7))
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(AppTheme.accentPink, lineWidth: 1)
                                            )
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text("Contact Information")
                                            .font(.headline)
                                            .foregroundColor(AppTheme.textPrimary)
                                        
                                        TextField("Phone or Email", text: $newGuestContact)
                                            .foregroundColor(AppTheme.textPrimary)
                                            .padding()
                                            .background(Color.white.opacity(0.7))
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(AppTheme.accentPink, lineWidth: 1)
                                            )
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.white.opacity(0.5))
                                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                                )
                                
                                HStack(spacing: 20) {
                                    Button(action: {
                                        showingAddGuest = false
                                        newGuestName = ""
                                        newGuestContact = ""
                                    }) {
                                        Text("Cancel")
                                            .foregroundColor(AppTheme.textSecondary)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.white.opacity(0.7))
                                            .cornerRadius(10)
                                    }
                                    
                                    Button(action: {
                                        if !newGuestName.isEmpty {
                                            viewModel.addGuest(name: newGuestName, contact: newGuestContact)
                                            newGuestName = ""
                                            newGuestContact = ""
                                            showingAddGuest = false
                                        }
                                    }) {
                                        Text("Add Guest")
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(!newGuestName.isEmpty ? AppTheme.primaryPink : AppTheme.textSecondary)
                                            .cornerRadius(10)
                                    }
                                    .disabled(newGuestName.isEmpty)
                                }
                                .padding(.top, 10)
                            }
                            .padding()
                        }
                    }
                    .navigationTitle("")
                    .navigationBarHidden(true)
                }
                .accentColor(AppTheme.primaryPink)
            }
        }
    }
}

#Preview {
    GuestListView()
        .environmentObject(PartyViewModel())
} 
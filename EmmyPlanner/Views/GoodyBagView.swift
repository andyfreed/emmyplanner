import SwiftUI

struct GoodyBagView: View {
    @EnvironmentObject var viewModel: PartyViewModel
    @State private var showingAddItem = false
    @State private var newItemName = ""
    @State private var newItemQuantity = 1
    @State private var newItemPrice: String = ""
    @State private var showBudgetSparkle = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.backgroundPrimary.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        HStack {
                            Text("Goody Bag Planner")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.primaryPink)
                            
                            Spacer()
                            
                            Button(action: {
                                showingAddItem = true
                            }) {
                                HStack {
                                    Image(systemName: "plus")
                                    Text("Add Item")
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
                        
                        // Items List
                        if viewModel.party.goodyBagItems.isEmpty {
                            VStack(spacing: 15) {
                                Image(systemName: "gift.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(AppTheme.accentPink.opacity(0.7))
                                
                                Text("No items yet")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.textSecondary)
                                
                                Text("Tap '+' to add goody bag items")
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
                            // Item cards
                            ForEach(viewModel.party.goodyBagItems) { item in
                                HStack {
                                    Button(action: {
                                        viewModel.toggleItemPurchased(item: item)
                                    }) {
                                        Image(systemName: item.isPurchased ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(item.isPurchased ? AppTheme.purchased : AppTheme.unpurchased)
                                            .font(.title2)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                    
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .font(.headline)
                                            .strikethrough(item.isPurchased)
                                            .foregroundColor(item.isPurchased ? AppTheme.textSecondary : AppTheme.textPrimary)
                                        
                                        HStack {
                                            PartyBadge(
                                                text: "Qty: \(item.quantity)",
                                                color: AppTheme.accentBlue
                                            )
                                            
                                            if let price = item.price {
                                                PartyBadge(
                                                    text: "$\(String(format: "%.2f", price))",
                                                    color: AppTheme.primaryBlue
                                                )
                                            }
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    if item.isPurchased {
                                        Image(systemName: "cart.fill.badge.plus")
                                            .foregroundColor(AppTheme.purchased)
                                            .font(.title3)
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.white.opacity(0.8))
                                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                )
                                .contentShape(Rectangle())
                                .contextMenu {
                                    Button(role: .destructive, action: {
                                        if let index = viewModel.party.goodyBagItems.firstIndex(where: { $0.id == item.id }) {
                                            viewModel.party.goodyBagItems.remove(at: index)
                                        }
                                    }) {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                            
                            // Budget section
                            GradientCard(startColor: AppTheme.primaryBlue, endColor: AppTheme.primaryPink) {
                                VStack(spacing: 20) {
                                    HStack {
                                        Text("Budget Summary")
                                            .font(.headline)
                                            .foregroundColor(AppTheme.primaryBlue)
                                        
                                        Spacer()
                                        
                                        if showBudgetSparkle {
                                            SparkleView(color: AppTheme.primaryBlue)
                                                .frame(width: 40, height: 40)
                                        }
                                    }
                                    
                                    WavySeparator(color: AppTheme.accentBlue)
                                        .frame(height: 20)
                                    
                                    HStack {
                                        Image(systemName: "dollarsign.circle.fill")
                                            .foregroundColor(AppTheme.primaryBlue)
                                            .font(.title2)
                                        Text("Total Cost")
                                            .foregroundColor(AppTheme.textPrimary)
                                        Spacer()
                                        Text("$\(String(format: "%.2f", viewModel.calculateTotalBudget()))")
                                            .font(.headline)
                                            .foregroundColor(AppTheme.primaryBlue)
                                    }
                                    .padding(.vertical, 10)
                                    .padding(.horizontal)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white.opacity(0.7))
                                    )
                                    
                                    if viewModel.party.guests.count > 0 {
                                        HStack {
                                            Image(systemName: "person.fill")
                                                .foregroundColor(AppTheme.primaryPink)
                                                .font(.title2)
                                            Text("Cost per Guest")
                                                .foregroundColor(AppTheme.textPrimary)
                                            Spacer()
                                            Text("$\(String(format: "%.2f", viewModel.calculateTotalBudget() / Double(max(1, viewModel.party.guests.count))))")
                                                .font(.headline)
                                                .foregroundColor(AppTheme.primaryPink)
                                        }
                                        .padding(.vertical, 10)
                                        .padding(.horizontal)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.white.opacity(0.7))
                                        )
                                    }
                                }
                                .onAppear {
                                    // Show budget sparkle when view appears
                                    showBudgetSparkle = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        showBudgetSparkle = false
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Goody Bags")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingAddItem) {
                NavigationView {
                    ZStack {
                        AppTheme.backgroundSecondary.ignoresSafeArea()
                        
                        ScrollView {
                            VStack(spacing: 20) {
                                Image(systemName: "gift.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(AppTheme.primaryPink)
                                    .padding(.top, 30)
                                
                                Text("Add Item to Goody Bags")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(AppTheme.primaryPink)
                                
                                VStack(spacing: 15) {
                                    VStack(alignment: .leading) {
                                        Text("Item Name")
                                            .font(.headline)
                                            .foregroundColor(AppTheme.textPrimary)
                                        
                                        TextField("Item Name", text: $newItemName)
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
                                        Text("Quantity")
                                            .font(.headline)
                                            .foregroundColor(AppTheme.textPrimary)
                                        
                                        HStack {
                                            Button(action: {
                                                if newItemQuantity > 1 {
                                                    newItemQuantity -= 1
                                                }
                                            }) {
                                                Image(systemName: "minus.circle.fill")
                                                    .font(.title2)
                                                    .foregroundColor(AppTheme.primaryBlue)
                                            }
                                            
                                            Text("\(newItemQuantity)")
                                                .font(.title3)
                                                .fontWeight(.bold)
                                                .frame(minWidth: 40)
                                                .foregroundColor(AppTheme.textPrimary)
                                            
                                            Button(action: {
                                                if newItemQuantity < 100 {
                                                    newItemQuantity += 1
                                                }
                                            }) {
                                                Image(systemName: "plus.circle.fill")
                                                    .font(.title2)
                                                    .foregroundColor(AppTheme.primaryPink)
                                            }
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.white.opacity(0.7))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(AppTheme.accentBlue, lineWidth: 1)
                                        )
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text("Price (optional)")
                                            .font(.headline)
                                            .foregroundColor(AppTheme.textPrimary)
                                        
                                        HStack {
                                            Text("$")
                                                .foregroundColor(AppTheme.primaryBlue)
                                                .font(.title3)
                                            
                                            TextField("0.00", text: $newItemPrice)
                                                .keyboardType(.decimalPad)
                                                .foregroundColor(AppTheme.primaryBlue)
                                                .padding()
                                                .background(Color.white.opacity(0.7))
                                                .cornerRadius(10)
                                        }
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(AppTheme.accentBlue, lineWidth: 1)
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
                                        resetNewItemFields()
                                        showingAddItem = false
                                    }) {
                                        Text("Cancel")
                                            .foregroundColor(AppTheme.textSecondary)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.white.opacity(0.7))
                                            .cornerRadius(10)
                                    }
                                    
                                    Button(action: {
                                        if !newItemName.isEmpty {
                                            let newItem = GoodyBagItem(
                                                name: newItemName,
                                                quantity: newItemQuantity,
                                                price: Double(newItemPrice)
                                            )
                                            viewModel.party.goodyBagItems.append(newItem)
                                            resetNewItemFields()
                                            showingAddItem = false
                                        }
                                    }) {
                                        Text("Add Item")
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(!newItemName.isEmpty ? AppTheme.primaryPink : AppTheme.textSecondary)
                                            .cornerRadius(10)
                                    }
                                    .disabled(newItemName.isEmpty)
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
    
    private func resetNewItemFields() {
        newItemName = ""
        newItemQuantity = 1
        newItemPrice = ""
    }
}

#Preview {
    GoodyBagView()
        .environmentObject(PartyViewModel())
} 
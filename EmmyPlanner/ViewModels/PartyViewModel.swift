import Foundation
import SwiftUI

class PartyViewModel: ObservableObject {
    @Published var party: Party
    
    init() {
        // Get current year
        let currentYear = Calendar.current.component(.year, from: Date())
        
        // Create fixed date for November 23rd of current year
        var dateComponents = DateComponents()
        dateComponents.year = currentYear
        dateComponents.month = 11
        dateComponents.day = 23
        dateComponents.hour = 14 // 2 PM
        dateComponents.minute = 0
        
        // Get the date from components
        let emmyBirthday = Calendar.current.date(from: dateComponents) ?? Date()
        
        // Initialize with Emmy's Birthday
        self.party = Party(
            name: "Emmy's Birthday",
            date: emmyBirthday,
            location: "Our Home",
            theme: "",
            notes: ""
        )
    }
    
    // Guest management
    func addGuest(name: String, contact: String) {
        let newGuest = Guest(name: name, contact: contact)
        party.guests.append(newGuest)
    }
    
    func removeGuest(at offsets: IndexSet) {
        party.guests.remove(atOffsets: offsets)
    }
    
    func toggleGuestConfirmation(guest: Guest) {
        if let index = party.guests.firstIndex(where: { $0.id == guest.id }) {
            party.guests[index].isConfirmed.toggle()
        }
    }
    
    // Goody bag management
    func addGoodyBagItem(name: String, quantity: Int) {
        let newItem = GoodyBagItem(name: name, quantity: quantity)
        party.goodyBagItems.append(newItem)
    }
    
    func removeGoodyBagItem(at offsets: IndexSet) {
        party.goodyBagItems.remove(atOffsets: offsets)
    }
    
    func toggleItemPurchased(item: GoodyBagItem) {
        if let index = party.goodyBagItems.firstIndex(where: { $0.id == item.id }) {
            party.goodyBagItems[index].isPurchased.toggle()
        }
    }
    
    // Update price for an item
    func updateItemPrice(item: GoodyBagItem, price: Double) {
        if let index = party.goodyBagItems.firstIndex(where: { $0.id == item.id }) {
            party.goodyBagItems[index].price = price
        }
    }
    
    // Calculate total budget for goody bags
    func calculateTotalBudget() -> Double {
        return party.goodyBagItems.compactMap { $0.price }.reduce(0, +)
    }
} 
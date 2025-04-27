import Foundation
import SwiftUI
import CoreData

class PartyViewModel: ObservableObject {
    @Published var party: Party
    private let persistenceController: PersistenceController
    private var cdParty: CDParty?
    
    init(persistenceController: PersistenceController = PersistenceController.shared) {
        self.persistenceController = persistenceController
        self.party = Party(
            name: "Emmy's Birthday",
            date: Date(),
            location: "Our Home",
            theme: "",
            notes: ""
        )
        
        // Load party from Core Data
        loadParty()
    }
    
    private func loadParty() {
        let context = persistenceController.container.viewContext
        let request: NSFetchRequest<CDParty> = CDParty.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            
            if let existingParty = results.first {
                // Use the existing party from Core Data
                self.cdParty = existingParty
                self.party = existingParty.toParty()
                print("Loaded party from Core Data")
            } else {
                // Create a default party if none exists
                print("No existing party found, creating default")
                persistenceController.createInitialPartyIfNeeded()
                
                // Fetch the newly created party
                if let newParty = try context.fetch(request).first {
                    self.cdParty = newParty
                    self.party = newParty.toParty()
                }
            }
        } catch {
            print("Error loading party: \(error)")
        }
    }
    
    // MARK: - Data Persistence
    private func saveContext() {
        let context = persistenceController.container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("Context saved successfully")
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    // Save party details
    func saveParty() {
        let context = persistenceController.container.viewContext
        
        if let cdParty = self.cdParty {
            // Update existing party
            cdParty.update(from: party, context: context)
        } else {
            // Create new party
            self.cdParty = CDParty.create(from: party, context: context)
        }
        
        saveContext()
    }
    
    // MARK: - Guest management
    func addGuest(name: String, contact: String) {
        let newGuest = Guest(name: name, contact: contact)
        party.guests.append(newGuest)
        
        // Create Core Data guest
        if let cdParty = self.cdParty {
            let context = persistenceController.container.viewContext
            let cdGuest = CDGuest.create(from: newGuest, context: context)
            cdGuest.party = cdParty
            saveContext()
        }
    }
    
    func removeGuest(at offsets: IndexSet) {
        // Get the guests to remove
        let guestsToRemove = offsets.map { party.guests[$0] }
        
        // Remove from Core Data
        if let cdParty = self.cdParty {
            let context = persistenceController.container.viewContext
            
            // Get Core Data guests
            if let cdGuests = cdParty.guests?.allObjects as? [CDGuest] {
                for guestToRemove in guestsToRemove {
                    if let cdGuest = cdGuests.first(where: { $0.id == guestToRemove.id }) {
                        context.delete(cdGuest)
                    }
                }
            }
            saveContext()
        }
        
        // Remove from memory model
        party.guests.remove(atOffsets: offsets)
    }
    
    func toggleGuestConfirmation(guest: Guest) {
        if let index = party.guests.firstIndex(where: { $0.id == guest.id }) {
            party.guests[index].isConfirmed.toggle()
            
            // Update Core Data
            if let cdParty = self.cdParty,
               let cdGuests = cdParty.guests?.allObjects as? [CDGuest],
               let cdGuest = cdGuests.first(where: { $0.id == guest.id }) {
                cdGuest.isConfirmed = party.guests[index].isConfirmed
                saveContext()
            }
        }
    }
    
    // MARK: - Goody bag management
    func addGoodyBagItem(name: String, quantity: Int) {
        let newItem = GoodyBagItem(name: name, quantity: quantity)
        party.goodyBagItems.append(newItem)
        
        // Create Core Data item
        if let cdParty = self.cdParty {
            let context = persistenceController.container.viewContext
            let cdItem = CDGoodyBagItem.create(from: newItem, context: context)
            cdItem.party = cdParty
            saveContext()
        }
    }
    
    func removeGoodyBagItem(at offsets: IndexSet) {
        // Get the items to remove
        let itemsToRemove = offsets.map { party.goodyBagItems[$0] }
        
        // Remove from Core Data
        if let cdParty = self.cdParty {
            let context = persistenceController.container.viewContext
            
            // Get Core Data items
            if let cdItems = cdParty.goodyBagItems?.allObjects as? [CDGoodyBagItem] {
                for itemToRemove in itemsToRemove {
                    if let cdItem = cdItems.first(where: { $0.id == itemToRemove.id }) {
                        context.delete(cdItem)
                    }
                }
            }
            saveContext()
        }
        
        // Remove from memory model
        party.goodyBagItems.remove(atOffsets: offsets)
    }
    
    func toggleItemPurchased(item: GoodyBagItem) {
        if let index = party.goodyBagItems.firstIndex(where: { $0.id == item.id }) {
            party.goodyBagItems[index].isPurchased.toggle()
            
            // Update Core Data
            if let cdParty = self.cdParty,
               let cdItems = cdParty.goodyBagItems?.allObjects as? [CDGoodyBagItem],
               let cdItem = cdItems.first(where: { $0.id == item.id }) {
                cdItem.isPurchased = party.goodyBagItems[index].isPurchased
                saveContext()
            }
        }
    }
    
    // Update price for an item
    func updateItemPrice(item: GoodyBagItem, price: Double) {
        if let index = party.goodyBagItems.firstIndex(where: { $0.id == item.id }) {
            party.goodyBagItems[index].price = price
            
            // Update Core Data
            if let cdParty = self.cdParty,
               let cdItems = cdParty.goodyBagItems?.allObjects as? [CDGoodyBagItem],
               let cdItem = cdItems.first(where: { $0.id == item.id }) {
                cdItem.price = price
                saveContext()
            }
        }
    }
    
    // Calculate total budget for goody bags
    func calculateTotalBudget() -> Double {
        return party.goodyBagItems.compactMap { $0.price }.reduce(0, +)
    }
} 
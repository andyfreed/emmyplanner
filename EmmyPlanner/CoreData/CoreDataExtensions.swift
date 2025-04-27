import Foundation
import CoreData

// MARK: - CDParty Extensions
extension CDParty {
    // Convert Core Data party to regular Party model
    func toParty() -> Party {
        let guestsArray = self.guests?.allObjects as? [CDGuest] ?? []
        let goodyBagItemsArray = self.goodyBagItems?.allObjects as? [CDGoodyBagItem] ?? []
        
        return Party(
            id: self.id ?? UUID(),
            name: self.name ?? "",
            date: self.date ?? Date(),
            location: self.location ?? "",
            theme: self.theme ?? "",
            notes: self.notes ?? "",
            guests: guestsArray.map { $0.toGuest() },
            goodyBagItems: goodyBagItemsArray.map { $0.toGoodyBagItem() }
        )
    }
    
    // Update Core Data party with values from Party model
    func update(from party: Party, context: NSManagedObjectContext) {
        self.id = party.id
        self.name = party.name
        self.date = party.date
        self.location = party.location
        self.theme = party.theme
        self.notes = party.notes
        
        // We don't update relationships here as they're handled separately
    }
    
    // Create a new CDParty from Party model
    static func create(from party: Party, context: NSManagedObjectContext) -> CDParty {
        let cdParty = CDParty(context: context)
        cdParty.id = party.id
        cdParty.name = party.name
        cdParty.date = party.date
        cdParty.location = party.location
        cdParty.theme = party.theme
        cdParty.notes = party.notes
        
        // Create guests
        for guest in party.guests {
            let cdGuest = CDGuest.create(from: guest, context: context)
            cdGuest.party = cdParty
        }
        
        // Create goody bag items
        for item in party.goodyBagItems {
            let cdItem = CDGoodyBagItem.create(from: item, context: context)
            cdItem.party = cdParty
        }
        
        return cdParty
    }
}

// MARK: - CDGuest Extensions
extension CDGuest {
    // Convert Core Data guest to regular Guest model
    func toGuest() -> Guest {
        return Guest(
            id: self.id ?? UUID(),
            name: self.name ?? "",
            contact: self.contact ?? "",
            isConfirmed: self.isConfirmed,
            notes: self.notes ?? ""
        )
    }
    
    // Update Core Data guest with values from Guest model
    func update(from guest: Guest) {
        self.id = guest.id
        self.name = guest.name
        self.contact = guest.contact
        self.isConfirmed = guest.isConfirmed
        self.notes = guest.notes
    }
    
    // Create a new CDGuest from Guest model
    static func create(from guest: Guest, context: NSManagedObjectContext) -> CDGuest {
        let cdGuest = CDGuest(context: context)
        cdGuest.id = guest.id
        cdGuest.name = guest.name
        cdGuest.contact = guest.contact
        cdGuest.isConfirmed = guest.isConfirmed
        cdGuest.notes = guest.notes
        return cdGuest
    }
}

// MARK: - CDGoodyBagItem Extensions
extension CDGoodyBagItem {
    // Convert Core Data goody bag item to regular GoodyBagItem model
    func toGoodyBagItem() -> GoodyBagItem {
        return GoodyBagItem(
            id: self.id ?? UUID(),
            name: self.name ?? "",
            quantity: Int(self.quantity),
            isPurchased: self.isPurchased,
            price: self.price as Double?
        )
    }
    
    // Update Core Data goody bag item with values from GoodyBagItem model
    func update(from item: GoodyBagItem) {
        self.id = item.id
        self.name = item.name
        self.quantity = Int32(item.quantity)
        self.isPurchased = item.isPurchased
        self.price = item.price as NSNumber?
    }
    
    // Create a new CDGoodyBagItem from GoodyBagItem model
    static func create(from item: GoodyBagItem, context: NSManagedObjectContext) -> CDGoodyBagItem {
        let cdItem = CDGoodyBagItem(context: context)
        cdItem.id = item.id
        cdItem.name = item.name
        cdItem.quantity = Int32(item.quantity)
        cdItem.isPurchased = item.isPurchased
        cdItem.price = item.price as NSNumber?
        return cdItem
    }
} 
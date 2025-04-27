import CoreData

/// A controller to manage Core Data persistence
struct PersistenceController {
    /// Shared singleton instance
    static let shared = PersistenceController()
    
    /// A test instance with a pre-populated in-memory store
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        // Create sample party for previews
        let sampleParty = CDParty(context: viewContext)
        sampleParty.id = UUID()
        sampleParty.name = "Emmy's Birthday"
        sampleParty.date = createBirthday()
        sampleParty.location = "Our Home"
        sampleParty.theme = "Princess"
        sampleParty.notes = ""
        
        // Create sample guests
        for i in 1...5 {
            let guest = CDGuest(context: viewContext)
            guest.id = UUID()
            guest.name = "Guest \(i)"
            guest.contact = "contact\(i)@email.com"
            guest.isConfirmed = Bool.random()
            guest.notes = ""
            guest.party = sampleParty
        }
        
        // Create sample goodybag items
        for i in 1...3 {
            let item = CDGoodyBagItem(context: viewContext)
            item.id = UUID()
            item.name = "Item \(i)"
            item.quantity = Int32(i * 5)
            item.isPurchased = Bool.random()
            item.price = Double(i) * 2.5
            item.party = sampleParty
        }
        
        try? viewContext.save()
        return controller
    }()
    
    /// The persistent container for Core Data
    let container: NSPersistentContainer
    
    /// Initializer for the persistence controller
    /// - Parameter inMemory: Whether to use an in-memory store (for previews/testing)
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "EmmyPlannerModel")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { (description, error) in
            if let error = error as NSError? {
                fatalError("Failed to load Core Data: \(error), \(error.userInfo)")
            }
        }
        
        // Merge changes from background contexts automatically
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    // Create an initial default party if none exists
    func createInitialPartyIfNeeded() {
        let context = container.viewContext
        
        // Check if a party already exists
        let fetchRequest: NSFetchRequest<CDParty> = CDParty.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
            if count == 0 {
                // No parties exist, create default
                let currentYear = Calendar.current.component(.year, from: Date())
                
                let defaultParty = CDParty(context: context)
                defaultParty.id = UUID()
                defaultParty.name = "Emmy's Birthday"
                defaultParty.date = Self.createBirthday()
                defaultParty.location = "Our Home"
                defaultParty.theme = ""
                defaultParty.notes = ""
                
                try context.save()
                print("Created initial party")
            }
        } catch {
            print("Error checking for existing parties: \(error)")
        }
    }
    
    // Helper to create Emmy's birthday
    private static func createBirthday() -> Date {
        let currentYear = Calendar.current.component(.year, from: Date())
        
        var dateComponents = DateComponents()
        dateComponents.year = currentYear
        dateComponents.month = 11
        dateComponents.day = 23
        dateComponents.hour = 14 // 2 PM
        dateComponents.minute = 0
        
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
} 
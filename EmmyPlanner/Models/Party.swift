import Foundation

struct Party: Identifiable, Codable {
    var id = UUID()
    var name: String
    var date: Date
    var location: String
    var theme: String
    var notes: String
    var guests: [Guest] = []
    var goodyBagItems: [GoodyBagItem] = []
    
    // Function to calculate number of confirmed guests
    func confirmedGuestCount() -> Int {
        return guests.filter { $0.isConfirmed }.count
    }
}

struct Guest: Identifiable, Codable {
    var id = UUID()
    var name: String
    var contact: String
    var isConfirmed: Bool = false
    var notes: String = ""
}

struct GoodyBagItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var quantity: Int
    var isPurchased: Bool = false
    var price: Double? = nil
} 
import FirebaseFirestore
import Foundation

struct Discount: Identifiable, Decodable {
    @DocumentID var id: String?
    let storeId: String
    let storeName: String
    let storeAddress: String
    let latitude: Double
    let longitude: Double
    let title: String
    let description: String
    let category: String
    let discountType: String       // "percentage" / "freeItem"
    let discountValue: Int
    let label: String              // "20% OFF", "FREE"
    let isFeatured: Bool
    let startDate: Date
    let endDate: Date
    let imageUrl: String?
    
    var distanceKm: Double = 0
    var isSaved: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case storeId
        case storeName
        case storeAddress
        case latitude
        case longitude
        case title
        case description
        case category
        case discountType
        case discountValue
        case label
        case isFeatured
        case startDate
        case endDate
        case imageUrl
    }
}

struct DiscountCategory: Identifiable {
    let id: String
    let name: String
    let icon: String
}

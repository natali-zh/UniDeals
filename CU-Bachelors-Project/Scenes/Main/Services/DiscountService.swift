import FirebaseFirestore

protocol DiscountServiceProtocol {
    func fetchAllDiscounts() async throws -> [Discount]
    func fetchDiscount(id: String) async throws -> Discount
    func fetchDiscountsByStore(storeId: String) async throws -> [Discount]
    func fetchDiscountsByStoreName(storeName: String) async throws -> [Discount]
}

final class DiscountService: DiscountServiceProtocol {
    
    static let shared = DiscountService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func fetchAllDiscounts() async throws -> [Discount] {
        let snapshot = try await db.collection("discounts").getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Discount.self) }
    }

    func fetchDiscount(id: String) async throws -> Discount {
        let doc = try await db.collection("discounts").document(id).getDocument()
        return try doc.data(as: Discount.self)
    }

    func fetchDiscountsByStore(storeId: String) async throws -> [Discount] {
        let snapshot = try await db.collection("discounts")
            .whereField("storeId", isEqualTo: storeId)
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Discount.self) }
    }

    func fetchDiscountsByStoreName(storeName: String) async throws -> [Discount] {
        let snapshot = try await db.collection("discounts")
            .whereField("storeName", isEqualTo: storeName)
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Discount.self) }
    }
}

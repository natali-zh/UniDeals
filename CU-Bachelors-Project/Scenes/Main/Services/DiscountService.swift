import FirebaseFirestore

protocol DiscountServiceProtocol {
    func fetchAllDiscounts() async throws -> [Discount]
    func fetchDiscount(id: String) async throws -> Discount
}

final class DiscountService: DiscountServiceProtocol {

    // MARK: - Properties

    static let shared = DiscountService()
    private let db = Firestore.firestore()

    // MARK: - Init

    private init() {}

    // MARK: - Methods

    func fetchAllDiscounts() async throws -> [Discount] {
        let snapshot = try await db.collection(FirestoreCollections.discounts).getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Discount.self) }
    }

    func fetchDiscount(id: String) async throws -> Discount {
        let doc = try await db.collection(FirestoreCollections.discounts).document(id).getDocument()
        return try doc.data(as: Discount.self)
    }
}

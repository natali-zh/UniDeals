import FirebaseFirestore

final class SavedDiscountsService {

    static let shared = SavedDiscountsService()
    private let db = Firestore.firestore()
    private var cachedIds: [String]?
    private init() {}

    func invalidateCache() {
        cachedIds = nil
    }

    func fetchSavedIds(uid: String) async throws -> [String] {
        if let cached = cachedIds { return cached }
        let doc = try await db.collection(FirestoreCollections.users).document(uid).getDocument()
        let ids = doc.data()?["savedDiscountIds"] as? [String] ?? []
        cachedIds = ids
        return ids
    }

    func save(discountId: String, uid: String) async throws {
        try await db.collection(FirestoreCollections.users).document(uid)
            .updateData(["savedDiscountIds": FieldValue.arrayUnion([discountId])])
        cachedIds = (cachedIds ?? []) + [discountId]
    }

    func unsave(discountId: String, uid: String) async throws {
        try await db.collection(FirestoreCollections.users).document(uid)
            .updateData(["savedDiscountIds": FieldValue.arrayRemove([discountId])])
        cachedIds = cachedIds?.filter { $0 != discountId }
    }

    func fetchSavedDiscounts(uid: String) async throws -> [Discount] {
        let ids = try await fetchSavedIds(uid: uid)
        guard !ids.isEmpty else { return [] }
        var result: [Discount] = []
        for id in ids {
            if var discount = try? await DiscountService.shared.fetchDiscount(id: id) {
                discount.isSaved = true
                result.append(discount)
            }
        }
        return DiscountFormatter.withDistances(result)
    }
}

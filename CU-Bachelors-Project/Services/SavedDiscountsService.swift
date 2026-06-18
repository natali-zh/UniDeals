//
//  SavedDiscountsService.swift
//  CU-Bachelors-Project
//

import FirebaseFirestore

final class SavedDiscountsService {

    static let shared = SavedDiscountsService()
    private let db = Firestore.firestore()
    private init() {}

    func fetchSavedIds(uid: String) async throws -> [String] {
        let doc = try await db.collection(FirestorePaths.users).document(uid).getDocument()
        return doc.data()?["savedDiscountIds"] as? [String] ?? []
    }

    func save(discountId: String, uid: String) async throws {
        try await db.collection(FirestorePaths.users).document(uid)
            .updateData(["savedDiscountIds": FieldValue.arrayUnion([discountId])])
    }

    func unsave(discountId: String, uid: String) async throws {
        try await db.collection(FirestorePaths.users).document(uid)
            .updateData(["savedDiscountIds": FieldValue.arrayRemove([discountId])])
    }

    func fetchSavedDiscounts(uid: String) async throws -> [Discount] {
        let ids = try await fetchSavedIds(uid: uid)
        guard !ids.isEmpty else { return [] }
        var result: [Discount] = []
        for id in ids {
            if let discount = try? await DiscountService.shared.fetchDiscount(id: id) {
                var saved = discount; saved.isSaved = true; result.append(saved)
            }
        }
        return DiscountFormatter.withDistances(result)
    }
}

//
//  DiscountService.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 17.06.26.
//

import FirebaseFirestore

protocol DiscountServiceProtocol {
    func fetchAllDiscounts() async throws -> [Discount]
}

final class DiscountService: DiscountServiceProtocol {
    
    static let shared = DiscountService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func fetchAllDiscounts() async throws -> [Discount] {
        let snapshot = try await db.collection("discounts").getDocuments()
        return try snapshot.documents.compactMap { doc in
            try doc.data(as: Discount.self)
        }
    }
}

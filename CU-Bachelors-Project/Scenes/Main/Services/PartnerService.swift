//
//  PartnerService.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 17.06.26.
//

import FirebaseFirestore

protocol PartnerServiceProtocol {
    func fetchAllPartners() async throws -> [Partner]
}

final class PartnerService: PartnerServiceProtocol {

    static let shared = PartnerService()
    private let db = Firestore.firestore()

    private init() {}

    func fetchAllPartners() async throws -> [Partner] {
        let snapshot = try await db.collection("partners").getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Partner.self) }
    }
}

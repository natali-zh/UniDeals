//
//  Partner.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 17.06.26.
//

import FirebaseFirestore
import Foundation

struct Partner: Identifiable, Decodable {
    @DocumentID var id: String?
    let name: String
    let category: String
    let address: String
    let description: String
    let logoUrl: String?
    let rating: Double
    let offerCount: Int
    let phone: String?
    let website: String?
}

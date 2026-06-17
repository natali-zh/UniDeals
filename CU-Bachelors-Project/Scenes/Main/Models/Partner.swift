//
//  Partner.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 17.06.26.
//

import FirebaseFirestore
import Foundation
import CoreLocation

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
    let latitude: Double?
    let longitude: Double?

    var coordinate: CLLocationCoordinate2D? {
        guard let lat = latitude, let lng = longitude else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}

//
//  DiscountFilter.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 17.06.26.
//

import Foundation

struct DiscountFilter: Equatable {
    var sortBy: SortOption = .default
    var maxDistanceKm: Double? = nil
    var discountType: DiscountTypeFilter = .all

    var isActive: Bool {
        sortBy != .default || maxDistanceKm != nil || discountType != .all
    }

    enum SortOption: String, CaseIterable {
        case `default` = "ნაგულისხმევი"
        case nearest = "ახლოს"
        case expiringSoon = "მალე იწურება"
    }

    enum DiscountTypeFilter: String, CaseIterable {
        case all = "ყველა"
        case percentage = "ფასდაკლება %"
        case freeItem = "უფასო"

        var firestoreValue: String? {
            switch self {
            case .all: return nil
            case .percentage: return "percentage"
            case .freeItem: return "freeItem"
            }
        }
    }
}

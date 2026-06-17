//
//  DiscountFilter.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 17.06.26.
//

import Foundation

struct DiscountFilter: Equatable {
    var discountType: DiscountTypeFilter = .all
    var maxDistanceKm: Double?
    var sortBy: SortOption? = nil

    var isActive: Bool {
        sortBy != nil || discountType != .all || maxDistanceKm != nil
    }

    enum SortOption: String, CaseIterable {
        case nearest, expiringSoon, newest

        var label: String {
            switch self {
            case .nearest:      return "მანძილი"
            case .expiringSoon: return "ვადა"
            case .newest:       return "დამატების თარიღი"
            }
        }

        var arrow: String {
            switch self {
            case .nearest:      return "↑"
            case .expiringSoon: return "↑"
            case .newest:       return "↓"
            }
        }
    }

    enum DiscountTypeFilter: String, CaseIterable {
        case all        = "ყველა"
        case percentage = "ფასდაკლება %"
        case freeItem   = "უფასო"

        var firestoreValue: String? {
            switch self {
            case .all:        return nil
            case .percentage: return "percentage"
            case .freeItem:   return "freeItem"
            }
        }
    }
}

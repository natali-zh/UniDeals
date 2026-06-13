//
//  FirestorePaths.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 13.06.26.
//

import Foundation

struct FirestorePaths {
    static let order = "orders"
    static let users = "users"
    static let menu = "menu"
    
    static func getCartPath() -> String? {
        guard let userId = SessionManager.shared.userId else { return nil }
        return "users/\(userId)/cart"
    }
    
    static func getSavedCardsPath() -> String? {
        guard let userId = SessionManager.shared.userId else { return nil }
        return "users/\(userId)/cards"
    }
    
    static func getSavedOrdersPath() -> String? {
        guard let userId = SessionManager.shared.userId else { return nil }
        return "users/\(userId)/savedOrders"
    }
}

//
//  SessionManager.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 13.06.26.
//

import Foundation
import FirebaseAuth

enum AppFlow {
    case auth
    case main
}

final class SessionManager {
    
    //MARK: - Properties
    
    static let shared = SessionManager()
    
    //MARK: - Init
    
    private init() {
       // try? Auth.auth().signOut()
    }
    
    //MARK: - Computed Properties
    
    var isLoggedIn: Bool {
        Auth.auth().currentUser != nil
    }
    
    var userId: String? {
        Auth.auth().currentUser?.uid
    }
    
    //MARK: - Methods
    
    func determineInitialFlow() -> AppFlow {
        if !isLoggedIn {
            return .auth
        } else {
            return .main
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            UserManager.shared.clearUser()
        } catch {
            print("logout failed: \(error.localizedDescription)")
        }
    }
}

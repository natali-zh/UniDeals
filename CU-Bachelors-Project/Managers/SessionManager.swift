//
//  SessionManager.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 13.06.26.
//

import Foundation
import FirebaseAuth

enum AppFlow {
    case onboarding
    case auth
    case main
}

final class SessionManager {
    
    //MARK: - Properties
    
    static let shared = SessionManager()
    private let onBoardingKey = "isOnBoardingCompleted"
    
    //MARK: - Init
    
    private init() {
//        isOnBoardingCompleted = false
//        try? Auth.auth().signOut()
    }
    
    //MARK: - Computed Properties
    
    var isOnBoardingCompleted: Bool {
        get { UserDefaults.standard.bool(forKey: onBoardingKey) }
        set { UserDefaults.standard.set(newValue, forKey: onBoardingKey) }
    }
    
    var isLoggedIn: Bool {
        Auth.auth().currentUser != nil
    }
    
    var userId: String? {
        Auth.auth().currentUser?.uid
    }
    
    //MARK: - Methods
    
    func determineInitialFlow() -> AppFlow {
        if !isOnBoardingCompleted {
            return .onboarding
        } else if !isLoggedIn {
            return .auth
        } else {
            return .main
        }
    }
    
    func completeOnboarding() {
        isOnBoardingCompleted = true
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

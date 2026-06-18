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
    
    private init() {}
    
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
            SavedDiscountsService.shared.invalidateCache()
        } catch {
            print("logout failed: \(error.localizedDescription)")
        }
    }
}

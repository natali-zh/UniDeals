import Foundation
import Combine

final class UserManager: ObservableObject {
    
    //MARK: - Properties
    
    static let shared = UserManager()
    
    @Published var currentUser: User? = nil
    
    private let firestoreService: FirestoreServiceProtocol
    private let sessionManager: SessionManager
    
    
    //MARK: - Init
    
    private init(firestoreService: FirestoreServiceProtocol = FirestoreService.shared, sessionManager: SessionManager = .shared) {
        self.firestoreService = firestoreService
        self.sessionManager = sessionManager
    }
    
    //MARK: - Methods
    
    func fetchUser() async {
        guard let userId = sessionManager.userId else { return }
        do {
            currentUser = try await firestoreService.fetchDocument(from: FirestorePaths.users, documentId: userId, as: User.self)
        } catch {
            print("fetchuser: \(error.localizedDescription)")
        }
    }
    
    func clearUser() {
        currentUser = nil
    }
}

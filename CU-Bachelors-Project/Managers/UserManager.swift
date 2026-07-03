import Foundation

@MainActor
@Observable
final class UserManager {
    
    //MARK: - Properties
    
    static let shared = UserManager()
    
    var currentUser: User? = nil
    
    private let firestoreService: FirestoreServiceProtocol
    private let sessionManager: SessionManager
    
    
    //MARK: - Init
    
    init(firestoreService: FirestoreServiceProtocol, sessionManager: SessionManager)  {
        self.firestoreService = firestoreService
        self.sessionManager = sessionManager
    }
    
    convenience init() {
        self.init(firestoreService: FirestoreService.shared, sessionManager: .shared)
    }
    
    //MARK: - Methods
    
    func fetchUser() async {
        guard let userId = sessionManager.userId else { return }
        do {
            currentUser = try await firestoreService.fetchDocument(from: FirestoreCollections.users, documentId: userId)
        } catch {
            print("fetchuser: \(error.localizedDescription)")
        }
    }
    
    func clearUser() {
        currentUser = nil
    }
}

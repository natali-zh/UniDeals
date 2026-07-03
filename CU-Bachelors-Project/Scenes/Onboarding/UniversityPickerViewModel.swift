import Foundation

@MainActor
@Observable
final class UniversityPickerViewModel {

    var searchQuery = ""
    var selectedUniversity: String?
    var errorMessage: String?

    var onComplete: ((String) -> Void)?

    private let firestoreService: FirestoreServiceProtocol
    private let sessionManager: SessionManager

    init(
        firestoreService: FirestoreServiceProtocol = FirestoreService.shared,
        sessionManager: SessionManager = .shared
    ) {
        self.firestoreService = firestoreService
        self.sessionManager = sessionManager
    }

    var filteredUniversities: [String] {
        let q = searchQuery.trimmingCharacters(in: .whitespaces).lowercased()
        guard !q.isEmpty else { return GeorgianUniversities.all }
        return GeorgianUniversities.all.filter { $0.lowercased().contains(q) }
    }

    func confirm() {
        guard let university = selectedUniversity else { return }
        onComplete?(university)
    }
}

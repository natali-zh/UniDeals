import Foundation

@MainActor
@Observable
final class UniversityPickerViewModel {

    var searchQuery = ""
    var selectedUniversity: String? = nil
    var isSaving = false
    var errorMessage: String? = nil

    // MARK: - Callbacks

    var onComplete: ((String) -> Void)?

    // MARK: - Dependencies

    private let firestoreService: FirestoreServiceProtocol
    private let sessionManager: SessionManager

    // MARK: - Init

    init(
        firestoreService: FirestoreServiceProtocol = FirestoreService.shared,
        sessionManager: SessionManager = .shared
    ) {
        self.firestoreService = firestoreService
        self.sessionManager = sessionManager
    }

    // MARK: - Computed

    var filteredUniversities: [String] {
        let q = searchQuery.trimmingCharacters(in: .whitespaces).lowercased()
        guard !q.isEmpty else { return GeorgianUniversities.all }
        return GeorgianUniversities.all.filter { $0.lowercased().contains(q) }
    }

    // MARK: - Methods

    func confirm() {
        guard let university = selectedUniversity else { return }
        onComplete?(university)
    }
}

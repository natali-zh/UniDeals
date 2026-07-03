import Foundation

@MainActor
@Observable
final class GraduationYearPickerViewModel {

    var selectedSemester: Int? = nil
    var isSaving = false
    var errorMessage: String? = nil

    var onComplete: (() -> Void)?

    let university: String
    let semesters = Array(1...8)

    private let firestoreService: FirestoreServiceProtocol
    private let sessionManager: SessionManager

    init(university: String, firestoreService: FirestoreServiceProtocol, sessionManager: SessionManager) {
        self.university = university
        self.firestoreService = firestoreService
        self.sessionManager = sessionManager
    }

    convenience init(university: String) {
        self.init(university: university, firestoreService: FirestoreService.shared, sessionManager: .shared)
    }

    func confirm() async {
        guard let semester = selectedSemester, let uid = sessionManager.userId else { return }
        isSaving = true
        do {
            try await firestoreService.updateDocument(
                collection: FirestoreCollections.users,
                documentId: uid,
                fields: ["university": university, "semester": semester]
            )
            UserManager.shared.currentUser?.university = university
            UserManager.shared.currentUser?.semester = semester
            onComplete?()
        } catch {
            errorMessage = "შენახვა ვერ მოხდა. სცადე თავიდან."
        }
        isSaving = false
    }
}

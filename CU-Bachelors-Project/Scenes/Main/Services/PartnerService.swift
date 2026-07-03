import FirebaseFirestore

protocol PartnerServiceProtocol {
    func fetchAllPartners() async throws -> [Partner]
    func fetchPartner(id: String) async throws -> Partner
}

final class PartnerService: PartnerServiceProtocol {

    // MARK: - Properties

    static let shared = PartnerService()
    private let db = Firestore.firestore()

    // MARK: - Init

    private init() {}

    // MARK: - Methods

    func fetchAllPartners() async throws -> [Partner] {
        let snapshot = try await db.collection(FirestoreCollections.partners).getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Partner.self) }
    }

    func fetchPartner(id: String) async throws -> Partner {
        let doc = try await db.collection(FirestoreCollections.partners).document(id).getDocument()
        return try doc.data(as: Partner.self)
    }
}

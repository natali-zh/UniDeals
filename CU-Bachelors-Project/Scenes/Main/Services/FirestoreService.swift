import FirebaseFirestore

protocol FirestoreServiceProtocol {
    func uploadDocument<T: Encodable>(_ object: T, to collection: String, documentId: String?) async throws -> String
    func fetchDocument<T: Decodable>(from collection: String, documentId: String, as type: T.Type) async throws -> T?
    func fetchCollection<T: Decodable>(from collection: String, as type: T.Type) async throws -> [T]
    func fetchUserOrders<T: Decodable>(from collection: String, as type: T.Type, userId: String) async throws -> [T]
    func updateDocument(collection: String, documentId: String, fields: [String: Any]) async throws
    func deleteDocument(collectionName: String, documentID: String) async throws
}

final class FirestoreService: FirestoreServiceProtocol {
    
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    
    private init() {}

    func fetchDocument<T: Decodable>(from collection: String, documentId: String, as type: T.Type) async throws -> T? {
        let docRef = db.collection(collection).document(documentId)
        let snapshot = try await docRef.getDocument()
        let data = try snapshot.data(as: type)
        return data
    }
    
    
    func fetchCollection<T: Decodable>(from collection: String, as type: T.Type) async throws -> [T] {
        let querySnapshot = try await db.collection(collection).getDocuments()
        return try querySnapshot.documents.compactMap { doc in
            try doc.data(as: type)
        }
    }
    
    func fetchUserOrders<T: Decodable>(from collection: String, as type: T.Type, userId: String) async throws -> [T] {
        let querySnapshot = try await db.collection(collection)
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
        return try querySnapshot.documents.compactMap { doc in
            try doc.data(as: type)
        }
    }
    
    func uploadDocument<T: Encodable>(_ object: T, to collection: String, documentId: String? = nil) async throws -> String {
        let docRef: DocumentReference
        if let documentId {
            docRef = db.collection(collection).document(documentId)
        } else {
            docRef = db.collection(collection).document()
        }
        try docRef.setData(from: object)
        return docRef.documentID
    }
    
    func updateDocument(collection: String, documentId: String, fields: [String: Any]) async throws {
        try await db.collection(collection)
            .document(documentId)
            .updateData(fields)
    }
    
    func deleteDocument(collectionName: String, documentID: String) async throws {
        let docRef = db.collection(collectionName).document(documentID)
        try await docRef.delete()
    }
}

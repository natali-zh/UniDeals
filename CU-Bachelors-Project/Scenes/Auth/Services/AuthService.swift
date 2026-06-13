//
//  AuthService.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 13.06.26.
//

import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import FirebaseFirestore

protocol AuthServiceProtocol {
    func signInWithGoogle(presenting: UIViewController) async throws
    func logIn(email: String, password: String) async throws
    func register(user: User, password: String) async throws
    func resetPassword(email: String) async throws
    func signOut() throws
}

final class AuthService: AuthServiceProtocol {
    
    //MARK: - Properties
    
    static let shared = AuthService()
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    //MARK: - Init
    
    private init() {}
    
    //MARK: - Methods
    
    @MainActor
    func signInWithGoogle(presenting viewController: UIViewController) async throws {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw AuthError.clientIdNotFound
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: viewController)
        
        guard let idToken = result.user.idToken?.tokenString else {
            throw AuthError.idTokenMissing
        }
        let accessToken = result.user.accessToken.tokenString
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        let authResult = try await auth.signIn(with: credential)
        
        try await syncUserToFirestore(authResult.user, googleUser: result.user)
    }
    
    
    func logIn(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
    }
    
    func register(user: User, password: String) async throws {
        let authResult = try await auth.createUser(withEmail: user.email, password: password)
        
        try await createFirestoreUser(uid: authResult.user.uid, user: user)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func signOut() throws {
        try auth.signOut()
    }
    
    // MARK: - Methods
    
    private func syncUserToFirestore(_ firebaseUser: FirebaseAuth.User, googleUser: GIDGoogleUser) async throws {
        let userDoc = db.collection(FirestorePaths.users).document(firebaseUser.uid)
        let docSnapshot = try await userDoc.getDocument()
        
        if !docSnapshot.exists {
            let data: [String: Any] = [
                "fullname": googleUser.profile?.name ?? "",
                "username": googleUser.profile?.email.components(separatedBy: "@").first ?? "",
                "email": googleUser.profile?.email ?? "",
                "imageUrl": googleUser.profile?.imageURL(withDimension: 320)?.absoluteString ?? ""
            ]
            try await userDoc.setData(data)
        }
    }
    
    private func createFirestoreUser(uid: String, user: User) async throws {
        let data: [String: Any] = [
            "fullname" : user.fullname,
            "username": user.username,
            "email": user.email
        ]
        try await db.collection(FirestorePaths.users).document(uid).setData(data)
    }
}

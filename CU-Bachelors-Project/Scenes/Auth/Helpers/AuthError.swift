import Foundation

enum AuthError: Error {
    case clientIdNotFound
    case idTokenMissing
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .clientIdNotFound:
            return "Firebase client ID was not found. Ensure Firebase is configured correctly."
        case .idTokenMissing:
            return "Google Sign-In did not return a valid ID token. Please try again."
        }
    }
}

import Foundation

@MainActor
final class ForgotPasswordViewModel {
    
    // MARK: - Properties
    
    private let authService: AuthServiceProtocol
    
    var onLoading: ((Bool) -> Void)?
    var onSuccess: (() -> Void)?
    var onBack: (() -> Void)?
    var onValidationError: (([FieldError]) -> Void)?
    var onAuthenticationError: ((FieldError) -> Void)?
    
    // MARK: - Init
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    convenience init() {
        self.init(authService: AuthService.shared)
    }
    // MARK: - Methods
    
    func sendResetLink(email: String) async {
        let errors = validateFields(email: email)
        guard errors.isEmpty else {
            onValidationError?(errors)
            return
        }
        
        onLoading?(true)
        defer { onLoading?(false) }
        
        do {
            try await authService.resetPassword(email: email)
            onSuccess?()
        } catch {
            onAuthenticationError?(FieldError(
                field: .email,
                message: AuthErrorMessage.authFailed.message,
                type: .authentication
            ))
        }
    }
    
    private func validateFields(email: String) -> [FieldError] {
        var errors = [FieldError]()
        
        if email.isEmpty {
            errors.append(FieldError(field: .email, message: AuthErrorMessage.emptyEmail.message, type: .validation))
        } else if !Validators.isValidEmail(email) {
            errors.append(FieldError(field: .email, message: AuthErrorMessage.invalidEmail.message, type: .validation))
        }
        
        return errors
    }
    
    func backTapped() {
        onBack?()
    }
}

import FirebaseAuth

final class SignUpViewModel {
    
    //MARK: - Properties
    
    private let authService: AuthServiceProtocol
    
    var onLoginSuccess: (() -> Void)?
    var onLoading: ((Bool) -> Void)?
    var onBack: (() -> Void)?
    
    var onValidationError: (([FieldError]) -> Void)?
    var onAuthenticationError: ((FieldError) -> Void)?
    
    //MARK: - Init
    
    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
    }
    
    //MARK: - Methods
    
    func signUp(with user: User, password: String, confirmPassword: String) async {
        let errors = validateFields(for: user.fullname, user.email, password, confirmPassword)
        guard errors.isEmpty else {
            onValidationError?(errors)
            return
        }
        onLoading?(true)
        defer { onLoading?(false) }
        
        do {
            try await authService.register(user: user, password: password)
            onLoginSuccess?()
        } catch let error as NSError {
            let message: String
            if let authCode = AuthErrorCode(rawValue: error.code), authCode == .emailAlreadyInUse {
                message = AuthErrorMessage.usedEmail.message
            } else {
                message = AuthErrorMessage.networkError.message
            }
            onAuthenticationError?(FieldError(field: .email, message: message, type: .authentication))
        }
    }
    
    private func validateFields(for fullname: String, _ email: String, _ password: String, _ confirmPassword: String) -> [FieldError] {
        var errors = [FieldError]()

        if fullname.isEmpty {
            errors.append(FieldError(field: .fullname, message: AuthErrorMessage.emptyFullname.message, type: .validation))
        } else if !Validators.isValidFullname(fullname) {
            errors.append(FieldError(field: .fullname, message: AuthErrorMessage.invalidFullname.message, type: .validation))
        }

        if email.isEmpty {
            errors.append(FieldError(field: .email, message: AuthErrorMessage.emptyEmail.message, type: .validation))
        } else if !Validators.isValidEmail(email) {
            errors.append(FieldError(field: .email, message: AuthErrorMessage.invalidEmail.message, type: .validation))
        } else if !Validators.isStudentEmail(email) {
            errors.append(FieldError(field: .email, message: AuthErrorMessage.invalidStudentEmail.message, type: .validation))
        }
        
        if password.isEmpty {
            errors.append(FieldError(field: .password, message: AuthErrorMessage.emptyPassword.message, type: .validation))
        } else if !Validators.isValidPassword(password) {
            errors.append(FieldError(field: .password, message: AuthErrorMessage.invalidPassword.message, type: .validation))
        }
        
        if confirmPassword.isEmpty {
            errors.append(FieldError(field: .confirmPassword, message: AuthErrorMessage.emptyConfirmPassword.message, type: .validation))
        } else if !Validators.doPasswordsMatch(password, confirmPassword) {
            errors.append(FieldError(field: .confirmPassword, message: AuthErrorMessage.differentPasswords.message, type: .validation))
        }
        
        return errors
    }
    
    func backButtonTapped() {
        onBack?()
    }
}

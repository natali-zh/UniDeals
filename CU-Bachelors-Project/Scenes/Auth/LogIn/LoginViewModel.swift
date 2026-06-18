import UIKit
import FirebaseAuth
import GoogleSignIn

final class LoginViewModel {
    
    //MARK: - Properties
    
    private let authService: AuthServiceProtocol
    
    var onLoading: ((Bool) -> Void)?
    var onLoginSuccess: (() -> Void)?
    var onNavigateToSignUp: (() -> Void)?
    var onNavigateToForgotPassword: (() -> Void)?
    
    var onValidationError: (([FieldError]) -> Void)?
    var onAuthenticationError: ((FieldError) -> Void)?
    var onGoogleAuthError: ((String) -> Void)?
    
    //MARK: - Init
    
    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
    }
    
    //MARK: - Methods

    func googleSignInTapped(from viewController: UIViewController) async {
        onLoading?(true)
        defer { onLoading?(false) }
        
        do {
            try await authService.signInWithGoogle(presenting: viewController)
            
            let email = Auth.auth().currentUser?.email ?? ""
            
            guard Validators.isStudentEmail(email) else {
                onGoogleAuthError?("Please use your university email to sign in")
                try? authService.signOut()
                return
            }
            
            onLoginSuccess?()
        } catch {
        }
    }
    
    func logIn(email: String, password: String) async {
        let errors = validateFields(email: email, password: password)
        guard errors.isEmpty else {
            onValidationError?(errors)
            return
        }
        
        onLoading?(true)
        defer { onLoading?(false) }
        
        do {
            try await authService.logIn(email: email, password: password)
            onLoginSuccess?()
        }
        catch {
            onAuthenticationError?(FieldError(
                field: .password,
                message: AuthErrorMessage.authFailed.message,
                type: .authentication))
        }
    }
    
    private func validateFields(email: String, password: String) -> [FieldError] {
        var errors = [FieldError]()
        
        if email.isEmpty {
            errors.append(FieldError(field: .email, message: AuthErrorMessage.emptyEmail.message, type: .validation))
        } else if !Validators.isValidEmail(email) {
            errors.append(FieldError(field: .email, message: AuthErrorMessage.invalidEmail.message, type: .validation))
        }
        
        if password.isEmpty {
            errors.append(FieldError(field: .password, message: AuthErrorMessage.emptyPassword.message, type: .validation))
        }
        
        return errors
    }
    
    func signUpTapped() {
        onNavigateToSignUp?()
    }
    
    func forgotPasswordTapped() {
        onNavigateToForgotPassword?()
    }
}

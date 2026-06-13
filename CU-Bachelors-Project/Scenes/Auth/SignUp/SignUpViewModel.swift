//
//  SignUpViewModel.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 13.06.26.
//

import FirebaseAuth
import FirebaseFirestore

//@MainActor
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
        let errors = validateFields(for: user.fullname, user.username, user.email, password, confirmPassword)
        guard errors.isEmpty else {
            onValidationError?(errors)
            return
        }
        onLoading?(true)
        defer { onLoading?(false) }
        
        do {
            try await authService.register(user: user, password: password)
            onLoginSuccess?()
        } catch {
            let authError = FieldError(field: .email, message: AuthErrorMessage.usedEmail.message, type: .authentication)
            onAuthenticationError?(authError)
        }
    }
    
    private func validateFields(for fullname: String, _ username: String, _ email: String, _ password: String, _ confirmPassword: String) -> [FieldError] {
        var errors = [FieldError]()
        
        if fullname.isEmpty {
            errors.append(FieldError(field: .fullname, message: AuthErrorMessage.emptyFullname.message, type: .validation))
        } else if !Validators.isValidFullname(fullname) {
            errors.append(FieldError(field: .fullname, message: AuthErrorMessage.invalidFullname.message, type: .validation))
        }
        
        if username.isEmpty {
            errors.append(FieldError(field: .username, message: AuthErrorMessage.emptyUsername.message, type: .validation))
        } else if !Validators.isValidUsername(username) {
            errors.append(FieldError(field: .username, message: AuthErrorMessage.invalidUsername.message, type: .validation))
        }
        
        if email.isEmpty {
            errors.append(FieldError(field: .email, message: AuthErrorMessage.emptyEmail.message, type: .validation))
        } else if !Validators.isValidEmail(email) {
            errors.append(FieldError(field: .email, message: AuthErrorMessage.invalidEmail.message, type: .validation))
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

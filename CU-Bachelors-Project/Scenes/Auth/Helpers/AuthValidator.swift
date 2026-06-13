//
//  AuthValidator.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 13.06.26.
//

enum AuthErrorMessage {
    case emptyFullname
    case emptyUsername
    case emptyEmail
    case emptyPassword
    case emptyConfirmPassword
    
    case invalidFullname
    case invalidUsername
    case invalidEmail
    case invalidPassword
    case differentPasswords
    
    case authFailed
    case usedEmail
    
    var message: String {
        switch self {
        case .emptyFullname:
            return "Fullname is required"
        case .emptyUsername:
            return "Username is required"
        case .emptyEmail:
            return "Email is required"
        case .emptyPassword:
            return "Password is required"
        case .emptyConfirmPassword:
            return "Confirm password is required"
            
        case .invalidFullname:
            return "Only letters and spaces allowed"
        case .invalidUsername:
            return "Only letters, numbers, and underscores allowed"
        case .invalidEmail:
            return "Invalid email format"
        case .invalidPassword:
            return "Password must contain at least 8 characters"
            
        case .differentPasswords:
            return "Passwords don't match"
            
        case .authFailed:
            return "Incorrect email or password"
        case .usedEmail:
            return "This email is already registered"
        }
    }
}

enum FieldErrorType {
    case validation
    case authentication
}

struct FieldError {
    let field: AuthField
    let message: String
    let type: FieldErrorType
}

enum AuthField {
    case fullname
    case username
    case email
    case password
    case confirmPassword
}

//
//  Validators.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 13.06.26.
//

import UIKit

struct Validators {
    static func isValidFullname(_ fullname: String) -> Bool {
        let fullnameRegex = "^[A-Za-z ]+$"
        return NSPredicate(format: "SELF MATCHES %@", fullnameRegex)
            .evaluate(with: fullname)
    }
    
    static func isValidUsername(_ username: String) -> Bool {
        let usernameRegex = "^[A-Za-z0-9_]{3,}$"
        return NSPredicate(format: "SELF MATCHES %@", usernameRegex)
            .evaluate(with: username)
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    static func isStudentEmail(_ email: String) -> Bool {
        let lowercased = email.lowercased().trimmingCharacters(in: .whitespaces)
        guard let domain = lowercased.split(separator: "@").last else { return false }
        return domain.hasSuffix(".edu")
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        password.count >= 8
    }
    
    static func doPasswordsMatch(_ password: String, _ confirmPassword: String) -> Bool {
        password == confirmPassword
    }
}

import UIKit

struct Validators {
    static func isValidFullname(_ fullname: String) -> Bool {
        let fullnameRegex = "^[A-Za-z\u{10D0}-\u{10FF} ]+$"
        return NSPredicate(format: "SELF MATCHES %@", fullnameRegex)
            .evaluate(with: fullname)
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    static func isStudentEmail(_ email: String) -> Bool {
        let lowercased = email.lowercased().trimmingCharacters(in: .whitespaces)
        guard let domain = lowercased.split(separator: "@").last else { return false }
        return domain.components(separatedBy: ".").contains("edu")
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        password.count >= 8
    }
    
    static func doPasswordsMatch(_ password: String, _ confirmPassword: String) -> Bool {
        password == confirmPassword
    }
}

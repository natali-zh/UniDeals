enum AuthErrorMessage {
    case emptyFullname
    case emptyEmail
    case emptyPassword
    case emptyConfirmPassword

    case invalidFullname
    case invalidEmail
    case invalidStudentEmail
    case invalidPassword
    case differentPasswords

    case authFailed
    case usedEmail
    case networkError
    case googleSignInFailed
    case notStudentEmail

    var message: String {
        switch self {
        case .emptyFullname:
            return "სახელი სავალდებულოა"
        case .emptyEmail:
            return "ელფოსტა სავალდებულოა"
        case .emptyPassword:
            return "პაროლი სავალდებულოა"
        case .emptyConfirmPassword:
            return "გაიმეორეთ პაროლი"
        case .invalidFullname:
            return "გამოიყენეთ მხოლოდ ასოები და გამოტოვებები"
        case .invalidEmail:
            return "ელფოსტის ფორმატი არასწორია"
        case .invalidStudentEmail:
            return "გამოიყენე სტუდენტური ელფოსტა (.edu)"
        case .invalidPassword:
            return "პაროლი მინიმუმ 8 სიმბოლოს უნდა შეიცავდეს"
        case .differentPasswords:
            return "პაროლები არ ემთხვევა"
        case .authFailed:
            return "ელფოსტა ან პაროლი არასწორია"
        case .usedEmail:
            return "ეს ელფოსტა უკვე რეგისტრირებულია"
        case .networkError:
            return "შეამოწმე ინტერნეტ კავშირი და სცადე თავიდან"
        case .googleSignInFailed:
            return "Google-ით შესვლა ვერ მოხერხდა. სცადე თავიდან"
        case .notStudentEmail:
            return "გამოიყენე სტუდენტური ელფოსტა (.edu)"
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
    case email
    case password
    case confirmPassword
}

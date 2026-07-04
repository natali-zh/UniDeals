import Foundation
import UIKit

@MainActor
final class AuthCoordinator: Coordinator {
    
    //MARK: - Properties

    var navigationController: UINavigationController
    
    var onAuthenticationComplete: (() -> Void)?
    
    //MARK: - Init
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    //MARK: - Methods
    
    func start() {
        let logInViewModel = LoginViewModel()
        let loginViewController = LoginViewController(viewModel: logInViewModel)
        logInViewModel.onLoginSuccess = { [weak self] in
            self?.onAuthenticationComplete?()
        }
        logInViewModel.onNavigateToSignUp = { [weak self] in
            self?.goToSignUp()
        }
        logInViewModel.onNavigateToForgotPassword = { [weak self] in
            self?.goToForgotPassword()
        }
        navigationController.setViewControllers([loginViewController], animated: false)
    }
    
    func goToSignUp() {
        let signUpViewModel = SignUpViewModel()
        let signUpViewController = SignUpViewController(viewModel: signUpViewModel)
        signUpViewModel.onLoginSuccess = { [weak self] in
            self?.onAuthenticationComplete?()
        }
        signUpViewModel.onBack = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        navigationController.pushViewController(signUpViewController, animated: true)
    }
    
    func goToForgotPassword() {
        let forgotPasswordViewModel = ForgotPasswordViewModel()
        let forgotPasswordViewController = ForgotPasswordViewController(viewModel: forgotPasswordViewModel)
        forgotPasswordViewModel.onBack = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        navigationController.pushViewController(forgotPasswordViewController, animated: true)
    }
}

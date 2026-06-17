//
//  AppCoordinator.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 13.06.26.
//

import UIKit
import SwiftUI
import FirebaseAuth

final class AppCoordinator: Coordinator {
    
    //MARK: - Properties
    
    var window: UIWindow
    private var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    //MARK: - Init
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    //MARK: - Methods
    
    func start() {
        let initialFlow = SessionManager.shared.determineInitialFlow()
        navigate(to: initialFlow)
        window.makeKeyAndVisible()
    }
    
    private func navigate(to flow: AppFlow) {
        childCoordinators.removeAll()
        
        switch flow {
        case .auth:
            showAuth()
        case .main:
            Task { await showMainOrOnboarding() }
        }
    }
    
    private func showAuth(startingWithSignUp: Bool = false) {
        let authNav = UINavigationController()
        let authCoordinator = AuthCoordinator(navigationController: authNav)
        childCoordinators = [authCoordinator]
        authCoordinator.parentCoordinator = self
        
        authCoordinator.onAuthenticationComplete = { [weak self] in
            self?.navigate(to: .main)
        }
        authCoordinator.start()
        window.rootViewController = authCoordinator.navigationController
        
        if startingWithSignUp {
            authCoordinator.goToSignUp()
        }
    }
    
    private func showMainOrOnboarding() async {
        await UserManager.shared.fetchUser()
        let user = UserManager.shared.currentUser
        if user?.university == nil {
            showUniversityPicker()
        } else if user?.semester == nil {
            showGraduationYearPicker(university: user?.university ?? "")
        } else {
            showMainFlow()
        }
    }

    private func showUniversityPicker() {
        let vm = UniversityPickerViewModel()
        vm.onComplete = { [weak self] university in
            self?.showGraduationYearPicker(university: university)
        }
        let vc = UIHostingController(rootView: UniversityPickerView(viewModel: vm))
        window.rootViewController = vc
    }

    private func showGraduationYearPicker(university: String) {
        let vm = GraduationYearPickerViewModel(university: university)
        vm.onComplete = { [weak self] in
            self?.showMainFlow()
        }
        let vc = UIHostingController(rootView: GraduationYearPickerView(viewModel: vm))
        window.rootViewController = vc
    }

    private func showMainFlow() {
        let mainCoordinator = MainCoordinator()
        mainCoordinator.parentCoordinator = self
        childCoordinators = [mainCoordinator]
        mainCoordinator.start()
        window.rootViewController = mainCoordinator.rootViewController
    }
    
    func logOut() {
        SessionManager.shared.logout()
        navigate(to: .auth)
    }
}

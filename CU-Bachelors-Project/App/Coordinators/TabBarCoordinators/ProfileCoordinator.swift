//
//  ProfileCoordinator.swift
//  CU-Bachelors-Project
//

import UIKit
import SwiftUI

final class ProfileCoordinator: Coordinator {

    let navigationController: UINavigationController
    var onLogOut: (() -> Void)?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = ProfileViewModel()
        viewModel.onLogOut = { [weak self] in
            self?.onLogOut?()
        }
        viewModel.onSavedDiscounts = { [weak self] in
            self?.showSavedDiscounts()
        }
        viewModel.onEditUniversity = { [weak self] in
            self?.showUniversityPicker()
        }
        viewModel.onEditSemester = { [weak self] in
            self?.showSemesterPicker()
        }
        let vc = UIHostingController(rootView: ProfileView(viewModel: viewModel))
        navigationController.setViewControllers([vc], animated: false)
    }

    private func showSavedDiscounts() {
        // TODO: implement saved discounts screen
    }

    private func showUniversityPicker() {
        let vm = UniversityPickerViewModel()
        vm.onComplete = { [weak self] university in
            self?.navigationController.popViewController(animated: true)
            self?.showSemesterPicker(university: university)
        }
        let vc = UIHostingController(rootView: UniversityPickerView(viewModel: vm))
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }

    private func showSemesterPicker(university: String? = nil) {
        let uni = university ?? UserManager.shared.currentUser?.university ?? ""
        let vm = GraduationYearPickerViewModel(university: uni)
        vm.onComplete = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        let vc = UIHostingController(rootView: GraduationYearPickerView(viewModel: vm))
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
}

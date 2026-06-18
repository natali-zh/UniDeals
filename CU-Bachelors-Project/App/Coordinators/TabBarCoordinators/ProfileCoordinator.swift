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
        let vm = SavedDiscountsViewModel()
        vm.onDiscountTap = { [weak self] discount in
            self?.showDiscountDetail(discount: discount)
        }
        let vc = UIHostingController(rootView: SavedDiscountsView(viewModel: vm))
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }

    private func showDiscountDetail(discount: Discount) {
        let detailVM = DiscountDetailViewModel(discount: discount)
        detailVM.onBack = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        let vc = UIHostingController(rootView: DiscountDetailView(viewModel: detailVM))
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
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

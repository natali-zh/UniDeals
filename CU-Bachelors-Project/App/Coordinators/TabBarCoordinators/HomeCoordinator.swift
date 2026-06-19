import UIKit
import SwiftUI

final class HomeCoordinator: Coordinator {

    // MARK: - Properties

    let navigationController: UINavigationController
    var onSeeAll: (() -> Void)?
    var onShowOnMap: ((Discount) -> Void)?
    var onLogOut: (() -> Void)?

    // MARK: - Init

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Start

    func start() {
        let viewModel = HomeViewModel(discountService: DiscountService.shared)
        viewModel.onDiscountTapped = { [weak self] id in
            self?.showDiscountDetail(id: id)
        }
        viewModel.onSeeAllFeatured = { [weak self] in self?.onSeeAll?() }
        viewModel.onSeeAllNearby   = { [weak self] in self?.onSeeAll?() }
        viewModel.onSeeAllExpiring = { [weak self] in self?.onSeeAll?() }
        viewModel.onSettingsTapped = { [weak self] in self?.showSettings() }
        let view = HomeView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        navigationController.setViewControllers([vc], animated: false)
    }

    private func showSettings() {
        let vm = ProfileViewModel()
        vm.onLogOut = { [weak self] in
            self?.onLogOut?()
        }
        vm.onEditUniversity = { [weak self] in self?.showUniversityPicker() }
        vm.onEditSemester = { [weak self] in self?.showSemesterPicker() }
        let vc = UIHostingController(rootView: ProfileView(viewModel: vm))
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

    // MARK: - Navigation

    private func showPartnerDetail(id: String) {
        Task { @MainActor in
            guard let partner = try? await PartnerService.shared.fetchPartner(id: id) else { return }
            let detailVM = PartnerDetailViewModel(partner: partner)
            detailVM.onBack = { [weak self] in
                self?.navigationController.popViewController(animated: true)
            }
            detailVM.onViewOnMap = { [weak self] discount in
                self?.navigationController.popViewController(animated: false)
                self?.onShowOnMap?(discount)
            }
            detailVM.onOfferTapped = { [weak self] discountId in
                self?.showDiscountDetail(id: discountId)
            }
            let vc = UIHostingController(rootView: PartnerDetailView(viewModel: detailVM))
            vc.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(vc, animated: true)
        }
    }

    private func showDiscountDetail(id: String) {
        Task { @MainActor in
            guard let discount = try? await DiscountService.shared.fetchDiscount(id: id) else { return }
            let detailVM = DiscountDetailViewModel(discount: discount)
            detailVM.onBack = { [weak self] in
                self?.navigationController.popViewController(animated: true)
            }
            detailVM.onViewOnMap = { [weak self] discount in
                self?.navigationController.popViewController(animated: false)
                self?.onShowOnMap?(discount)
            }
            detailVM.onPartnerTapped = { [weak self] partnerId in
                self?.showPartnerDetail(id: partnerId)
            }
            let detailView = DiscountDetailView(viewModel: detailVM)
            let vc = UIHostingController(rootView: detailView)
            vc.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(vc, animated: true)
        }
    }
}

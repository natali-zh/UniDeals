import UIKit
import SwiftUI

@MainActor
final class SavedDiscountsCoordinator: Coordinator {

    // MARK: - Properties

    let navigationController: UINavigationController
    private var isNavigating = false

    // MARK: - Init

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        (navigationController as? SwipeableNavigationController)?.onDidShow = { [weak self] in
            self?.isNavigating = false
        }
    }

    // MARK: - Start

    func start() {
        let vm = SavedDiscountsViewModel()
        vm.onDiscountTapped = { [weak self] discount in self?.showDiscountDetail(discount: discount) }
        let vc = UIHostingController(rootView: SavedDiscountsView(viewModel: vm))
        navigationController.setViewControllers([vc], animated: false)
    }

    // MARK: - Navigation

    private func showDiscountDetail(discount: Discount) {
        guard !isNavigating else { return }
        isNavigating = true
        let detailVM = DiscountDetailViewModel(discount: discount)
        detailVM.onBack = { [weak self] in self?.navigationController.popViewController(animated: true) }
        detailVM.onPartnerTapped = { [weak self] partnerId in self?.showPartnerDetail(id: partnerId) }
        let vc = UIHostingController(rootView: DiscountDetailView(viewModel: detailVM))
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }

    private func showPartnerDetail(id: String) {
        guard !isNavigating else { return }
        isNavigating = true
        Task {
            guard let partner = try? await PartnerService.shared.fetchPartner(id: id) else {
                isNavigating = false
                return
            }
            let detailVM = PartnerDetailViewModel(partner: partner)
            detailVM.onBack = { [weak self] in self?.navigationController.popViewController(animated: true) }
            detailVM.onOfferTapped = { [weak self] discountId in
                Task {
                    guard let discount = try? await DiscountService.shared.fetchDiscount(id: discountId) else { return }
                    self?.showDiscountDetail(discount: discount)
                }
            }
            let vc = UIHostingController(rootView: PartnerDetailView(viewModel: detailVM))
            vc.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(vc, animated: true)
        }
    }
}


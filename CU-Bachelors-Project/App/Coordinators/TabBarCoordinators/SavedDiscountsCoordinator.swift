import UIKit
import SwiftUI

final class SavedDiscountsCoordinator: Coordinator {

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vm = SavedDiscountsViewModel()
        vm.onDiscountTapped = { [weak self] discount in
            self?.showDiscountDetail(discount: discount)
        }
        let vc = UIHostingController(rootView: SavedDiscountsView(viewModel: vm))
        navigationController.setViewControllers([vc], animated: false)
    }

    private func showPartnerDetail(id: String) {
        Task { @MainActor in
            guard let partner = try? await PartnerService.shared.fetchPartner(id: id) else { return }
            let detailVM = PartnerDetailViewModel(partner: partner)
            detailVM.onBack = { [weak self] in
                self?.navigationController.popViewController(animated: true)
            }
            detailVM.onOfferTapped = { [weak self] discountId in
                Task { @MainActor in
                    guard let discount = try? await DiscountService.shared.fetchDiscount(id: discountId) else { return }
                    self?.showDiscountDetail(discount: discount)
                }
            }
            let vc = UIHostingController(rootView: PartnerDetailView(viewModel: detailVM))
            vc.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(vc, animated: true)
        }
    }

    private func showDiscountDetail(discount: Discount) {
        let detailVM = DiscountDetailViewModel(discount: discount)
        detailVM.onBack = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        detailVM.onPartnerTapped = { [weak self] partnerId in
            self?.showPartnerDetail(id: partnerId)
        }
        let vc = UIHostingController(rootView: DiscountDetailView(viewModel: detailVM))
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
}

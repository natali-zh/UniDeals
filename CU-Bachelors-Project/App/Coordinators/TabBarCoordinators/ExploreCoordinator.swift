import UIKit
import SwiftUI

final class ExploreCoordinator: Coordinator {

    // MARK: - Properties

    let navigationController: UINavigationController
    var onShowOnMap: ((Discount) -> Void)?

    // MARK: - Init

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Start

    func start() {
        let viewModel = ExploreViewModel()
        viewModel.onDiscountTapped = { [weak self] id in
            self?.showDiscountDetail(id: id)
        }
        viewModel.onPartnerTapped = { [weak self] id in
            self?.showPartnerDetail(id: id)
        }
        let view = ExploreView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        navigationController.setViewControllers([vc], animated: false)
    }

    // MARK: - Navigation

    private func showDiscountDetail(id: String) {
        Task { @MainActor in
            guard let discount = try? await DiscountService.shared.fetchDiscount(id: id) else { return }
            pushDiscountDetail(discount: discount)
        }
    }

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
                self?.showDiscountDetailFromPartner(id: discountId)
            }
            let detailView = PartnerDetailView(viewModel: detailVM)
            let vc = UIHostingController(rootView: detailView)
            vc.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(vc, animated: true)
        }
    }

    private func showDiscountDetailFromPartner(id: String) {
        Task { @MainActor in
            guard let discount = try? await DiscountService.shared.fetchDiscount(id: id) else { return }
            pushDiscountDetail(discount: discount)
        }
    }

    private func pushDiscountDetail(discount: Discount) {
        let detailVM = DiscountDetailViewModel(discount: discount)
        detailVM.onBack = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        detailVM.onViewOnMap = { [weak self] discount in
            self?.navigationController.popViewController(animated: false)
            self?.onShowOnMap?(discount)
        }
        let detailView = DiscountDetailView(viewModel: detailVM)
        let vc = UIHostingController(rootView: detailView)
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
}

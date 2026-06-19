import UIKit
import SwiftUI

final class MapCoordinator: Coordinator {

    let navigationController: UINavigationController
    private var mapViewModel: MapViewModel?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = MapViewModel()
        viewModel.onViewOffer = { [weak self] discount in
            self?.showDiscountDetail(discount: discount)
        }
        self.mapViewModel = viewModel
        let vc = UIHostingController(rootView: MapView(viewModel: viewModel))
        navigationController.setViewControllers([vc], animated: false)
    }

    func show(discount: Discount) {
        navigationController.popToRootViewController(animated: false)
        Task { @MainActor in
            if mapViewModel?.discounts.isEmpty == true {
                await mapViewModel?.load()
            }
            if let match = mapViewModel?.discounts.first(where: { $0.id == discount.id }) {
                mapViewModel?.show(discount: match)
            } else {
                mapViewModel?.show(discount: discount)
            }
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
                self?.show(discount: discount)
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
        detailVM.onViewOnMap = { [weak self] discount in
            self?.navigationController.popViewController(animated: false)
            self?.show(discount: discount)
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

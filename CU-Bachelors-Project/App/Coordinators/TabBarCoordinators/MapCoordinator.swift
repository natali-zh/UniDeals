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

    private func showDiscountDetail(discount: Discount) {
        let detailVM = DiscountDetailViewModel(discount: discount)
        detailVM.onBack = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        detailVM.onViewOnMap = { [weak self] discount in
            self?.navigationController.popViewController(animated: false)
            self?.show(discount: discount)
        }
        let detailView = DiscountDetailView(viewModel: detailVM)
        let vc = UIHostingController(rootView: detailView)
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
}

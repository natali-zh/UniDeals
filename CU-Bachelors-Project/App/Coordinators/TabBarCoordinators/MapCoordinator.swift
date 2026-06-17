//
//  MapCoordinator.swift
//  CU-Bachelors-Project
//

import UIKit
import SwiftUI

final class MapCoordinator: Coordinator {

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = MapViewModel()
        viewModel.onViewOffer = { [weak self] discount in
            self?.showDiscountDetail(discount: discount)
        }
        let vc = UIHostingController(rootView: MapView(viewModel: viewModel))
        navigationController.setViewControllers([vc], animated: false)
    }

    private func showDiscountDetail(discount: Discount) {
        let detailVM = DiscountDetailViewModel(discount: discount)
        detailVM.onBack = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        let detailView = DiscountDetailView(viewModel: detailVM)
        let vc = UIHostingController(rootView: detailView)
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
}

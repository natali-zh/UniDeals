//
//  HomeCoordinator.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 17.06.26.
//

import UIKit
import SwiftUI

final class HomeCoordinator: Coordinator {

    // MARK: - Properties

    let navigationController: UINavigationController

    // MARK: - Init

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Start

    func start() {
        let viewModel = HomeViewModel()
        viewModel.onDiscountTapped = { [weak self] id in
            self?.showDiscountDetail(id: id)
        }
        let view = HomeView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        navigationController.setViewControllers([vc], animated: false)
    }

    // MARK: - Navigation

    private func showDiscountDetail(id: String) {
        Task { @MainActor in
            guard let discount = try? await DiscountService.shared.fetchDiscount(id: id) else { return }
            let detailVM = DiscountDetailViewModel(discount: discount)
            detailVM.onBack = { [weak self] in
                self?.navigationController.popViewController(animated: true)
            }
            detailVM.onToggleSave = { _ in /* TODO: persist */ }
            let detailView = DiscountDetailView(viewModel: detailVM)
            let vc = UIHostingController(rootView: detailView)
            vc.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(vc, animated: true)
        }
    }
}

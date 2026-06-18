import UIKit
import SwiftUI

final class SavedDiscountsCoordinator: Coordinator {

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vm = SavedDiscountsViewModel()
        vm.onDiscountTap = { [weak self] discount in
            self?.showDiscountDetail(discount: discount)
        }
        let vc = UIHostingController(rootView: SavedDiscountsView(viewModel: vm))
        navigationController.setViewControllers([vc], animated: false)
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
}

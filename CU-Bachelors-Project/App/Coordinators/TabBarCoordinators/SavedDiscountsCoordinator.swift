import UIKit
import SwiftUI

@MainActor
final class SavedDiscountsCoordinator: Coordinator {
    
    // MARK: - Properties

    let navigationController: UINavigationController
    var onShowOnMap: ((Discount) -> Void)?
    private var isNavigating = false
    
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        (navigationController as? SwipeableNavigationController)?.onDidShow = { [weak self] in
            self?.isNavigating = false
        }
    }
    
    // MARK: - Methods
    
    func start() {
        let vm = SavedDiscountsViewModel()
        vm.onDiscountTapped = { [weak self] discount in self?.showDiscountDetail(discount: discount) }
        let vc = UIHostingController(rootView: SavedDiscountsView(viewModel: vm))
        navigationController.setViewControllers([vc], animated: false)
    }
    
    private func showDiscountDetail(id: String) {
        guard !isNavigating else { return }
        isNavigating = true
        Task {
            guard let discount = try? await DiscountService.shared.fetchDiscount(id: id) else {
                isNavigating = false
                return
            }
            pushDiscountDetail(discount: discount)
        }
    }
    
    private func showDiscountDetail(discount: Discount) {
        guard !isNavigating else { return }
        isNavigating = true
        pushDiscountDetail(discount: discount)
    }
    
    private func pushDiscountDetail(discount: Discount) {
        let detailVM = DiscountDetailViewModel(discount: discount)
        detailVM.onBack = { [weak self] in self?.navigationController.popViewController(animated: true) }
        detailVM.onViewOnMap = { [weak self] discount in
            self?.navigationController.popViewController(animated: false)
            self?.onShowOnMap?(discount)
        }
        detailVM.onPartnerTapped = { [weak self] id in self?.showPartnerDetail(id: id) }
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
            detailVM.onViewOnMap = { [weak self] discount in
                self?.navigationController.popViewController(animated: false)
                self?.onShowOnMap?(discount)
            }
            detailVM.onOfferTapped = { [weak self] id in self?.showDiscountDetail(id: id) }
            let vc = UIHostingController(rootView: PartnerDetailView(viewModel: detailVM))
            vc.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(vc, animated: true)
        }
    }
}


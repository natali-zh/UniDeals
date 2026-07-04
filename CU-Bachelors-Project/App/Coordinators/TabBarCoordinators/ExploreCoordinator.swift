import UIKit
import SwiftUI

@MainActor
final class ExploreCoordinator: Coordinator {
    
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
        let viewModel = ExploreViewModel()
        viewModel.onDiscountTapped = { [weak self] id in self?.showDiscountDetail(id: id) }
        viewModel.onPartnerTapped = { [weak self] id in self?.showPartnerDetail(id: id) }
        let vc = UIHostingController(rootView: ExploreView(viewModel: viewModel))
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
            detailVM.onOfferTapped = { [weak self] discountId in self?.showDiscountDetail(id: discountId) }
            let vc = UIHostingController(rootView: PartnerDetailView(viewModel: detailVM))
            vc.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    private func pushDiscountDetail(discount: Discount) {
        let detailVM = DiscountDetailViewModel(discount: discount)
        detailVM.onBack = { [weak self] in self?.navigationController.popViewController(animated: true) }
        detailVM.onViewOnMap = { [weak self] discount in
            self?.navigationController.popViewController(animated: false)
            self?.onShowOnMap?(discount)
        }
        detailVM.onPartnerTapped = { [weak self] partnerId in self?.showPartnerDetail(id: partnerId) }
        let vc = UIHostingController(rootView: DiscountDetailView(viewModel: detailVM))
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
}


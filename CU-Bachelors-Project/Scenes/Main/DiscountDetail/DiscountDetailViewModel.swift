//
//  DiscountDetailViewModel.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 17.06.26.
//

import Foundation
import Combine

@MainActor
final class DiscountDetailViewModel: ObservableObject {

    // MARK: - Dependencies

    private let partnerService: PartnerServiceProtocol

    // MARK: - Published

    let discount: Discount
    @Published var partner: Partner?
    @Published var isSaved: Bool

    // MARK: - Navigation callbacks

    var onBack: (() -> Void)?
    var onViewOnMap: ((Discount) -> Void)?
    var onUseOffer: (() -> Void)?
    var onToggleSave: ((String) -> Void)?

    // MARK: - Init

    init(
        discount: Discount,
        partnerService: PartnerServiceProtocol = PartnerService.shared
    ) {
        self.discount = discount
        self.isSaved = discount.isSaved
        self.partnerService = partnerService
    }

    // MARK: - Methods

    func loadPartner() async {
        async let partnerFetch = partnerService.fetchPartner(id: discount.storeId)
        async let savedFetch: [String] = {
            guard let uid = await SessionManager.shared.userId else { return [] }
            return (try? await SavedDiscountsService.shared.fetchSavedIds(uid: uid)) ?? []
        }()

        partner = try? await partnerFetch
        let savedIds = await savedFetch
        if let id = discount.id {
            isSaved = savedIds.contains(id)
        }
    }

    func toggleSave() {
        guard let id = discount.id, let uid = SessionManager.shared.userId else { return }
        isSaved.toggle()
        onToggleSave?(id)
        Task {
            if isSaved {
                try? await SavedDiscountsService.shared.save(discountId: id, uid: uid)
            } else {
                try? await SavedDiscountsService.shared.unsave(discountId: id, uid: uid)
            }
        }
    }

    // MARK: - Computed display helpers

    var daysLeftText: String { DiscountFormatter.daysLeftText(for: discount.endDate) }
    var daysLeftIsUrgent: Bool { DiscountFormatter.isUrgent(endDate: discount.endDate) }
    var isExpired: Bool { DiscountFormatter.isExpired(endDate: discount.endDate) }
    var formattedEndDate: String { DiscountFormatter.formattedDate(discount.endDate) }
    var distanceText: String { DiscountFormatter.distanceText(discount.distanceKm) }
}

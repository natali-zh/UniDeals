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
    var onViewOnMap: (() -> Void)?
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
        guard !discount.storeId.isEmpty else { return }
        partner = try? await partnerService.fetchPartner(id: discount.storeId)
    }

    func toggleSave() {
        isSaved.toggle()
        onToggleSave?(discount.id ?? "")
    }

    // MARK: - Computed display helpers

    var daysLeftText: String { DiscountFormatter.daysLeftText(for: discount.endDate) }
    var daysLeftIsUrgent: Bool { DiscountFormatter.isUrgent(endDate: discount.endDate) }
    var isExpired: Bool { DiscountFormatter.isExpired(endDate: discount.endDate) }
    var formattedEndDate: String { DiscountFormatter.formattedDate(discount.endDate) }
    var distanceText: String { DiscountFormatter.distanceText(discount.distanceKm) }
}

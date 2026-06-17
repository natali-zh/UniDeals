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

    var daysLeftText: String {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: discount.endDate).day ?? 0
        if days < 0 { return "ვადა გასულია" }
        if days == 0 { return "დღეს იწურება" }
        return "\(days) დღე დარჩა"
    }

    var daysLeftIsUrgent: Bool {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: discount.endDate).day ?? 0
        return days <= 3
    }

    var isExpired: Bool {
        discount.endDate < Date()
    }

    var formattedEndDate: String {
        let f = DateFormatter()
        f.dateFormat = "d MMMM, yyyy"
        f.locale = Locale(identifier: "ka_GE")
        return f.string(from: discount.endDate)
    }

    var distanceText: String {
        String(format: "%.1f კმ", discount.distanceKm)
    }
}

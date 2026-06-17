//
//  PartnerDetailViewModel.swift
//  CU-Bachelors-Project
//

import Foundation
import Combine

@MainActor
final class PartnerDetailViewModel: ObservableObject {

    // MARK: - Dependencies

    private let discountService: DiscountServiceProtocol

    // MARK: - Published

    let partner: Partner
    @Published var offers: [Discount] = []
    @Published var isLoading = false
    @Published var isSaved: Bool = false

    // MARK: - Navigation callbacks

    var onBack: (() -> Void)?
    var onViewOnMap: (() -> Void)?
    var onOfferTapped: ((String) -> Void)?

    // MARK: - Init

    init(
        partner: Partner,
        discountService: DiscountServiceProtocol = DiscountService.shared
    ) {
        self.partner = partner
        self.discountService = discountService
    }

    // MARK: - Methods

    func loadOffers() async {
        isLoading = true
        let all = (try? await discountService.fetchAllDiscounts()) ?? []
        let pid = partner.id ?? ""
        let pname = partner.name.lowercased()
        offers = all.filter {
            $0.storeId == pid || $0.storeName.lowercased() == pname
        }
        isLoading = false
    }

    func toggleSave() {
        isSaved.toggle()
    }
}

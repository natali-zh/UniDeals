//
//  MapViewModel.swift
//  CU-Bachelors-Project
//

import Foundation

@MainActor
@Observable
final class MapViewModel {

    var discounts: [Discount] = []
    var selectedDiscount: Discount? = nil
    var isLoading = false

    var onViewOffer: ((Discount) -> Void)?

    func load() async {
        isLoading = true
        discounts = (try? await DiscountService.shared.fetchAllDiscounts()) ?? []
        isLoading = false
    }

    func select(discount: Discount) {
        selectedDiscount = discount
    }

    func clearSelection() {
        selectedDiscount = nil
    }
}

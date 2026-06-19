import Foundation

@MainActor
@Observable
final class MapViewModel {

    var discounts: [Discount] = []
    var selectedDiscount: Discount? = nil
    var selectedCategoryId: String = "all"
    var isLoading = false

    var onViewOffer: ((Discount) -> Void)?
    var pendingDiscount: Discount? = nil

    let categories: [DiscountCategory] = AppCategories.allWithAll

    var filteredDiscounts: [Discount] {
        selectedCategoryId == "all"
            ? discounts
            : discounts.filter { $0.category == selectedCategoryId }
    }

    func load() async {
        isLoading = true
        discounts = DiscountFormatter.withDistances((try? await DiscountService.shared.fetchAllDiscounts()) ?? [])
        isLoading = false
    }

    func select(discount: Discount) {
        selectedDiscount = discount
    }

    func clearSelection() {
        selectedDiscount = nil
    }

    func selectCategory(_ id: String) {
        selectedCategoryId = id
        clearSelection()
    }

    func show(discount: Discount) {
        pendingDiscount = discount
        selectedDiscount = discount
        // auto-switch category to match the incoming discount
        if selectedCategoryId != "all" {
            selectedCategoryId = "all"
        }
    }
}

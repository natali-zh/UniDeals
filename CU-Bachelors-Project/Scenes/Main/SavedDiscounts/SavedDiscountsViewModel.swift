import Foundation

@MainActor
@Observable
final class SavedDiscountsViewModel {

    var discounts: [Discount] = []
    var isLoading = false

    var onDiscountTap: ((Discount) -> Void)?

    func load() async {
        guard let uid = SessionManager.shared.userId else { return }
        isLoading = true
        discounts = (try? await SavedDiscountsService.shared.fetchSavedDiscounts(uid: uid)) ?? []
        isLoading = false
    }

    func toggleSave(_ id: String) {
        guard !id.isEmpty, let uid = SessionManager.shared.userId else { return }
        if let index = discounts.firstIndex(where: { $0.id == id }) {
            discounts[index].isSaved.toggle()
            let nowSaved = discounts[index].isSaved
            if !nowSaved {
                discounts.remove(at: index)
            }
            Task {
                if nowSaved {
                    try? await SavedDiscountsService.shared.save(discountId: id, uid: uid)
                } else {
                    try? await SavedDiscountsService.shared.unsave(discountId: id, uid: uid)
                }
            }
        }
    }
}

import Combine
import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    
    // MARK: - Dependencies
    
    private let discountService: DiscountServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Published
    
    @Published private var discounts: [Discount] = []
    @Published var isLoading: Bool = false
    
    // MARK: - Computed
    
    var featured: [Discount] {
        discounts.filter { $0.isFeatured }
    }
    
    var nearby: [Discount] {
        Array(discounts.prefix(5))
    }
    
    var expiring: [Discount] {
        let threeDaysFromNow = Date().addingTimeInterval(3 * 24 * 60 * 60)
        return discounts.filter { $0.endDate <= threeDaysFromNow && $0.endDate >= Date() }
    }
    
    var userName: String {
        UserManager.shared.currentUser?.fullname.components(separatedBy: " ").first ?? "სტუდენტო"
    }
    
    var userImageUrl: String? {
        UserManager.shared.currentUser?.imageUrl
    }
    
    // MARK: - Navigation callbacks
    
    var onSeeAllFeatured: (() -> Void)?
    var onSeeAllNearby: (() -> Void)?
    var onSeeAllExpiring: (() -> Void)?
    var onDiscountTapped: ((String) -> Void)?
    var onSettingsTapped: (() -> Void)?
    
    // MARK: - Init
    
    init(discountService: DiscountServiceProtocol = DiscountService.shared) {
        self.discountService = discountService
        UserManager.shared.$currentUser
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }
    
    // MARK: - Methods
    
    func loadDiscounts(forceReload: Bool = false) async {
        guard discounts.isEmpty || forceReload else { return }
        if forceReload { discounts = [] }
        isLoading = true
        defer { isLoading = false }
        
        do {
            var loaded = DiscountFormatter.withDistances(try await discountService.fetchAllDiscounts())
            if let uid = SessionManager.shared.userId,
               let savedIds = try? await SavedDiscountsService.shared.fetchSavedIds(uid: uid) {
                for i in loaded.indices where savedIds.contains(loaded[i].id ?? "") {
                    loaded[i].isSaved = true
                }
            }
            discounts = loaded
        } catch {
        }
    }
    
    func refreshDistances() {
        guard !discounts.isEmpty else { return }
        discounts = DiscountFormatter.withDistances(discounts)
    }
    
    func refreshSavedState() async {
        guard !discounts.isEmpty, let uid = SessionManager.shared.userId,
              let savedIds = try? await SavedDiscountsService.shared.fetchSavedIds(uid: uid) else { return }
        for i in discounts.indices {
            discounts[i].isSaved = savedIds.contains(discounts[i].id ?? "")
        }
    }
    
    func toggleSave(_ id: String) {
        guard !id.isEmpty,
              let index = discounts.firstIndex(where: { $0.id == id }),
              let uid = SessionManager.shared.userId else { return }
        discounts[index].isSaved.toggle()
        let nowSaved = discounts[index].isSaved
        Task {
            if nowSaved {
                try? await SavedDiscountsService.shared.save(discountId: id, uid: uid)
            } else {
                try? await SavedDiscountsService.shared.unsave(discountId: id, uid: uid)
            }
        }
    }
}

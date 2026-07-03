import Combine
import Foundation

@MainActor
final class ExploreViewModel: ObservableObject {

    // MARK: - Dependencies

    private let discountService: DiscountServiceProtocol
    private let partnerService: PartnerServiceProtocol

    // MARK: - Published

    @Published var searchQuery: String = ""
    @Published var selectedTab: ExploreTab = .discounts
    @Published var selectedCategoryIds: Set<String> = []
    @Published var activeFilter = DiscountFilter()
    @Published var isLoading: Bool = false

    @Published private var discounts: [Discount] = []
    @Published private var partners: [Partner] = []

    // MARK: - Navigation callbacks

    var onDiscountTapped: ((String) -> Void)?
    var onPartnerTapped: ((String) -> Void)?

    // MARK: - Computed

    let categories: [DiscountCategory] = AppCategories.all

    var hasActiveFilters: Bool {
        activeFilter.isActive || !selectedCategoryIds.isEmpty
    }

    var filteredDiscounts: [Discount] {
        var result = discounts

        if !selectedCategoryIds.isEmpty {
            result = result.filter { selectedCategoryIds.contains($0.category) }
        }

        if !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty {
            let q = searchQuery.lowercased()
            result = result.filter {
                $0.title.lowercased().contains(q) || $0.storeName.lowercased().contains(q)
            }
        }

        if activeFilter.discountType != .all {
            result = result.filter { $0.discountType == activeFilter.discountType.firestoreValue }
        }

        switch activeFilter.sortBy {
        case .expiringSoon: result.sort { $0.endDate < $1.endDate }
        case .newest:       result.sort { $0.startDate > $1.startDate }
        case .nearest:      result.sort { $0.distanceKm < $1.distanceKm }
        case nil:           break
        }

        return result
    }

    var filteredPartners: [Partner] {
        var result = partners

        if !selectedCategoryIds.isEmpty {
            result = result.filter { selectedCategoryIds.contains($0.category) }
        }

        if !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty {
            let q = searchQuery.lowercased()
            result = result.filter {
                $0.name.lowercased().contains(q) || $0.category.lowercased().contains(q)
            }
        }

        if activeFilter.sortBy == .nearest {
            result.sort { offerCount(for: $0) > offerCount(for: $1) }
        }

        return result
    }

    // MARK: - Init

    init(discountService: DiscountServiceProtocol, partnerService: PartnerServiceProtocol) {
        self.discountService = discountService
        self.partnerService = partnerService
    }

    convenience init() {
        self.init(discountService: DiscountService.shared, partnerService: PartnerService.shared)
    }

    // MARK: - Methods

    func loadData(forceReload: Bool = false) async {
        guard discounts.isEmpty || forceReload else { return }
        if forceReload { discounts = [] }
        isLoading = true
        defer { isLoading = false }

        do {
            async let fetchedDiscounts = discountService.fetchAllDiscounts()
            async let fetchedPartners = partnerService.fetchAllPartners()
            var loaded = DiscountFormatter.withDistances(try await fetchedDiscounts)
            if let uid = SessionManager.shared.userId,
               let savedIds = try? await SavedDiscountsService.shared.fetchSavedIds(uid: uid) {
                for i in loaded.indices where savedIds.contains(loaded[i].id ?? "") {
                    loaded[i].isSaved = true
                }
            }
            discounts = loaded
            partners = try await fetchedPartners
        } catch {
            // silent — empty state shown in UI
        }
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

    func offerCount(for partner: Partner) -> Int {
        guard let pid = partner.id else { return 0 }
        return discounts.filter { $0.storeId == pid }.count
    }

    func toggleCategory(_ id: String) {
        if selectedCategoryIds.contains(id) {
            selectedCategoryIds.remove(id)
        } else {
            selectedCategoryIds.insert(id)
        }
    }

    func clearCategories() {
        selectedCategoryIds = []
    }
}

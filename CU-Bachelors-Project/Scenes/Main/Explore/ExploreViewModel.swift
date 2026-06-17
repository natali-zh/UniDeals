//
//  ExploreViewModel.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 17.06.26.
//

import Combine
import Foundation

enum ExploreTab {
    case discounts, partners
}

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
    @Published var errorMessage: String?

    private var discounts: [Discount] = []
    private var partners: [Partner] = []

    // MARK: - Computed

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
        case .expiringSoon:
            result.sort { $0.endDate < $1.endDate }
        case .newest:
            result.sort { $0.startDate > $1.startDate }
        case .nearest:
            result.sort { $0.distanceKm < $1.distanceKm }
        case nil:
            break
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

    let categories: [DiscountCategory] = [
        DiscountCategory(id: "food",    name: "საკვები", icon: "fork.knife"),
        DiscountCategory(id: "tech",    name: "ტექნიკა", icon: "laptopcomputer"),
        DiscountCategory(id: "fashion", name: "მოდა",    icon: "tshirt.fill"),
        DiscountCategory(id: "fitness", name: "ფიტნესი", icon: "heart.fill"),
        DiscountCategory(id: "books",   name: "წიგნები", icon: "book.fill"),
    ]

    // MARK: - Navigation callbacks

    var onDiscountTapped: ((String) -> Void)?
    var onPartnerTapped: ((String) -> Void)?

    // MARK: - Init

    init(
        discountService: DiscountServiceProtocol = DiscountService.shared,
        partnerService: PartnerServiceProtocol = PartnerService.shared
    ) {
        self.discountService = discountService
        self.partnerService = partnerService
    }

    // MARK: - Methods

    func loadData() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            async let fetchedDiscounts = discountService.fetchAllDiscounts()
            async let fetchedPartners = partnerService.fetchAllPartners()
            discounts = try await fetchedDiscounts
            partners = try await fetchedPartners
        } catch {
            errorMessage = "მონაცემების ჩატვირთვა ვერ მოხდა."
            print("ExploreViewModel loadData failed: \(error.localizedDescription)")
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

//    func applyFilter(_ filter: DiscountFilter) {
//        activeFilter = filter
//    }
//
//    func resetFilter() {
//        activeFilter = DiscountFilter()
//    }
}

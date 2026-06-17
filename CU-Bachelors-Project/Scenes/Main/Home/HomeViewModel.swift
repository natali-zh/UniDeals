//
//  HomeViewModel.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 17.06.26.
//

import Combine
import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    
    // MARK: - Dependencies
    
    private let discountService: DiscountServiceProtocol
    
    // MARK: - Published Properties
    
    @Published private var discounts: [Discount] = []
    @Published var categories: [DiscountCategory] = []
    @Published var selectedCategoryId: String = "all"
    @Published var userName: String = "Alex"
    @Published var searchQuery: String = ""
    @Published var activeFilter: DiscountFilter = DiscountFilter()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Computed properties

    var featured: [Discount] {
        applyFilter(to: discounts.filter { $0.isFeatured })
    }

    var nearby: [Discount] {
        let byCategory = selectedCategoryId == "all"
            ? discounts
            : discounts.filter { $0.category == selectedCategoryId }
        return Array(applyFilter(to: byCategory).prefix(5))
    }

    var expiring: [Discount] {
        let threeDaysFromNow = Date().addingTimeInterval(3 * 24 * 60 * 60)
        let soon = discounts.filter { $0.endDate <= threeDaysFromNow && $0.endDate >= Date() }
        return applyFilter(to: soon)
    }

    // MARK: - Private helpers

    private func applyFilter(to list: [Discount]) -> [Discount] {
        var result = list

        if !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty {
            let q = searchQuery.lowercased()
            result = result.filter {
                $0.title.lowercased().contains(q) || $0.storeName.lowercased().contains(q)
            }
        }

        if let maxKm = activeFilter.maxDistanceKm {
            result = result.filter { $0.distanceKm <= maxKm }
        }

        if let type = activeFilter.discountType.firestoreValue {
            result = result.filter { $0.discountType == type }
        }

        switch activeFilter.sortBy {
        case .nearest:
            result.sort { $0.distanceKm < $1.distanceKm }
        case .expiringSoon:
            result.sort { $0.endDate < $1.endDate }
        case .newest:
            result.sort { $0.startDate > $1.startDate }
        case .none:
            break
        }

        return result
    }
    
    // MARK: - Navigation callbacks
    
    var onSeeAllFeatured: (() -> Void)?
    var onSeeAllNearby: (() -> Void)?
    var onSeeAllExpiring: (() -> Void)?
    var onDiscountTapped: ((String) -> Void)?
    
    // MARK: - Init
    
    init(discountService: DiscountServiceProtocol = DiscountService.shared) {
        self.discountService = discountService
        setupCategories()
    }
    
    // MARK: - Methods
    
    func loadDiscounts() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            discounts = DiscountFormatter.withDistances(try await discountService.fetchAllDiscounts())
        } catch {
            errorMessage = "Couldn't load discounts. Please try again."
            print("loadDiscounts failed: \(error.localizedDescription)")
        }
    }
    
    func selectCategory(_ id: String) {
        selectedCategoryId = id
    }
    
    func applyFilter(_ filter: DiscountFilter) {
        activeFilter = filter
    }

    func resetFilter() {
        activeFilter = DiscountFilter()
    }

    func toggleSave(_ id: String) {
        guard !id.isEmpty,
              let index = discounts.firstIndex(where: { $0.id == id }) else { return }
        discounts[index].isSaved.toggle()
        // TODO: persist to users/{userId}/savedDiscounts/{discountId}
    }
    
    private func setupCategories() {
        categories = [
            DiscountCategory(id: "all",     name: "ყველა",    icon: "square.grid.2x2.fill"),
            DiscountCategory(id: "food",    name: "საკვები",  icon: "fork.knife"),
            DiscountCategory(id: "tech",    name: "ტექნიკა",  icon: "laptopcomputer"),
            DiscountCategory(id: "fashion", name: "მოდა",     icon: "tshirt.fill"),
            DiscountCategory(id: "fitness", name: "ფიტნესი",  icon: "heart.fill"),
            DiscountCategory(id: "books",   name: "წიგნები",  icon: "book.fill"),
        ]
    }
}

//
//  HomeViewModel.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 17.06.26.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    
    // MARK: - Dependencies
    
    private let discountService: DiscountServiceProtocol
    
    // MARK: - Properteis
    
    @Published private var discounts: [Discount] = []
    @Published var categories: [DiscountCategory] = []
    @Published var selectedCategoryId: String = "all"
    @Published var userName: String = "Alex"
    @Published var searchQuery: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Computed Properties
    
    var featured: [Discount] {
        discounts.filter { $0.isFeatured }
    }
    
    var nearby: [Discount] {
        let filtered = selectedCategoryId == "all"
        ? discounts
        : discounts.filter { $0.category == selectedCategoryId }
        return filtered.sorted { $0.distanceKm < $1.distanceKm }
    }
    
    var expiring: [Discount] {
        let threeDaysFromNow = Date().addingTimeInterval(3 * 24 * 60 * 60)
        return discounts
            .filter { $0.endDate <= threeDaysFromNow && $0.endDate >= Date() }
            .sorted { $0.endDate < $1.endDate }
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
            discounts = try await discountService.fetchAllDiscounts()
        } catch {
            errorMessage = "Couldn't load discounts. Please try again."
            print("loadDiscounts failed: \(error.localizedDescription)")
        }
    }
    
    func selectCategory(_ id: String) {
        selectedCategoryId = id
    }
    
    func toggleSave(_ id: String) {
        guard let index = discounts.firstIndex(where: { $0.id == id }) else { return }
        discounts[index].isSaved.toggle()
        // TODO: persist to users/{userId}/savedDiscounts/{discountId}
    }
    
    private func setupCategories() {
        categories = [
            DiscountCategory(id: "all",     name: "All",     icon: "square.grid.2x2.fill"),
            DiscountCategory(id: "food",    name: "Food",    icon: "fork.knife"),
            DiscountCategory(id: "tech",    name: "Tech",    icon: "laptopcomputer"),
            DiscountCategory(id: "fashion", name: "Fashion", icon: "tshirt.fill"),
            DiscountCategory(id: "fitness", name: "Fitness", icon: "heart.fill"),
            DiscountCategory(id: "books",   name: "Books",   icon: "book.fill"),
        ]
    }
}

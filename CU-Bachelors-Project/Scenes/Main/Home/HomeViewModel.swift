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
    @Published var searchQuery: String = ""
    @Published var activeFilter: DiscountFilter = DiscountFilter()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Computed properties

    var featured: [Discount] {
        applyFilter(to: discounts.filter { $0.isFeatured })
    }

    var nearby: [Discount] {
        Array(applyFilter(to: discounts).prefix(5))
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
    
    var userName: String { UserManager.shared.currentUser?.fullname.components(separatedBy: " ").first ?? "სტუდენტო" }
    var userImageUrl: String? { UserManager.shared.currentUser?.imageUrl }

    // MARK: - Navigation callbacks
    
    var onSeeAllFeatured: (() -> Void)?
    var onSeeAllNearby: (() -> Void)?
    var onSeeAllExpiring: (() -> Void)?
    var onDiscountTapped: ((String) -> Void)?
    var onSettingsTapped: (() -> Void)?
    
    // MARK: - Init
    
    init(discountService: DiscountServiceProtocol = DiscountService.shared) {
        self.discountService = discountService
    }
    
    // MARK: - Methods
    
    func loadDiscounts() async {
        isLoading = true
        errorMessage = nil
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
            errorMessage = "Couldn't load discounts. Please try again."
            print("loadDiscounts failed: \(error.localizedDescription)")
        }
    }
    
    func applyFilter(_ filter: DiscountFilter) {
        activeFilter = filter
    }

    func resetFilter() {
        activeFilter = DiscountFilter()
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

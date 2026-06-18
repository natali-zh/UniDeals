//
//  ExploreView.swift
//  CU-Bachelors-Project
//

import SwiftUI

struct ExploreView: View {

    @ObservedObject var viewModel: ExploreViewModel
    @State private var showFilter = false
    @State private var pendingFilter = DiscountFilter()

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                LazyVStack(spacing: 16) {
                    segmentedControl
                        .padding(.top, 8)

                    if viewModel.selectedTab == .discounts {
                        if viewModel.hasActiveFilters {
                            activeFilterChips
                        }

                        if viewModel.isLoading {
                            DiscountsGridSkeleton()
                        } else {
                            DiscountsGridView(
                                discounts: viewModel.filteredDiscounts,
                                onTap: { viewModel.onDiscountTapped?($0) },
                                onSave: { viewModel.toggleSave($0) }
                            )
                        }
                    } else {
                        if viewModel.isLoading {
                            DiscountsGridSkeleton()
                        } else {
                            PartnersListView(
                                partners: viewModel.filteredPartners,
                                offerCount: { viewModel.offerCount(for: $0) },
                                onTap: { viewModel.onPartnerTapped?($0) }
                            )
                        }
                    }
                }
                .padding(.bottom, 24)
            }
            .background(Color(red: 0.97, green: 0.97, blue: 0.98))
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showFilter) {
            FilterSheet(
                filter: $pendingFilter,
                selectedCategories: $viewModel.selectedCategoryIds,
                categories: viewModel.categories,
                onApply: {
                    viewModel.activeFilter = pendingFilter
                    showFilter = false
                },
                onReset: {
                    pendingFilter = DiscountFilter()
                    viewModel.activeFilter = DiscountFilter()
                    viewModel.clearCategories()
                    showFilter = false
                }
            )
            .presentationDetents([.fraction(0.62), .large])
            .presentationDragIndicator(.visible)
        }
        .task {
            await viewModel.loadData()
        }
    }

    // MARK: - Active filter chips

    private var activeFilterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // Sort chip
                if let sort = viewModel.activeFilter.sortBy {
                    ActiveFilterChip(label: "\(sort.label) \(sort.arrow)") {
                        viewModel.activeFilter.sortBy = nil
                    }
                }

                // Discount type chip
                if viewModel.activeFilter.discountType != .all {
                    ActiveFilterChip(label: viewModel.activeFilter.discountType.rawValue) {
                        viewModel.activeFilter.discountType = .all
                    }
                }

                // Category chips
                ForEach(Array(viewModel.selectedCategoryIds), id: \.self) { catId in
                    if let cat = viewModel.categories.first(where: { $0.id == catId }) {
                        ActiveFilterChip(label: cat.name) {
                            viewModel.selectedCategoryIds.remove(catId)
                        }
                    }
                }

                // Clear all
                Button {
                    viewModel.activeFilter = DiscountFilter()
                    viewModel.clearCategories()
                } label: {
                    Text("გასუფთავება")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.red)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.red.opacity(0.08))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 12) {
            Text("აღმოაჩინე")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.gray900)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 16)

            HomeSearchBar(
                query: $viewModel.searchQuery,
                isFilterActive: viewModel.hasActiveFilters,
                onFilterTap: {
                    pendingFilter = viewModel.activeFilter
                    showFilter = true
                }
            )
            .padding(.horizontal, 4)
            .padding(.bottom, 4)
        }
        .background(Color.white)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }

    // MARK: - Segmented control

    private var segmentedControl: some View {
        HStack(spacing: 0) {
            segmentButton(title: "ფასდაკლებები", tab: .discounts)
            segmentButton(title: "პარტნიორები", tab: .partners)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 16)
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }

    private func segmentButton(title: String, tab: ExploreTab) -> some View {
        let isSelected = viewModel.selectedTab == tab
        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                viewModel.selectedTab = tab
            }
        } label: {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .semibold : .medium))
                .foregroundColor(isSelected ? .colorPrimary : .gray500)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? Color.colorPrimary.opacity(0.08) : Color.clear)
                        .padding(4)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Active filter chip

private struct ActiveFilterChip: View {
    let label: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 5) {
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray900)
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.gray500)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.white)
        .clipShape(Capsule())
    }
}

#Preview {
    ExploreView(viewModel: ExploreViewModel())
}

import SwiftUI

struct ExploreView: View {
    
    //MARK: - Properties
    
    @ObservedObject var viewModel: ExploreViewModel
    @State private var showFilter = false
    @State private var pendingFilter = DiscountFilter()
    
    //MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            ExploreHeader(
                searchQuery: $viewModel.searchQuery,
                hasActiveFilters: viewModel.hasActiveFilters,
                onFilterTap: {
                    pendingFilter = viewModel.activeFilter
                    showFilter = true
                }
            )
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    ExploreSegmentedControl(selectedTab: $viewModel.selectedTab)
                        .padding(.top, 8)
                    
                    if viewModel.selectedTab == .discounts {
                        discountsContent
                    } else {
                        partnersContent
                    }
                }
                .padding(.bottom, 24)
            }
            .refreshable { await viewModel.loadData(forceReload: true) }
            .background(Color(.systemGroupedBackground))
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
        .task { await viewModel.loadData() }
        .onAppear {
            Task { await viewModel.refreshSavedState() }
        }
    }
    
    //MARK: - Subviews
    
    @ViewBuilder
    private var discountsContent: some View {
        if viewModel.hasActiveFilters {
            ActiveFilterChipsView(
                activeFilter: $viewModel.activeFilter,
                selectedCategoryIds: $viewModel.selectedCategoryIds,
                categories: viewModel.categories,
                onClearAll: {
                    viewModel.activeFilter = DiscountFilter()
                    viewModel.clearCategories()
                }
            )
        }
        
        if viewModel.isLoading {
            DiscountsGridSkeleton()
        } else if viewModel.filteredDiscounts.isEmpty {
            ExploreEmptyState(message: "შეთავაზება ვერ მოიძებნა")
        } else {
            DiscountsGridView(
                discounts: viewModel.filteredDiscounts,
                onTap: { viewModel.onDiscountTapped?($0) },
                onSave: { viewModel.toggleSave($0) }
            )
        }
    }
    
    @ViewBuilder
    private var partnersContent: some View {
        if viewModel.isLoading {
            DiscountsGridSkeleton()
        } else if viewModel.filteredPartners.isEmpty {
            ExploreEmptyState(message: "პარტნიორი ვერ მოიძებნა")
        } else {
            PartnersListView(
                partners: viewModel.filteredPartners,
                offerCount: { viewModel.offerCount(for: $0) },
                onTap: { viewModel.onPartnerTapped?($0) }
            )
        }
    }
}

#Preview {
    ExploreView(viewModel: ExploreViewModel())
}

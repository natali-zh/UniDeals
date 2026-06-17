//
//  ExploreView.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 14.06.26.
//

import SwiftUI

struct ExploreView: View {

    @ObservedObject var viewModel: ExploreViewModel

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                LazyVStack(spacing: 16) {
                    segmentedControl
                        .padding(.top, 8)

                    if viewModel.selectedTab == .discounts {
                        ExploreCategoryBar(
                            categories: viewModel.categories,
                            selectedIds: viewModel.selectedCategoryIds,
                            onToggle: { viewModel.toggleCategory($0) },
                            onSelectAll: { viewModel.clearCategories() }
                        )

                        if viewModel.isLoading {
                            ProgressView().padding(.top, 40)
                        } else {
                            DiscountsGridView(
                                discounts: viewModel.filteredDiscounts,
                                onTap: { viewModel.onDiscountTapped?($0) }
                            )
                        }
                    } else {
                        if viewModel.isLoading {
                            ProgressView().padding(.top, 40)
                        } else {
                            PartnersListView(
                                partners: viewModel.filteredPartners,
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
        .task {
            await viewModel.loadData()
        }
    }

    // MARK: - Subviews

    private var header: some View {
        VStack(spacing: 12) {
            Text("აღმოაჩინე")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.gray900)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 16)

            HomeSearchBar(query: $viewModel.searchQuery)
            .padding(.horizontal, 4)
            .padding(.bottom, 4)
        }
        .background(Color.white)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }

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

#Preview {
    ExploreView(viewModel: ExploreViewModel())
}

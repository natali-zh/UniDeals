//
//  HomeView.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 14.06.26.
//

import SwiftUI

struct HomeView: View {

    //TODO: inj
    @StateObject private var viewModel = HomeViewModel()

    //MARK: - Body
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                HomeSearchBar(query: $viewModel.searchQuery)
                  

                featuredSection
            }
        }
        .background(Color.white)
        .task {
            await viewModel.loadDiscounts()
        }
    }

    //MARK: - Subviews
    
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Featured")
                    .sectionTitleStyle()
                Spacer()
                Button("See All") { viewModel.onSeeAllFeatured?() }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.colorPrimary)
            }
            .padding(.horizontal, 20)

            if viewModel.isLoading && viewModel.featured.isEmpty {
                FeaturedPlaceholder(text: "Loading...")
                    .padding(.horizontal, 20)
            } else if viewModel.featured.isEmpty {
                FeaturedPlaceholder(text: "No featured discounts yet")
                    .padding(.horizontal, 20)
            } else {
                FeaturedCarousel(
                    discounts: viewModel.featured,
                    onTap: { viewModel.onDiscountTapped?($0) },
                    onSave: { viewModel.toggleSave($0) }
                )
            }
        }
        .padding(.top, 16)
    }
}



// MARK: - Color helper

extension Color {
    static let gray300 = Color(red: 0.80, green: 0.80, blue: 0.82)
}

#Preview {
    HomeView()
}

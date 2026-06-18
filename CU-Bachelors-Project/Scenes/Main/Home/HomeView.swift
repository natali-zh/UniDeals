//
//  HomeView.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 14.06.26.
//

import Combine
import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    @State private var pendingFilter = DiscountFilter()
    
    // MARK: - Init
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    //MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            
            ScrollView {
                LazyVStack(spacing: 8) {
                    //TODO: Header design
                    
                    featuredSection
                    
                    nearbySection
                    
                    expiringSoonSection
                        .padding(.top, 8)
                        .padding(.bottom, 24)
                }
            }
            .background(Color(red: 0.97, green: 0.97, blue: 0.98))
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.loadDiscounts()
        }
    }
    
    //MARK: - Subviews
    
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("გამორჩეული შეთავაზებები")
                    .sectionTitleStyle()
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
    }
    
    private var nearbySection: some View {
        NearbySection(
            discounts: viewModel.nearby,
            onSeeAll: { viewModel.onSeeAllNearby?() },
            onTap: { viewModel.onDiscountTapped?($0) },
            onSave: { viewModel.toggleSave($0) }
        )
        .padding(.top, 24)
    }
    
    private var expiringSoonSection: some View {
        ExpiringSoonSection(
            discounts: viewModel.expiring,
            onSeeAll: { viewModel.onSeeAllExpiring?() },
            onTap: { viewModel.onDiscountTapped?($0) },
            onSave: { viewModel.toggleSave($0) }
        )
        .padding(.top, 24)
    }
}



// MARK: - Color helper

extension Color {
    static let gray300 = Color(red: 0.80, green: 0.80, blue: 0.82)
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}

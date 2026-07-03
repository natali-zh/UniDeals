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
                    homeHeader
                        .padding(.bottom)

                    featuredSection
                    
                    nearbySection
                    
                    expiringSoonSection
                        .padding(.top, 8)
                        .padding(.bottom, 24)
                }
            }
            .refreshable { await viewModel.loadDiscounts(forceReload: true) }
            .background(Color(.systemGroupedBackground))
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.loadDiscounts()
        }
        .onAppear {
            Task { await viewModel.refreshSavedState() }
        }
        .onChange(of: LocationManager.shared.locationUpdateCount) { _, _ in
            viewModel.refreshDistances()
        }
    }
    
    //MARK: - Subviews

    private var homeHeader: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text("გამარჯობა,")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.secondary)
                Text(viewModel.userName)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)
            }
            Spacer()
            Button {
                viewModel.onSettingsTapped?()
            } label: {
                RemoteImage(url: viewModel.userImageUrl, placeholder: Image(systemName: "person.circle.fill"))
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .overlay(alignment: .bottom) {
            Divider()
        }
        .padding(.bottom, 8)
    }

    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("გამორჩეული შეთავაზებები")
                    .sectionTitleStyle()
            }
            .padding(.horizontal, 20)

            if viewModel.isLoading {
                FeaturedCardSkeleton()
            } else if viewModel.featured.isEmpty {
                FeaturedPlaceholder(text: "გამორჩეული შეთავაზება არ არის")
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
        Group {
            if viewModel.isLoading {
                NearbySectionSkeleton()
            } else {
                NearbySection(
                    discounts: viewModel.nearby,
                    onSeeAll: { viewModel.onSeeAllNearby?() },
                    onTap: { viewModel.onDiscountTapped?($0) },
                    onSave: { viewModel.toggleSave($0) }
                )
            }
        }
        .padding(.top, 24)
    }

    private var expiringSoonSection: some View {
        Group {
            if viewModel.isLoading {
                ExpiringSectionSkeleton()
            } else {
                ExpiringSoonSection(
                    discounts: viewModel.expiring,
                    onSeeAll: { viewModel.onSeeAllExpiring?() },
                    onTap: { viewModel.onDiscountTapped?($0) },
                    onSave: { viewModel.toggleSave($0) }
                )
            }
        }
        .padding(.top, 24)
    }
}



// MARK: - Color helper

extension Color {
    static let gray300 = Color(.systemFill)
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}

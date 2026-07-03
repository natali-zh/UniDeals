import SwiftUI

struct PartnerDetailView: View {
    
    //MARK: - Properties
    
    @State private var viewModel: PartnerDetailViewModel

    //MARK: - Init

    init(viewModel: PartnerDetailViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    //MARK: - Body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    PartnerHeroView(
                        partner: viewModel.partner,
                        onBack: { viewModel.onBack?() }
                    )
                    contentSheet
                }
            }
            .ignoresSafeArea(edges: .top)
            
            mapButton
                .stickyFooter()
        }
        .navigationBarHidden(true)
        .background(Color(.secondarySystemGroupedBackground))
        .task { await viewModel.loadOffers() }
    }
    
    //MARK: - Subviews
    
    private var contentSheet: some View {
        VStack(alignment: .leading, spacing: 0) {
            PartnerInfoCard(partner: viewModel.partner)
            PartnerContactButtons(phone: viewModel.partner.phone, website: viewModel.partner.website)
            aboutSection
            Divider().padding(.horizontal, 20)
            PartnerOffersSection(
                offers: viewModel.offers,
                isLoading: viewModel.isLoading,
                distanceText: { viewModel.distanceText(for: $0) },
                onOfferTapped: { viewModel.onOfferTapped?($0) }
            )
            Color.clear.frame(height: 90)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(topLeadingRadius: 24, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 24))
        .padding(.top, -24)
    }
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("კომპანიის შესახებ")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.gray900)
            Text(viewModel.partner.description)
                .font(.system(size: 14))
                .foregroundColor(.gray500)
                .lineSpacing(4)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
    
    private var mapButton: some View {
        let firstOffer = viewModel.offers.first
        return Button(action: {
            if let offer = firstOffer { viewModel.onViewOnMap?(offer) }
        }) {
            HStack(spacing: 8) {
                Image(systemName: "map").font(.system(size: 15, weight: .medium))
                Text("რუკაზე ნახვა").font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(firstOffer == nil ? .gray500 : .white)
            .primaryActionButton()
        }
        .disabled(firstOffer == nil || viewModel.isLoading)
        .opacity(firstOffer == nil ? 0.5 : 1)
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

import SwiftUI

struct DiscountDetailView: View {
    
    //MARK: - Properties
    
    @State private var viewModel: DiscountDetailViewModel
    @State private var showCard = false

    //MARK: - Init

    init(viewModel: DiscountDetailViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    //MARK: - Boduy
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    DiscountHeroView(
                        discount: viewModel.discount,
                        isSaved: viewModel.isSaved,
                        onBack: { viewModel.onBack?() },
                        onToggleSave: { viewModel.toggleSave() }
                    )
                    DiscountContentSheet(
                        discount: viewModel.discount,
                        partner: viewModel.partner,
                        distanceText: viewModel.distanceText,
                        daysLeftText: viewModel.daysLeftText,
                        daysLeftIsUrgent: viewModel.daysLeftIsUrgent,
                        formattedEndDate: viewModel.formattedEndDate,
                        onPartnerTapped: { viewModel.onPartnerTapped?($0) }
                    )
                }
            }
            .ignoresSafeArea(edges: .top)
            
            DiscountBottomCTA(
                onViewOnMap: { viewModel.onViewOnMap?(viewModel.discount) },
                onUseDiscount: { showCard = true }
            )
            .stickyFooter()
        }
        .navigationBarHidden(true)
        .background(Color(.secondarySystemGroupedBackground))
        .task { await viewModel.loadPartner() }
        .sheet(isPresented: $showCard) {
            CardView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
}

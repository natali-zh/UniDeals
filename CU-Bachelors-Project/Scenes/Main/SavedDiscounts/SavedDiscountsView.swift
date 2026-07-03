import SwiftUI

struct SavedDiscountsView: View {
    
    //MARK: - Properties
    
    @State private var viewModel: SavedDiscountsViewModel
    
    //MARK: - Init
    
    init(viewModel: SavedDiscountsViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    //MARK: - Body
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            
            if viewModel.isLoading {
                ScrollView(showsIndicators: false) {
                    DiscountsGridSkeleton()
                        .padding(.top, 16)
                }
            } else if viewModel.discounts.isEmpty {
                SavedDiscountsEmptyState()
            } else {
                ScrollView(showsIndicators: false) {
                    DiscountsGridView(
                        discounts: viewModel.discounts,
                        onTap: { discountId in
                            if let d = viewModel.discounts.first(where: { $0.id == discountId }) {
                                viewModel.onDiscountTapped?(d)
                            }
                        },
                        onSave: { viewModel.toggleSave($0) },
                        showCount: false
                    )
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                }
                .refreshable { await viewModel.load() }
            }
        }
        .navigationTitle("შენახული შეთავაზებები")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(false)
        .task { await viewModel.load() }
    }
}

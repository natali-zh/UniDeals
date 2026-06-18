import SwiftUI

struct SavedDiscountsView: View {

    @State private var viewModel: SavedDiscountsViewModel

    init(viewModel: SavedDiscountsViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.97, blue: 0.98).ignoresSafeArea()

            if viewModel.isLoading {
                ScrollView(showsIndicators: false) {
                    DiscountsGridSkeleton()
                        .padding(.top, 16)
                }
            } else if viewModel.discounts.isEmpty {
                emptyState
            } else {
                ScrollView(showsIndicators: false) {
                    DiscountsGridView(
                        discounts: viewModel.discounts,
                        onTap: { discountId in
                            if let d = viewModel.discounts.first(where: { $0.id == discountId }) {
                                viewModel.onDiscountTap?(d)
                            }
                        },
                        onSave: { discountId in
                            viewModel.toggleSave(discountId)
                        }
                    )
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationTitle("შენახული შეთავაზებები")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(false)
        .task { await viewModel.load() }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.slash")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(.gray300)
            Text("შენახული შეთავაზება არ გაქვს")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray500)
            Text("შენი ფავორიტი შეთავაზებები აქ გამოჩნდება")
                .font(.system(size: 13))
                .foregroundColor(.gray300)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

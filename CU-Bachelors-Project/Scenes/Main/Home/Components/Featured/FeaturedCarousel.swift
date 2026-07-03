import SwiftUI

struct FeaturedCarousel: View {

    let discounts: [Discount]
    let onTap: (String) -> Void
    let onSave: (String) -> Void

    @State private var carouselViewModel: FeaturedCarouselViewModel

    init(discounts: [Discount], onTap: @escaping (String) -> Void, onSave: @escaping (String) -> Void) {
        self.discounts = discounts
        self.onTap = onTap
        self.onSave = onSave
        _carouselViewModel = State(wrappedValue: FeaturedCarouselViewModel(itemCount: discounts.count))
    }

    var body: some View {
        VStack(spacing: 14) {
            TabView(selection: $carouselViewModel.currentIndex) {
                ForEach(Array(discounts.enumerated()), id: \.element.id) { index, discount in
                    FeaturedCard(discount: discount, onSave: { onSave(discount.id ?? "") })
                        .padding(.horizontal, 20)
                        .tag(index)
                        .pressEffect()
                        .onTapGesture { onTap(discount.id ?? "") }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 210)

            FeaturedPageIndicator(
                count: discounts.count,
                currentIndex: carouselViewModel.currentIndex
            )
        }
        .onAppear { carouselViewModel.start() }
        .onDisappear { carouselViewModel.stop() }
        .onChange(of: discounts.count) { _, newCount in
            carouselViewModel.updateItemCount(newCount)
        }
    }
}

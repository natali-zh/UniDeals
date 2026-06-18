import SwiftUI

struct FeaturedCarousel: View {
    let discounts: [Discount]
    let onTap: (String) -> Void
    let onSave: (String) -> Void

    @StateObject private var carouselViewModel: FeaturedCarouselViewModel

    init(discounts: [Discount], onTap: @escaping (String) -> Void, onSave: @escaping (String) -> Void) {
        self.discounts = discounts
        self.onTap = onTap
        self.onSave = onSave
        _carouselViewModel = StateObject(wrappedValue: FeaturedCarouselViewModel(itemCount: discounts.count))
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

struct FeaturedPageIndicator: View {
    let count: Int
    let currentIndex: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<count, id: \.self) { i in
                Capsule()
                    .fill(i == currentIndex ? Color.colorPrimary : Color.gray300)
                    .frame(width: i == currentIndex ? 20 : 6, height: 6)
                    .animation(.easeInOut(duration: 0.2), value: currentIndex)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct FeaturedCard: View {
    let discount: Discount
    let onSave: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            FeaturedCardImage(imageUrl: discount.imageUrl)

            Text(discount.label)
                .badgeStyle()
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)

            SaveButton(isSaved: discount.isSaved, action: onSave)
                .padding(14)

            FeaturedCardInfoOverlay(discount: discount)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 4)
    }
}

struct FeaturedCardImage: View {
    let imageUrl: String?

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.gray100)
            .frame(height: 210)
            .overlay(content)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var content: some View {
        RemoteImage(url: imageUrl, placeholder: Image(systemName: "photo"))
    }
}

struct FeaturedCardInfoOverlay: View {
    let discount: Discount

    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading, spacing: 4) {
                Text(discount.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                HStack(spacing: 4) {
                    Text(discount.storeName)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.85))
                    Circle()
                        .fill(Color.white.opacity(0.5))
                        .frame(width: 3, height: 3)
                    Text(String(format: "%.1f km", discount.distanceKm))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.85))
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .padding(.top, 36)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    colors: [.clear, .black.opacity(0.65)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }
}

struct FeaturedPlaceholder: View {
    let text: String

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.gray100)
            .frame(height: 210)
            .overlay(
                VStack(spacing: 8) {
                    Image(systemName: "tag")
                        .font(.system(size: 32))
                        .foregroundColor(Color.gray500.opacity(0.4))
                    Text(text)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.gray500)
                }
            )
    }
}

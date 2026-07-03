import SwiftUI

struct MapDiscountCard: View {

    let discount: Discount
    let onViewOffer: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                discountImage
                discountInfo
                Spacer()
                trailing
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)

            Button(action: onViewOffer) {
                Text("შეთავაზების ნახვა")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .primaryActionButton(verticalPadding: 14)
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 8)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.12), radius: 16, x: 0, y: -4)
    }

    @ViewBuilder
    private var discountImage: some View {
        if let urlStr = discount.imageUrl, let url = URL(string: urlStr) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                default:
                    imagePlaceholder
                }
            }
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        } else {
            imagePlaceholder
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var imagePlaceholder: some View {
        Color.gray100.overlay(
            Image(systemName: "storefront")
                .font(.system(size: 22))
                .foregroundColor(Color.gray500.opacity(0.4))
        )
    }

    private var discountInfo: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(discount.title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.gray900)
                .lineLimit(1)
            Text(discount.storeName)
                .font(.system(size: 13))
                .foregroundColor(.gray500)
            HStack(spacing: 10) {
                Label(DiscountFormatter.distanceText(discount.distanceKm), systemImage: "location")
                Label(DiscountFormatter.daysLeftText(for: discount.endDate), systemImage: "clock")
            }
            .font(.system(size: 12))
            .foregroundColor(.gray500)
            .labelStyle(.titleAndIcon)
        }
    }

    private var trailing: some View {
        VStack(alignment: .trailing, spacing: 8) {
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.gray500)
                    .frame(width: 28, height: 28)
                    .background(Color.gray100)
                    .clipShape(Circle())
            }
            Text(discount.label)
                .badgeStyle()
        }
    }
}

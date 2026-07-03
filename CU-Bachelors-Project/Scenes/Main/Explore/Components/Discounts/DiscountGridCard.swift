import SwiftUI

struct DiscountGridCard: View {

    let discount: Discount
    var onSave: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            cardImage
            cardInfo
        }
        .frame(height: 220)
        .cardStyle(cornerRadius: 14)
    }

    private var cardImage: some View {
        ZStack(alignment: .topLeading) {
            DiscountGridCardImage(imageUrl: discount.imageUrl)

            Text(discount.label)
                .badgeStyle(fontSize: 11, horizontalPadding: 8, verticalPadding: 5)
                .padding(8)

            if let onSave {
                SaveButton(isSaved: discount.isSaved, action: onSave)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(8)
            }
        }
        .frame(height: 120)
    }

    private var cardInfo: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(discount.title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.gray900)
                .lineLimit(2)

            Text(discount.storeName)
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(.gray500)
                .lineLimit(1)

            Spacer()

            HStack(spacing: 3) {
                Image(systemName: "location")
                    .font(.system(size: 10))
                    .foregroundColor(.gray500)
                Text(String(format: "%.1f km", discount.distanceKm))
                    .font(.system(size: 11))
                    .foregroundColor(.gray500)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

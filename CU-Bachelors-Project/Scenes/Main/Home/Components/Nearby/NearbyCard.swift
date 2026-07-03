import SwiftUI

struct NearbyCard: View {

    let discount: Discount
    let onSave: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            cardImage
            cardInfo
        }
        .frame(width: 170, height: 230)
        .cardStyle()
    }

    private var cardImage: some View {
        ZStack(alignment: .topLeading) {
            NearbyCardImage(imageUrl: discount.imageUrl)

            Text(discount.label)
                .badgeStyle(fontSize: 12, horizontalPadding: 10, verticalPadding: 6)
                .padding(10)

            SaveButton(isSaved: discount.isSaved, action: onSave)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(10)
        }
        .frame(height: 130)
    }

    private var cardInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(discount.title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray900)
                .lineLimit(2)
                .frame(height: 40, alignment: .topLeading)

            Text(discount.storeName)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.gray500)

            Spacer()

            HStack(spacing: 4) {
                Image(systemName: "location")
                    .font(.system(size: 11))
                    .foregroundColor(.gray500)
                Text(String(format: "%.1f km", discount.distanceKm))
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.gray500)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

import SwiftUI

struct ExpiringCard: View {

    let discount: Discount
    var onSave: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 0) {
            ExpiringCardImage(imageUrl: discount.imageUrl)
                .frame(width: 110, height: 110)

            cardInfo
        }
        .frame(height: 110)
        .cardStyle(cornerRadius: 16)
    }

    private var cardInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top, spacing: 8) {
                Text(discount.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.gray900)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if let onSave {
                    SaveButton(isSaved: discount.isSaved, backgroundOpacity: 0.18, action: onSave)
                        .buttonStyle(.plain)
                }
            }

            Text(discount.storeName)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.gray500)

            Spacer(minLength: 8)

            HStack(spacing: 4) {
                Image(systemName: "location")
                    .font(.system(size: 11))
                    .foregroundColor(.gray500)
                Text(String(format: "%.1f km", discount.distanceKm))
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.gray500)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

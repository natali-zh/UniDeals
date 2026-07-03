import SwiftUI

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

import SwiftUI

struct NearbySection: View {
    let discounts: [Discount]
    let onSeeAll: () -> Void
    let onTap: (String) -> Void
    let onSave: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("შენთან ახლოს")
                    .sectionTitleStyle()
                Spacer()
                Button("ყველას ნახვა") { onSeeAll() }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.colorPrimary)
            }
            .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(discounts) { discount in
                        NearbyCard(
                            discount: discount,
                            onSave: { onSave(discount.id ?? "") }
                        )
                        .pressEffect()
                        .onTapGesture { onTap(discount.id ?? "") }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 4)
            }
        }
    }
}

private struct NearbyCard: View {
    let discount: Discount
    let onSave: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
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

            VStack(alignment: .leading, spacing: 4) {
                Text(discount.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray900)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Text(discount.storeName)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.gray500)

                HStack(spacing: 4) {
                    Image(systemName: "location")
                        .font(.system(size: 11))
                        .foregroundColor(.gray500)
                    Text(String(format: "%.1f km", discount.distanceKm))
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.gray500)
                }
                .padding(.top, 6)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: 170)
        .cardStyle()
    }
}

private struct NearbyCardImage: View {
    let imageUrl: String?

    var body: some View {
        Color.gray100
            .frame(height: 130)
            .overlay(content)
            .clipShape(
                .rect(
                    topLeadingRadius: 16,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 16
                )
            )
    }

    private var content: some View {
        RemoteImage(url: imageUrl, placeholder: Image(systemName: "photo"))
    }
}

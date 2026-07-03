import SwiftUI

struct OfferRow: View {

    let offer: Discount
    let distanceText: String
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                thumbnail
                info
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray500)
            }
            .padding(12)
            .background(Color(.systemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }

    private var thumbnail: some View {
        Group {
            if let urlStr = offer.imageUrl, let url = URL(string: urlStr) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fill)
                    default:
                        Color.gray100
                    }
                }
            } else {
                Color.gray100
            }
        }
        .frame(width: 72, height: 72)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            Text(offer.label)
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(Color.colorPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .padding(6),
            alignment: .topLeading
        )
    }

    private var info: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(offer.title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray900)
                .lineLimit(2)

            HStack(spacing: 10) {
                Label(distanceText, systemImage: "location.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.gray500)

                Label(DiscountFormatter.daysLeftText(for: offer.endDate), systemImage: "clock")
                    .font(.system(size: 12))
                    .foregroundColor(DiscountFormatter.daysLeftColor(for: offer.endDate))
            }
        }
    }
}

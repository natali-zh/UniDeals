import SwiftUI

struct PartnersListView: View {
    let partners: [Partner]
    let offerCount: (Partner) -> Int
    let onTap: (String) -> Void

    var body: some View {
        VStack(spacing: 10) {
            ForEach(partners) { partner in
                PartnerRow(partner: partner, offerCount: offerCount(partner))
                    .onTapGesture { onTap(partner.id ?? "") }
            }
        }
        .padding(.horizontal, 16)
    }
}

private struct PartnerRow: View {
    let partner: Partner
    let offerCount: Int

    var body: some View {
        HStack(spacing: 14) {
            PartnerLogo(logoUrl: partner.logoUrl)

            VStack(alignment: .leading, spacing: 3) {
                Text(partner.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.gray900)

                Text(partner.category)
                    .font(.system(size: 13))
                    .foregroundColor(.gray500)

                HStack(spacing: 6) {
                    Text("\(offerCount) შეთავაზება")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.colorPrimary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.colorPrimary.opacity(0.1))
                        .clipShape(Capsule())
                }
                .padding(.top, 2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray500)
        }
        .padding(14)
        .cardStyle(cornerRadius: 14)
    }
}

private struct PartnerLogo: View {
    let logoUrl: String?

    var body: some View {
        Group {
            if let logoUrl, let url = URL(string: logoUrl), !logoUrl.isEmpty {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fill)
                    default:
                        placeholderIcon
                    }
                }
            } else {
                placeholderIcon
            }
        }
        .frame(width: 56, height: 56)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.gray300, lineWidth: 0.5)
        )
    }

    private var placeholderIcon: some View {
        Color.gray100
            .overlay(
                Image(systemName: "storefront")
                    .font(.system(size: 22))
                    .foregroundColor(Color.gray500.opacity(0.4))
            )
    }
}

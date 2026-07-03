import SwiftUI

struct PartnerInfoCard: View {

    let partner: Partner

    var body: some View {
        HStack(spacing: 14) {
            partnerLogo
            partnerDetails
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 12)
    }

    private var partnerLogo: some View {
        Group {
            if let logoUrl = partner.logoUrl, let url = URL(string: logoUrl) {
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
        .frame(width: 56, height: 56)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.gray300, lineWidth: 0.5))
    }

    private var partnerDetails: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(partner.name)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.gray900)

            HStack(spacing: 4) {
                Image(systemName: "location.circle")
                    .font(.system(size: 12))
                    .foregroundColor(.gray500)
                Text(partner.address)
                    .font(.system(size: 12))
                    .foregroundColor(.gray500)
                    .lineLimit(1)
            }
            .padding(.top, 2)
        }
    }
}

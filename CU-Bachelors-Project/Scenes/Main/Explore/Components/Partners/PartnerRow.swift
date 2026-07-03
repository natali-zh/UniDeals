import SwiftUI

struct PartnerRow: View {

    let partner: Partner
    let offerCount: Int

    var body: some View {
        HStack(spacing: 14) {
            PartnerLogo(logoUrl: partner.logoUrl)

            VStack(alignment: .leading, spacing: 3) {
                Text(partner.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.gray900)

                Text(AppCategories.georgianName(for: partner.category))
                    .font(.system(size: 13))
                    .foregroundColor(.gray500)

                Text("\(offerCount) შეთავაზება")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.colorPrimary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.colorPrimary.opacity(0.1))
                    .clipShape(Capsule())
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

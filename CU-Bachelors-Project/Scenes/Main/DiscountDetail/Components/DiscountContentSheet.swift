import SwiftUI

struct DiscountContentSheet: View {

    let discount: Discount
    let partner: Partner?
    let distanceText: String
    let daysLeftText: String
    let daysLeftIsUrgent: Bool
    let formattedEndDate: String
    let onPartnerTapped: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleBlock
            Divider().padding(.horizontal, 20)
            aboutSection
            Divider().padding(.horizontal, 20)
            validitySection
            Divider().padding(.horizontal, 20)
            merchantSection
            Color.clear.frame(height: 90)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(topLeadingRadius: 24, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 24))
        .padding(.top, -24)
    }

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(discount.title)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.gray900)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 16) {
                Label(distanceText, systemImage: "location.fill")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray500)
                Label(daysLeftText, systemImage: "clock")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(daysLeftIsUrgent ? .red : .gray500)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 16)
    }

    private var aboutSection: some View {
        sectionBlock(title: "შეთავაზების შესახებ") {
            Text(discount.description)
                .font(.system(size: 14))
                .foregroundColor(.gray500)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var validitySection: some View {
        sectionBlock(title: "მოქმედების ვადა") {
            HStack(spacing: 24) {
                dateColumn(label: "დაწყება", value: DiscountFormatter.formattedDate(discount.startDate))
                Divider().frame(height: 32)
                dateColumn(label: "დასრულება", value: formattedEndDate)
                Spacer()
            }
        }
    }

    private func dateColumn(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.gray500)
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray900)
        }
    }

    private var merchantSection: some View {
        sectionBlock(title: "პარტნიორი") {
            Button(action: {
                onPartnerTapped(partner?.id ?? discount.storeId)
            }) {
                HStack(spacing: 12) {
                    partnerLogo
                    partnerInfo
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.gray500)
                }
            }
            .buttonStyle(.plain)
        }
    }

    private var partnerInfo: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(discount.storeName)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.gray900)
            HStack(spacing: 4) {
                Image(systemName: "location.circle")
                    .font(.system(size: 11))
                    .foregroundColor(.gray500)
                Text(partner?.address ?? discount.storeAddress)
                    .font(.system(size: 12))
                    .foregroundColor(.gray500)
                    .lineLimit(1)
            }
        }
    }

    private var partnerLogo: some View {
        Group {
            if let logoUrl = partner?.logoUrl, let url = URL(string: logoUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fill)
                    default:
                        Color.gray100
                    }
                }
            } else {
                Color.gray100.overlay(
                    Image(systemName: "storefront")
                        .font(.system(size: 20))
                        .foregroundColor(Color.gray500.opacity(0.4))
                )
            }
        }
        .frame(width: 56, height: 56)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.gray300, lineWidth: 0.5))
    }

    private func sectionBlock<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.gray900)
            content()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
}

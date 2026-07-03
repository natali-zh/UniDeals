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
                Button("ყველას ნახვა", action: onSeeAll)
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
                .padding(.vertical, 8)
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

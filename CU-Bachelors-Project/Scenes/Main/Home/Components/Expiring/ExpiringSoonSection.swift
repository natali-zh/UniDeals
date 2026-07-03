import SwiftUI

struct ExpiringSoonSection: View {

    let discounts: [Discount]
    let onSeeAll: () -> Void
    let onTap: (String) -> Void
    var onSave: ((String) -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("მალე იწურება")
                    .sectionTitleStyle()
                Circle()
                    .fill(Color.red)
                    .frame(width: 8, height: 8)
                Spacer()
                Button("ყველას ნახვა", action: onSeeAll)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.colorPrimary)
            }
            .padding(.horizontal, 20)

            VStack(spacing: 12) {
                ForEach(discounts) { discount in
                    ExpiringCard(
                        discount: discount,
                        onSave: onSave.map { cb in { cb(discount.id ?? "") } }
                    )
                    .pressEffect()
                    .onTapGesture { onTap(discount.id ?? "") }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

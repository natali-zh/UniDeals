import SwiftUI

struct DiscountsGridView: View {

    let discounts: [Discount]
    let onTap: (String) -> Void
    var onSave: ((String) -> Void)? = nil
    var showCount: Bool = true

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if showCount {
                Text("ნაპოვნია \(discounts.count) შეთავაზება")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray500)
                    .padding(.horizontal, 20)
            }

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(discounts) { discount in
                    DiscountGridCard(discount: discount, onSave: onSave.map { cb in { cb(discount.id ?? "") } })
                        .pressEffect()
                        .onTapGesture { onTap(discount.id ?? "") }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

import SwiftUI

struct DiscountPin: View {

    let discount: Discount
    let isSelected: Bool

    var pinColor: Color {
        discount.discountType == "freeItem" ? .orange : .colorPrimary
    }

    var body: some View {
        VStack(spacing: 3) {
            if isSelected {
                Text(discount.label)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(pinColor)
                    .clipShape(Capsule())
                    .shadow(color: pinColor.opacity(0.4), radius: 4, x: 0, y: 2)
            }

            ZStack {
                Circle()
                    .fill(isSelected ? pinColor : Color(.secondarySystemGroupedBackground))
                    .frame(width: isSelected ? 42 : 34, height: isSelected ? 42 : 34)
                    .shadow(color: .black.opacity(0.18), radius: 4, x: 0, y: 2)

                Image(systemName: "storefront.fill")
                    .font(.system(size: isSelected ? 18 : 13, weight: .medium))
                    .foregroundColor(isSelected ? .white : pinColor)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

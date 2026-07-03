import SwiftUI

struct MapCategoryChip: View {

    let category: DiscountCategory
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 5) {
                Image(systemName: category.icon)
                    .font(.system(size: 12, weight: .medium))
                Text(category.name)
                    .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
            }
            .foregroundColor(isSelected ? .white : .gray900)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(isSelected ? Color.colorPrimary : Color(.secondarySystemGroupedBackground))
            .clipShape(Capsule())
            .shadow(color: .black.opacity(isSelected ? 0 : 0.08), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

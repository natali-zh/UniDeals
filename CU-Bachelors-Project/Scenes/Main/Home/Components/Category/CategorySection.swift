import SwiftUI

struct CategorySection: View {
    let categories: [DiscountCategory]
    let selectedId: String
    let onSelect: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("კატეგორიები")
                .sectionTitleStyle()
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories) { category in
                        CategoryItem(
                            category: category,
                            isSelected: category.id == selectedId,
                            onTap: { onSelect(category.id) }
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

private struct CategoryItem: View {
    let category: DiscountCategory
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(isSelected ? .white : .gray700)
                    .frame(width: 60, height: 60)
                    .background(isSelected ? Color.colorPrimary : Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 2)

                Text(category.name)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? .colorPrimary : .gray700)
            }
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

import SwiftUI

struct ExploreCategoryBar: View {

    let categories: [DiscountCategory]
    let selectedIds: Set<String>
    let onToggle: (String) -> Void
    let onSelectAll: () -> Void

    private var isAllSelected: Bool { selectedIds.isEmpty }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                CategoryChip(
                    icon: "square.grid.2x2.fill",
                    title: "ყველა",
                    isSelected: isAllSelected,
                    action: onSelectAll
                )

                ForEach(categories) { category in
                    CategoryChip(
                        icon: category.icon,
                        title: category.name,
                        isSelected: selectedIds.contains(category.id),
                        action: { onToggle(category.id) }
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
        }
    }
}

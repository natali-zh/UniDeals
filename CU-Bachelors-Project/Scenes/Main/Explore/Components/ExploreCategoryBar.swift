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
                // "All" chip
                Button { onSelectAll() } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "square.grid.2x2.fill")
                            .font(.system(size: 12, weight: .medium))
                        Text("ყველა")
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundColor(isAllSelected ? .white : .gray700)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(isAllSelected ? Color.colorPrimary : Color(.systemBackground))
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(isAllSelected ? 0 : 0.05), radius: 4, x: 0, y: 1)
                }
                .buttonStyle(.plain)
                .animation(.easeInOut(duration: 0.15), value: isAllSelected)

                ForEach(categories) { category in
                    let isSelected = selectedIds.contains(category.id)
                    Button {
                        onToggle(category.id)
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: category.icon)
                                .font(.system(size: 12, weight: .medium))
                            Text(category.name)
                                .font(.system(size: 13, weight: .medium))
                        }
                        .foregroundColor(isSelected ? .white : .gray700)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(isSelected ? Color.colorPrimary : Color(.systemBackground))
                        .clipShape(Capsule())
                        .shadow(color: .black.opacity(isSelected ? 0 : 0.05), radius: 4, x: 0, y: 1)
                    }
                    .buttonStyle(.plain)
                    .animation(.easeInOut(duration: 0.15), value: isSelected)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
        }
    }
}

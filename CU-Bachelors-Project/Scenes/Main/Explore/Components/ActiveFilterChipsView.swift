import SwiftUI

struct ActiveFilterChipsView: View {

    @Binding var activeFilter: DiscountFilter
    @Binding var selectedCategoryIds: Set<String>
    let categories: [DiscountCategory]
    let onClearAll: () -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                if let sort = activeFilter.sortBy {
                    ActiveFilterChip(label: "\(sort.label) \(sort.arrow)") {
                        activeFilter.sortBy = nil
                    }
                }

                if activeFilter.discountType != .all {
                    ActiveFilterChip(label: activeFilter.discountType.rawValue) {
                        activeFilter.discountType = .all
                    }
                }

                ForEach(Array(selectedCategoryIds), id: \.self) { catId in
                    if let cat = categories.first(where: { $0.id == catId }) {
                        ActiveFilterChip(label: cat.name) {
                            selectedCategoryIds.remove(catId)
                        }
                    }
                }

                Button(action: onClearAll) {
                    Text("გასუფთავება")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.red)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.red.opacity(0.08))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
        }
    }
}

struct ActiveFilterChip: View {

    let label: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 5) {
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray900)
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.gray500)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(Capsule())
    }
}

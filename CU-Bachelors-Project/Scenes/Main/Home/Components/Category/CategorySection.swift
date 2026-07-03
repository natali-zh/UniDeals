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

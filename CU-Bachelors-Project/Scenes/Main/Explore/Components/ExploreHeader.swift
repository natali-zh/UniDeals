import SwiftUI

struct ExploreHeader: View {

    @Binding var searchQuery: String
    let hasActiveFilters: Bool
    let onFilterTap: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Text("აღმოაჩინე")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.gray900)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 16)

            HomeSearchBar(
                query: $searchQuery,
                isFilterActive: hasActiveFilters,
                onFilterTap: onFilterTap
            )
            .padding(.horizontal, 4)
            .padding(.bottom, 4)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

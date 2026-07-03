import SwiftUI

struct ExploreSegmentedControl: View {

    @Binding var selectedTab: ExploreTab

    var body: some View {
        HStack(spacing: 0) {
            segmentButton(title: "ფასდაკლებები", tab: .discounts)
            segmentButton(title: "პარტნიორები", tab: .partners)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 16)
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }

    private func segmentButton(title: String, tab: ExploreTab) -> some View {
        let isSelected = selectedTab == tab
        return Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedTab = tab
            }
        }) {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .semibold : .medium))
                .foregroundColor(isSelected ? .colorPrimary : .gray500)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? Color.colorPrimary.opacity(0.08) : Color.clear)
                        .padding(4)
                )
        }
        .buttonStyle(.plain)
    }
}

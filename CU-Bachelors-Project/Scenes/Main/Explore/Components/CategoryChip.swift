import SwiftUI

struct CategoryChip: View {

    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .medium))
                Text(title)
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

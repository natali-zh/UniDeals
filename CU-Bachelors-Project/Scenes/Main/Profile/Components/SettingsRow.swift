import SwiftUI

struct SettingsRow: View {

    let icon: String
    let iconColor: Color
    let title: String
    var titleColor: Color = .gray900
    var value: String? = nil
    var showChevron: Bool = true
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(iconColor)
                    .frame(width: 22)

                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(titleColor)

                Spacer()

                if let value {
                    Text(value)
                        .font(.system(size: 14))
                        .foregroundColor(.gray500)
                        .lineLimit(1)
                }

                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.gray300)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

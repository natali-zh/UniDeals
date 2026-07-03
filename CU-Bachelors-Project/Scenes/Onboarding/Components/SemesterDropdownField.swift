import SwiftUI

struct SemesterDropdownField: View {
    let selectedSemester: Int?
    let isOpen: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 10) {
                Image(systemName: selectedSemester != nil ? "checkmark.circle.fill" : "number")
                    .font(.system(size: 15))
                    .foregroundColor(selectedSemester != nil ? .colorPrimary : .gray500)

                Text(selectedSemester.map { "\($0) სემესტრი" } ?? "აირჩიე სემესტრი...")
                    .font(.system(size: 15))
                    .foregroundColor(selectedSemester != nil ? .gray900 : .gray500)

                Spacer()

                Image(systemName: isOpen ? "chevron.up" : "chevron.down")
                    .font(.system(size: 13))
                    .foregroundColor(.gray500)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isOpen ? Color.colorPrimary : Color.clear, lineWidth: 1.5)
            )
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

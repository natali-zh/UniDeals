import SwiftUI

struct SemesterDropdownList: View {
    let semesters: [Int]
    let selectedSemester: Int?
    let onSelect: (Int) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ForEach(semesters, id: \.self) { semester in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        onSelect(semester)
                    }
                }) {
                    HStack {
                        Text("\(semester) სემესტრი")
                            .font(.system(size: 15, weight: selectedSemester == semester ? .semibold : .regular))
                            .foregroundColor(.gray900)
                        Spacer()
                        if selectedSemester == semester {
                            Image(systemName: "checkmark")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.colorPrimary)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        selectedSemester == semester
                            ? Color.colorPrimary.opacity(0.05)
                            : Color(.secondarySystemGroupedBackground)
                    )
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if semester != semesters.last {
                    Divider().padding(.leading, 16)
                }
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
    }
}

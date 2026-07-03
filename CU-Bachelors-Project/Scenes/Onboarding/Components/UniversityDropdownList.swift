import SwiftUI

struct UniversityDropdownList: View {
    let universities: [String]
    let selectedUniversity: String?
    let onSelect: (String) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if universities.isEmpty {
                    Text("უნივერსიტეტი ვერ მოიძებნა")
                        .font(.system(size: 14))
                        .foregroundColor(.gray500)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 20)
                } else {
                    ForEach(universities, id: \.self) { university in
                        Button(action: { onSelect(university) }) {
                            HStack {
                                Text(university)
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray900)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                if selectedUniversity == university {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(.colorPrimary)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 13)
                            .background(
                                selectedUniversity == university
                                    ? Color.colorPrimary.opacity(0.05)
                                    : Color(.secondarySystemGroupedBackground)
                            )
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)

                        if university != universities.last {
                            Divider().padding(.leading, 16)
                        }
                    }
                }
            }
        }
        .frame(maxHeight: 260)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
    }
}

import SwiftUI

struct UniversitySearchField: View {
    @Binding var searchQuery: String
    @Binding var selectedUniversity: String?
    @Binding var isDropdownOpen: Bool
    @FocusState.Binding var isFocused: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: selectedUniversity != nil ? "checkmark.circle.fill" : "magnifyingglass")
                .font(.system(size: 15))
                .foregroundColor(selectedUniversity != nil ? .colorPrimary : .gray500)

            TextField("მოძებნე უნივერსიტეტი...", text: $searchQuery)
                .font(.system(size: 15))
                .foregroundColor(.gray900)
                .focused($isFocused)
                .onChange(of: isFocused) { _, focused in
                    if focused { isDropdownOpen = true }
                }
                .onChange(of: searchQuery) { _, _ in
                    if selectedUniversity != nil && searchQuery != selectedUniversity {
                        selectedUniversity = nil
                        isDropdownOpen = true
                    }
                }

            if !searchQuery.isEmpty {
                Button(action: {
                    searchQuery = ""
                    selectedUniversity = nil
                    isFocused = true
                    isDropdownOpen = true
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray500)
                }
            } else if !isFocused {
                Image(systemName: "chevron.down")
                    .font(.system(size: 13))
                    .foregroundColor(.gray500)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isFocused ? Color.colorPrimary : Color.clear, lineWidth: 1.5)
        )
        .onTapGesture { isFocused = true; isDropdownOpen = true }
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

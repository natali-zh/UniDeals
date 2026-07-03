import SwiftUI

struct UniversityPickerView: View {

    @State var viewModel: UniversityPickerViewModel
    @FocusState private var isSearchFocused: Bool
    @State private var isDropdownOpen = false

    var body: some View {
        ZStack(alignment: .top) {
            Color(.systemGroupedBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                OnboardingHeader(
                    icon: "building.columns.fill",
                    title: "შენი უნივერსიტეტი",
                    subtitle: "აირჩიე უნივერსიტეტი სტუდენტის ბარათის შესაქმნელად"
                )
                .padding(.top, 60)
                .padding(.bottom, 36)

                ZStack(alignment: .top) {
                    Color.clear.frame(height: 52)

                    if isDropdownOpen {
                        UniversityDropdownList(
                            universities: viewModel.filteredUniversities,
                            selectedUniversity: viewModel.selectedUniversity,
                            onSelect: { university in
                                viewModel.selectedUniversity = university
                                viewModel.searchQuery = university
                                isSearchFocused = false
                                isDropdownOpen = false
                            }
                        )
                        .padding(.top, 52)
                    }

                    UniversitySearchField(
                        searchQuery: $viewModel.searchQuery,
                        selectedUniversity: $viewModel.selectedUniversity,
                        isDropdownOpen: $isDropdownOpen,
                        isFocused: $isSearchFocused
                    )
                }
                .padding(.horizontal, 20)

                Spacer()

                Button(action: { viewModel.confirm() }) {
                    Text("გაგრძელება")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .primaryActionButton(verticalPadding: 16)
                }
                .disabled(viewModel.selectedUniversity == nil)
                .opacity(viewModel.selectedUniversity == nil ? 0.5 : 1)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .stickyFooter()
            }
        }
        .alert("შეცდომა", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("კარგი", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

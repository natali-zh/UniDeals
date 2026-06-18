import SwiftUI

struct UniversityPickerView: View {

    @State var viewModel: UniversityPickerViewModel
    @FocusState private var isSearchFocused: Bool
    @State private var isDropdownOpen = false

    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 0.97, green: 0.97, blue: 0.98).ignoresSafeArea()

            VStack(spacing: 0) {
                headerSection
                    .padding(.top, 60)
                    .padding(.bottom, 36)

                // Dropdown field + list in a ZStack so the list overlays content below
                ZStack(alignment: .top) {
                    // Spacer to reserve space for the field itself
                    Color.clear.frame(height: 52)

                    // Dropdown list (behind the field visually but laid out below)
                    if isDropdownOpen {
                        dropdownList
                            .padding(.top, 52)
                    }

                    // Search field on top
                    searchField
                }
                .padding(.horizontal, 20)

                Spacer()

                continueButton
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

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.colorPrimary.opacity(0.1))
                    .frame(width: 72, height: 72)
                Image(systemName: "building.columns.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.colorPrimary)
            }

            VStack(spacing: 6) {
                Text("შენი უნივერსიტეტი")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.gray900)

                Text("აირჩიე უნივერსიტეტი სტუდენტის ბარათის შესაქმნელად")
                    .font(.system(size: 14))
                    .foregroundColor(.gray500)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
    }

    // MARK: - Search field

    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: viewModel.selectedUniversity != nil ? "checkmark.circle.fill" : "magnifyingglass")
                .font(.system(size: 15))
                .foregroundColor(viewModel.selectedUniversity != nil ? .colorPrimary : .gray500)

            TextField("მოძებნე უნივერსიტეტი...", text: $viewModel.searchQuery)
                .font(.system(size: 15))
                .foregroundColor(.gray900)
                .focused($isSearchFocused)
                .onChange(of: isSearchFocused) { _, focused in
                    if focused { isDropdownOpen = true }
                }
                .onChange(of: viewModel.searchQuery) { _, _ in
                    if viewModel.selectedUniversity != nil &&
                       viewModel.searchQuery != viewModel.selectedUniversity {
                        viewModel.selectedUniversity = nil
                        isDropdownOpen = true
                    }
                }

            if !viewModel.searchQuery.isEmpty {
                Button {
                    viewModel.searchQuery = ""
                    viewModel.selectedUniversity = nil
                    isSearchFocused = true
                    isDropdownOpen = true
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray500)
                }
            } else if !isSearchFocused {
                Image(systemName: "chevron.down")
                    .font(.system(size: 13))
                    .foregroundColor(.gray500)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isSearchFocused ? Color.colorPrimary : Color.clear, lineWidth: 1.5)
        )
        .onTapGesture { isSearchFocused = true; isDropdownOpen = true }
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }

    // MARK: - Dropdown list

    private var dropdownList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if viewModel.filteredUniversities.isEmpty {
                    Text("უნივერსიტეტი ვერ მოიძებნა")
                        .font(.system(size: 14))
                        .foregroundColor(.gray500)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 20)
                } else {
                    ForEach(viewModel.filteredUniversities, id: \.self) { university in
                        Button {
                            viewModel.selectedUniversity = university
                            viewModel.searchQuery = university
                            isSearchFocused = false
                            isDropdownOpen = false
                        } label: {
                            HStack {
                                Text(university)
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray900)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                if viewModel.selectedUniversity == university {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(.colorPrimary)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 13)
                            .background(viewModel.selectedUniversity == university
                                ? Color.colorPrimary.opacity(0.05)
                                : Color.white)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)

                        if university != viewModel.filteredUniversities.last ?? "" {
                            Divider().padding(.leading, 16)
                        }
                    }
                }
            }
        }
        .frame(maxHeight: 260)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
    }

    // MARK: - Continue button

    private var continueButton: some View {
        Button {
            viewModel.confirm()
        } label: {
            Text("გაგრძელება")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .primaryActionButton(verticalPadding: 16)
        }
        .disabled(viewModel.selectedUniversity == nil)
        .opacity(viewModel.selectedUniversity == nil ? 0.5 : 1)
    }
}

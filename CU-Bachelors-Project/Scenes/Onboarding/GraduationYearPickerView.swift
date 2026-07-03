import SwiftUI

struct GraduationYearPickerView: View {

    @State var viewModel: GraduationYearPickerViewModel
    @State private var isDropdownOpen = false

    var body: some View {
        VStack(spacing: 0) {
            headerSection
                .padding(.top, 60)
                .padding(.bottom, 36)

            ZStack(alignment: .top) {
                Color.clear.frame(height: 52)

                if isDropdownOpen {
                    dropdownList
                        .padding(.top, 52)
                }

                dropdownField
            }
            .padding(.horizontal, 20)

            Spacer()

            continueButton
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .stickyFooter()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
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
                Image(systemName: "graduationcap.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.colorPrimary)
            }

            VStack(spacing: 6) {
                Text("მიმდინარე სემესტრი")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.gray900)

                Text("მიუთითე მიმდინარე სასწავლო სემესტრი")
                    .font(.system(size: 14))
                    .foregroundColor(.gray500)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
    }

    // MARK: - Dropdown field

    private var dropdownField: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                isDropdownOpen.toggle()
            }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: viewModel.selectedSemester != nil ? "checkmark.circle.fill" : "number")
                    .font(.system(size: 15))
                    .foregroundColor(viewModel.selectedSemester != nil ? .colorPrimary : .gray500)

                Text(viewModel.selectedSemester.map { "\($0) სემესტრი" } ?? "აირჩიე სემესტრი...")
                    .font(.system(size: 15))
                    .foregroundColor(viewModel.selectedSemester != nil ? .gray900 : .gray500)

                Spacer()

                Image(systemName: isDropdownOpen ? "chevron.up" : "chevron.down")
                    .font(.system(size: 13))
                    .foregroundColor(.gray500)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isDropdownOpen ? Color.colorPrimary : Color.clear, lineWidth: 1.5)
            )
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Dropdown list

    private var dropdownList: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.semesters, id: \.self) { semester in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.selectedSemester = semester
                        isDropdownOpen = false
                    }
                } label: {
                    HStack {
                        Text("\(semester) სემესტრი")
                            .font(.system(size: 15, weight: viewModel.selectedSemester == semester ? .semibold : .regular))
                            .foregroundColor(.gray900)
                        Spacer()
                        if viewModel.selectedSemester == semester {
                            Image(systemName: "checkmark")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.colorPrimary)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(viewModel.selectedSemester == semester ? Color.colorPrimary.opacity(0.05) : Color(.secondarySystemGroupedBackground))
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if semester != viewModel.semesters.last {
                    Divider().padding(.leading, 16)
                }
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
    }

    // MARK: - Continue button

    private var continueButton: some View {
        Button {
            Task { await viewModel.confirm() }
        } label: {
            Group {
                if viewModel.isSaving {
                    ProgressView().tint(.white)
                } else {
                    Text("გაგრძელება")
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            .foregroundColor(.white)
            .primaryActionButton(verticalPadding: 16)
        }
        .disabled(viewModel.selectedSemester == nil || viewModel.isSaving)
        .opacity(viewModel.selectedSemester == nil ? 0.5 : 1)
    }
}

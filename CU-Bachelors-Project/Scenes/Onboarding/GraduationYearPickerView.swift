import SwiftUI

struct GraduationYearPickerView: View {

    @State var viewModel: GraduationYearPickerViewModel
    @State private var isDropdownOpen = false

    var body: some View {
        VStack(spacing: 0) {
            OnboardingHeader(
                icon: "graduationcap.fill",
                title: "მიმდინარე სემესტრი",
                subtitle: "მიუთითე მიმდინარე სასწავლო სემესტრი"
            )
            .padding(.top, 60)
            .padding(.bottom, 36)

            ZStack(alignment: .top) {
                Color.clear.frame(height: 52)

                if isDropdownOpen {
                    SemesterDropdownList(
                        semesters: viewModel.semesters,
                        selectedSemester: viewModel.selectedSemester,
                        onSelect: { semester in
                            viewModel.selectedSemester = semester
                            isDropdownOpen = false
                        }
                    )
                    .padding(.top, 52)
                }

                SemesterDropdownField(
                    selectedSemester: viewModel.selectedSemester,
                    isOpen: isDropdownOpen,
                    onTap: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isDropdownOpen.toggle()
                        }
                    }
                )
            }
            .padding(.horizontal, 20)

            Spacer()

            Button(action: { Task { await viewModel.confirm() } }) {
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
}

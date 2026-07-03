import SwiftUI

struct ProfileView: View {
    
    //MARK: - Properties
    
    @State private var viewModel: ProfileViewModel
    @State private var showLogOutAlert = false
    @State private var showEditNameAlert = false
    @State private var editNameText = ""
    
    //MARK: - Init
    
    init(viewModel: ProfileViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    //MARK: - Body
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ProfileHeaderView(
                    user: viewModel.user,
                    isUploading: viewModel.isUploadingPhoto,
                    onImageSelected: { image in Task { await viewModel.uploadPhoto(image) } },
                    onNameTap: {
                        editNameText = viewModel.user?.fullname ?? ""
                        showEditNameAlert = true
                    }
                )
                .padding(.bottom, 32)
                
                accountSection
                    .padding(.bottom, 12)
                
                VStack(spacing: 0) {
                    AppearancePicker()
                }
                .settingsCard()
                .padding(.bottom, 12)
                
                logOutSection
                
                Text(viewModel.appVersion)
                    .font(.system(size: 12))
                    .foregroundColor(.gray300)
                    .padding(.top, 32)
                    .padding(.bottom, 16)
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(false)
        .navigationTitle("პარამეტრები")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
        .alert("სახელის შეცვლა", isPresented: $showEditNameAlert) {
            TextField("სახელი და გვარი", text: $editNameText)
            Button("გაუქმება", role: .cancel) {}
            Button("შენახვა") {
                Task { await viewModel.updateName(editNameText) }
            }
        } message: {
            Text("შეიყვანე შენი სახელი და გვარი")
        }
        .alert("გასვლა", isPresented: $showLogOutAlert) {
            Button("გაუქმება", role: .cancel) {}
            Button("გასვლა", role: .destructive) { viewModel.logOut() }
        } message: {
            Text("დარწმუნებული ხარ, რომ გსურს გასვლა?")
        }
        .alert("შეცდომა", isPresented: Binding(
            get: { viewModel.uploadError != nil },
            set: { if !$0 { viewModel.uploadError = nil } }
        )) {
            Button("კარგი", role: .cancel) {}
        } message: {
            Text(viewModel.uploadError ?? "")
        }
    }
    
    //MARK: - Subviews
    
    private var accountSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            SettingsRow(
                icon: "building.columns.fill",
                iconColor: .gray500,
                title: "უნივერსიტეტი",
                value: viewModel.universityDisplay
            ) {
                viewModel.onEditUniversity?()
            }
            Divider().padding(.leading, 20)
            SettingsRow(
                icon: "graduationcap.fill",
                iconColor: .gray500,
                title: "სემესტრი",
                value: viewModel.semesterDisplay
            ) {
                viewModel.onEditSemester?()
            }
        }
        .settingsCard()
    }
    
    private var logOutSection: some View {
        VStack(spacing: 0) {
            SettingsRow(
                icon: "rectangle.portrait.and.arrow.right",
                iconColor: .red,
                title: "გასვლა",
                titleColor: .red,
                showChevron: false
            ) {
                showLogOutAlert = true
            }
        }
        .settingsCard()
    }
}
